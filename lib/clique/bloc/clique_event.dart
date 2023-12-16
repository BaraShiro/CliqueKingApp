part of 'clique_bloc.dart';

/// Base class for Clique Events.
@immutable
sealed class CliqueEvent {}

/// Load a clique.
final class CliqueLoad extends CliqueEvent {
  final CliqueId cliqueId;

  CliqueLoad({required this.cliqueId});
}

/// Increase the score of a user in the clique.
final class CliqueIncreaseScore extends CliqueEvent {
  final CliqueId cliqueId;
  final int increase;

  CliqueIncreaseScore({required this.cliqueId, required this.increase});
}

/// Add a user to a clique.
final class CliqueJoin extends CliqueEvent {
  final CliqueId cliqueId;

  CliqueJoin({required this.cliqueId});
}

/// Remove a user from the clique.
final class CliqueLeave extends CliqueEvent {
  final CliqueId cliqueId;

  CliqueLeave({required this.cliqueId});
}
