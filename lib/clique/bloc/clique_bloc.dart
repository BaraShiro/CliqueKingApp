import 'package:bloc/bloc.dart';
import 'package:clique_king/clique_king.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:fpdart/fpdart.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:collection/collection.dart';

part 'clique_event.dart';
part 'clique_state.dart';
part 'clique_side_effect.dart';

/// The Clique Bloc class.
final class CliqueBloc extends SideEffectBloc<CliqueEvent, CliqueState, CliqueSideEffect> {
  final CliqueRepository _cliqueRepo;
  final AuthenticationRepository _authRepo;

  CliqueBloc(
      {required CliqueRepository cliqueRepository,
        required AuthenticationRepository authenticationRepository})
      : _cliqueRepo = cliqueRepository,
        _authRepo = authenticationRepository,
        super(CliqueInitial()) {
    on<CliqueEvent>(
      (CliqueEvent event, Emitter<CliqueState>emit) async {
        switch (event) {
          case CliqueLoad():
            await _handleCliqueLoadEvent(event: event, emit: emit);
          case CliqueIncreaseScore():
            await _handleCliqueIncreaseScoreEvent(event: event, emit: emit);
          case CliqueJoin():
            await  _handleCliqueJoinEvent(event: event, emit: emit);
          case CliqueLeave():
            await _handleCliqueLeaveEvent(event: event, emit: emit);
        }
      },
    );
  }

  /// Handles Clique Load Events.
  ///
  /// Emits [CliqueLoadingInProgress], and then emits either:
  /// * [CliqueLoadingFailure] if unable to read the clique or the stream the
  /// clique scores.
  /// * [CliqueLoadingSuccess] if the clique and the clique scores were
  /// successfully read.
  Future<void> _handleCliqueLoadEvent({required CliqueLoad event, required Emitter<CliqueState> emit}) async {
    Either<RepositoryError, User> userResult = await _authRepo.getLoggedInUser();
    await userResult.match(
            (l) async => emit(CliqueLoadingFailure(error: l)),
            (rUser) async {

              Either<RepositoryError, Clique> cliqueResult = await _cliqueRepo.getClique(cliqueId: event.cliqueId);

              await cliqueResult.match(
                      (l) async => emit(CliqueLoadingFailure(error: l)),
                      (rClique) async {
                    Either<RepositoryError, Stream<List<Score>>> scoreResult = _cliqueRepo.readScoresFromClique(cliqueId: event.cliqueId);

                    await scoreResult.match(
                            (l) async => emit(CliqueLoadingFailure(error: l)),
                            (rStream) async => emit.forEach(rStream, onData: (List<Score> scores) {
                          scores.sort((a, b) => a.score > b.score ? -1 : 1);
                          bool isInClique = scores.firstWhereOrNull((score) => score.userId == rUser.id) != null;
                          return CliqueLoadingSuccess(clique: rClique, allScoresSorted: scores, isInClique: isInClique);
                        })
                    );
                  }
              );
            }
    );

  }

  /// Handles Clique Increase Score Events.
  ///
  /// Emits [CliqueIncreaseScoreInProgress], and then emits either:
  /// * [CliqueIncreaseScoreFailure] if unable to read or increase the score.
  /// * [CliqueIncreaseScoreSuccess] if the score was successfully read and increased.
  Future<void> _handleCliqueIncreaseScoreEvent({required CliqueIncreaseScore event, required Emitter<CliqueState> emit}) async {
    Either<RepositoryError, User> userResult = await _authRepo.getLoggedInUser();

    await userResult.match(
            (l) async => produceSideEffect(CliqueIncreaseScoreFailure(error: l)),
            (r) async {
              Either<RepositoryError, Score> scoreResult = await _cliqueRepo.getScore(cliqueId: event.cliqueId, userId: r.id);

              await scoreResult.match(
                      (l) async => produceSideEffect(CliqueIncreaseScoreFailure(error: l)),
                      (r) async {
                        Option<RepositoryError> updateResult = await _cliqueRepo.increaseScore(cliqueId: event.cliqueId, score: r, scoreIncrease: event.increase);

                    updateResult.match(
                            () => produceSideEffect(CliqueIncreaseScoreSuccess(increase: event.increase)),
                            (t) =>  produceSideEffect(CliqueIncreaseScoreFailure(error: t))
                    );
                  }
              );
            }
    );
  }

  /// Handles Clique Join Events.
  ///
  /// Emits [CliqueJoinInProgress], and then emits either:
  /// * [CliqueJoinFailure] if unable to add the user to the clique.
  /// * [CliqueJoinSuccess] if the user was successfully added to the clique.
  Future<void> _handleCliqueJoinEvent({required CliqueJoin event, required Emitter<CliqueState> emit}) async {
    Either<RepositoryError, User> userResult = await _authRepo.getLoggedInUser();

    await userResult.match(
            (l) async => produceSideEffect(CliqueJoinFailure(error: l)),
            (r) async {
              Option<RepositoryError> result = await _cliqueRepo.addUser(cliqueId: event.cliqueId, user: r);

              result.match(
                      () => produceSideEffect(CliqueJoinSuccess()),
                      (t) => produceSideEffect(CliqueJoinFailure(error: t))
              );
            }
    );
  }

  /// Handles Clique leave Events.
  ///
  /// Emits [CliqueLeaveInProgress], and then emits either:
  /// * [CliqueLeaveFailure] if unable to remove the user from the clique.
  /// * [CliqueLeaveSuccess] if the user was successfully removed from the clique.
  Future<void> _handleCliqueLeaveEvent({required CliqueLeave event, required Emitter<CliqueState> emit}) async {
    Either<RepositoryError, User> userResult = await _authRepo.getLoggedInUser();

    await userResult.match(
            (l) async => produceSideEffect(CliqueLeaveFailure(error: l)),
            (r) async {
              Option<RepositoryError> result = await _cliqueRepo.removeUser(cliqueId: event.cliqueId, userId: r.id);

              result.match(
                      () => produceSideEffect(CliqueLeaveSuccess()),
                      (t) => produceSideEffect(CliqueLeaveFailure(error: t))
              );
        }
    );
  }

}
