import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clique_king/clique_king.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:fpdart/fpdart.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

part 'cliques_event.dart';
part 'cliques_state.dart';
part 'cliques_side_effect.dart';

/// The Cliques Bloc class.
final class CliquesBloc extends SideEffectBloc<CliquesEvent, CliquesState, CliquesSideEffect> {
  final CliqueRepository _cliqueRepo;
  final AuthenticationRepository _authRepo;

  CliquesBloc({required CliqueRepository cliqueRepository,
              required AuthenticationRepository authenticationRepository})
      : _cliqueRepo = cliqueRepository,
        _authRepo = authenticationRepository,
        super(CliquesInitial()) {
    on<CliquesEvent>(
      (CliquesEvent event, Emitter<CliquesState> emit) async {
        switch (event) {
          case CliquesLoad():
            await _handleCliquesLoadEvent(event: event, emit: emit);
          case AddClique():
            await _handleAddCliqueEvent(event: event, emit: emit);
          case RemoveClique():
            await _handleRemoveCliqueEvent(event: event, emit: emit);
        }
      },
    );
  }

  /// Handles Cliques Load Event.
  ///
  /// Emits either:
  /// * [CliquesLoadingFailure] if unable to read cliques stream.
  /// * [CliquesLoadingSuccess] if cliques stream were read successfully.
  Future<void> _handleCliquesLoadEvent({required CliquesLoad event, required Emitter<CliquesState> emit}) async {
    Either<RepositoryError, User> userResult = await _authRepo.getLoggedInUser();

    await userResult.match(
            (l) async => emit(CliquesLoadingFailure(error: l)),
            (rUser) async {
              Either<RepositoryError, Stream<List<Clique>>> result = _cliqueRepo.readAllCliques();

              await result.match(
                      (l) async => emit(CliquesLoadingFailure(error: l)),
                      (r) async => emit.forEach(r, onData: (List<Clique> cliques) => CliquesLoadingSuccess(cliques: cliques, user: rUser))
              );
            }
    );
  }

  /// Handles Add Clique Event.
  ///
  /// Produces either:
  /// * [CliqueAddFailure] if unable to read logged in user or write new clique.
  /// * [CliqueAddSuccess] if new clique were successfully written.
  Future<void> _handleAddCliqueEvent({required AddClique event, required Emitter<CliquesState> emit}) async {
    // emit(AddCliqueInProgress());
    // TODO: Check for name collision
    // TODO: Sanitize name

    Either<RepositoryError, User> userResult = await _authRepo.getLoggedInUser();

    await userResult.match(
            (l) async => produceSideEffect(CliqueAddFailure(error: l)),
            (rUser) async {
              Either<RepositoryError, Clique> result = await _cliqueRepo.createClique(name: event.name, creatorId: rUser.id);

              result.match(
                      (l) => produceSideEffect(CliqueAddFailure(error: l)),
                      (rClique) => produceSideEffect(CliqueAddSuccess(clique: rClique))
              );
            }
    );

  }

  /// Handles Remove Clique Event
  ///
  /// Produces either:
  /// * [CliqueRemoveFailure] if unable to read clique or logged in user,
  /// unable to delete clique, or if user lacks permission to delete clique.
  /// * [CliqueRemoveSuccess] if clique was deleted successfully.
  Future<void> _handleRemoveCliqueEvent({required RemoveClique event, required Emitter<CliquesState> emit}) async {
    // emit(RemoveCliqueInProgress());

    Either<RepositoryError, User> userResult = await _authRepo.getLoggedInUser();

    bool userHasPermission = false;
    bool error = await userResult.match(
            (l) async {
              produceSideEffect(CliqueRemoveFailure(error: l));
              return true;
            },
            (rUser) async {
              Either<RepositoryError, Clique> cliqueResult = await _cliqueRepo.getClique(cliqueId: event.cliqueId);

              return cliqueResult.match(
                      (l) {
                        produceSideEffect(CliqueRemoveFailure(error: l));
                        return true;
                      },
                      (rClique) {
                        userHasPermission = rClique.creatorId == rUser.id;
                        return false;
                      }
              );
            }
    );

    if(error) return;

    if(userHasPermission) {
      Option<RepositoryError> result = await _cliqueRepo.deleteClique(cliqueId: event.cliqueId);

      result.match(
              () => produceSideEffect(CliqueRemoveSuccess()),
              (t) => produceSideEffect(CliqueRemoveFailure(error: t))
      );
    } else {
      RepositoryError error = const UserPermissionViolation(errorObject: "Only the creator of a clique can delete it.");
      produceSideEffect(CliqueRemoveFailure(error: error));
    }

  }

}
