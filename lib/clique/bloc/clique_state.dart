part of 'clique_bloc.dart';

/// Base class for Clique States.
@immutable
sealed class CliqueState extends Equatable {}

/// Initial clique State.
final class CliqueInitial extends CliqueState {
  @override
  List<Object?> get props => [];
}

/// Loading of a clique has started.
final class CliqueLoadingInProgress extends CliqueState {
  @override
  List<Object?> get props => [];
}

/// Loading of a clique was successful.
final class CliqueLoadingSuccess extends CliqueState {
  final Clique clique;
  final List<Score> allScoresSorted;

  CliqueLoadingSuccess({
    required this.clique,
    required this.allScoresSorted,
  });

  @override
  List<Object?> get props => [clique, allScoresSorted];
}

/// Loading of a clique has failed.
final class CliqueLoadingFailure extends CliqueState {
  final RepositoryError error;

  CliqueLoadingFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

/// Increase the score of a user has started.
final class CliqueIncreaseScoreInProgress extends CliqueState {
  @override
  List<Object?> get props => [];
}

/// Increase the score of a user was successful.
final class CliqueIncreaseScoreSuccess extends CliqueState {
  @override
  List<Object?> get props => [];
}

/// Increase the score of a user has failed.
final class CliqueIncreaseScoreFailure extends CliqueState {
  final RepositoryError error;

  CliqueIncreaseScoreFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

/// A user joining a clique a user has started.
final class CliqueJoinInProgress extends CliqueState {
  @override
  List<Object?> get props => [];
}

/// A user joining a clique a user was successful.
final class CliqueJoinSuccess extends CliqueState {
  @override
  List<Object?> get props => [];
}

/// A user joining a clique a user has failed.
final class CliqueJoinFailure extends CliqueState {
  final RepositoryError error;

  CliqueJoinFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

/// A user leaving a clique a user has started.
final class CliqueLeaveInProgress extends CliqueState {
  @override
  List<Object?> get props => [];
}

/// A user leaving a clique a user was successful.
final class CliqueLeaveSuccess extends CliqueState {
  @override
  List<Object?> get props => [];
}

/// A user leaving a clique a user has failed.
final class CliqueLeaveFailure extends CliqueState {
  final RepositoryError error;

  CliqueLeaveFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
