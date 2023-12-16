part of 'user_bloc.dart';

/// Base class for User State.
@immutable
sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Initial User State.
final class UserInitial extends UserState {}

/// The user authentication status has changed.
final class UserAuthenticationChanged extends UserState {
  final auth.User? user;

  const UserAuthenticationChanged({required this.user});

  @override
  List<Object> get props => user != null ? [user!] : [];
}

/// There was an error retrieving the user authentication status.
final class UserAuthenticationError extends UserState {
  final Object error;

  const UserAuthenticationError({required this.error});

  @override
  List<Object> get props => [error];
}
