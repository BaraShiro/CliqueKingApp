part of 'clique_bloc.dart';

/// Base class for Clique Side Effects.
@immutable
sealed class CliqueSideEffect {}

/// Increase the score of a user was successful.
final class CliqueIncreaseScoreSuccess extends CliqueSideEffect {
  final int increase;

  CliqueIncreaseScoreSuccess({required this.increase});
}

/// Increase the score of a user has failed.
final class CliqueIncreaseScoreFailure extends CliqueSideEffect {
  final RepositoryError error;

  CliqueIncreaseScoreFailure({required this.error});
}

/// A user joining a clique a user was successful.
final class CliqueJoinSuccess extends CliqueSideEffect {}

/// A user joining a clique a user has failed.
final class CliqueJoinFailure extends CliqueSideEffect {
  final RepositoryError error;

  CliqueJoinFailure({required this.error});
}

/// A user leaving a clique a user was successful.
final class CliqueLeaveSuccess extends CliqueSideEffect {}

/// A user leaving a clique a user has failed.
final class CliqueLeaveFailure extends CliqueSideEffect {
  final RepositoryError error;

  CliqueLeaveFailure({required this.error});
}