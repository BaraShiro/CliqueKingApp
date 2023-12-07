part of 'cliques_bloc.dart';

/// Base class for Cliques States.
@immutable
sealed class CliquesState extends Equatable {}

/// Initial Cliques State.
final class CliquesInitial extends CliquesState {
  @override
  List<Object?> get props => [];
}

final class CliquesStateInProgress extends CliquesState {
  @override
  List<Object?> get props => [];
}

/// Remove a clique has failed.
final class CliquesStateFailure extends CliquesState {
  final RepositoryError error;

  CliquesStateFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

/// Loading of all cliques has started.
final class CliquesLoadingInProgress extends CliquesStateInProgress {}

/// Loading of all cliques was successful.
final class CliquesLoadingSuccess extends CliquesState {
  final List<Clique> cliques;

  CliquesLoadingSuccess({required this.cliques});

  @override
  List<Object?> get props => [cliques];
}

/// Loading of all cliques has failed.
final class CliquesLoadingFailure extends CliquesStateFailure {
  CliquesLoadingFailure({required super.error});
}

/// Add a new clique has started.
final class AddCliqueInProgress extends CliquesStateInProgress {}

/// Add a new clique was successful.
final class AddCliqueSuccess extends CliquesState {
  final Clique clique;

  AddCliqueSuccess({required this.clique});

  @override
  List<Object?> get props => [];
}

/// Add a new clique has failed.
final class AddCliqueFailure extends CliquesStateFailure {
  AddCliqueFailure({required super.error});
}

/// Remove a clique has started.
final class RemoveCliqueInProgress extends CliquesStateInProgress {}

/// Remove a clique was successful.
final class RemoveCliqueSuccess extends CliquesState {
  @override
  List<Object?> get props => [];
}

/// Remove a clique has failed.
final class RemoveCliqueFailure extends CliquesStateFailure {
   RemoveCliqueFailure({required super.error});
}
