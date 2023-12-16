part of 'clique_bloc.dart';

/// Base class for Clique States.
@immutable
sealed class CliqueState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial clique State.
final class CliqueInitial extends CliqueState {}

/// Loading of a clique was successful.
final class CliqueLoadingSuccess extends CliqueState {
  final Clique clique;
  final List<Score> allScoresSorted;
  final bool isInClique;

  CliqueLoadingSuccess({
    required this.clique,
    required this.allScoresSorted,
    required this.isInClique,
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

