import 'package:bloc/bloc.dart';
import 'package:clique_king/clique_king.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:fpdart/fpdart.dart';

part 'clique_event.dart';
part 'clique_state.dart';

/// The Clique Bloc class.
final class CliqueBloc extends Bloc<CliqueEvent, CliqueState> {
  final CliqueRepository _cliqueRepo;

  CliqueBloc(
      {required CliqueRepository cliqueRepository})
      : _cliqueRepo = cliqueRepository,
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
    emit(CliqueLoadingInProgress());

    Either<RepositoryError, Clique> cliqueResult = await _cliqueRepo.getClique(cliqueId: event.cliqueId);

    await cliqueResult.match(
            (l) async => emit(CliqueLoadingFailure(error: l)),
            (rClique) async {
              Either<RepositoryError, Stream<List<Score>>> scoreResult = _cliqueRepo.readScoresFromClique(cliqueId: event.cliqueId);

              await scoreResult.match(
                      (l) async => emit(CliqueLoadingFailure(error: l)),
                      (rStream) async => emit.forEach(rStream, onData: (List<Score> scores) {
                        scores.sort((a, b) => a.score > b.score ? -1 : 1);
                        return CliqueLoadingSuccess(clique: rClique, allScoresSorted: scores);
                      })
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
    emit(CliqueIncreaseScoreInProgress());

    Either<RepositoryError, Score> scoreResult = await _cliqueRepo.getScore(cliqueId: event.cliqueId, userId: event.user.id);

    await scoreResult.match(
            (l) async => emit(CliqueIncreaseScoreFailure(error: l)),
            (r) async {
              Option<RepositoryError> updateResult = await _cliqueRepo.increaseScore(cliqueId: event.cliqueId, score: r, scoreIncrease: event.increase);

              updateResult.match(
                      () => emit(CliqueIncreaseScoreSuccess()),
                      (t) =>  emit(CliqueIncreaseScoreFailure(error: t))
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
    emit(CliqueJoinInProgress());

    Option<RepositoryError> result = await _cliqueRepo.addUser(cliqueId: event.cliqueId, user: event.user);

    result.match(
            () => emit(CliqueJoinSuccess()),
            (t) => emit(CliqueJoinFailure(error: t))
    );
  }

  /// Handles Clique leave Events.
  ///
  /// Emits [CliqueLeaveInProgress], and then emits either:
  /// * [CliqueLeaveFailure] if unable to remove the user from the clique.
  /// * [CliqueLeaveSuccess] if the user was successfully removed from the clique.
  Future<void> _handleCliqueLeaveEvent({required CliqueLeave event, required Emitter<CliqueState> emit}) async {
    emit(CliqueLeaveInProgress());

    Option<RepositoryError> result = await _cliqueRepo.removeUser(cliqueId: event.cliqueId, userId: event.user.id);

    result.match(
            () => emit(CliqueLeaveSuccess()),
            (t) => emit(CliqueLeaveFailure(error: t))
    );
  }

}
