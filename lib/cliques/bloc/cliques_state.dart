part of 'cliques_bloc.dart';

/// Base class for Cliques States.
@immutable
sealed class CliquesState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial Cliques State.
final class CliquesInitial extends CliquesState {}

/// Loading of all cliques was successful.
final class CliquesLoadingSuccess extends CliquesState {
  final List<Clique> cliques;

  CliquesLoadingSuccess({required this.cliques});

  @override
  List<Object?> get props => [cliques];
}

/// Loading of all cliques has failed.
final class CliquesLoadingFailure extends CliquesState {
  final RepositoryError error;

  CliquesLoadingFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

