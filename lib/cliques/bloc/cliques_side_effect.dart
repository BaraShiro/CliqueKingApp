part of 'cliques_bloc.dart';

/// Base class for Cliques Side Effects.
@immutable
sealed class CliquesSideEffect {}

/// Clique successfully added.
final class CliqueAddSuccess extends CliquesSideEffect {
  final Clique clique;

  CliqueAddSuccess({required this.clique});
}

/// Failed to add clique.
final class CliqueAddFailure extends CliquesSideEffect {
  final RepositoryError error;

  CliqueAddFailure({required this.error});
}

/// Clique successfully removed.
final class CliqueRemoveSuccess extends CliquesSideEffect {}

/// Failed to remove clique.
final class CliqueRemoveFailure extends CliquesSideEffect {
  final RepositoryError error;

  CliqueRemoveFailure({required this.error});
}