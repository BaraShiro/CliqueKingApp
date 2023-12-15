part of 'cliques_bloc.dart';

/// Base class for Cliques Events.
@immutable
sealed class CliquesEvent {}

/// Load all cliques.
final class CliquesLoad extends CliquesEvent {}

/// Add a new clique.
final class AddClique extends CliquesEvent {
  final String name;

  AddClique({required this.name});
}

/// Remove a clique.
final class RemoveClique extends CliquesEvent {
  final CliqueId cliqueId;

  RemoveClique({required this.cliqueId});
}
