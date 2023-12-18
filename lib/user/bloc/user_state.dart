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

/// User action in progress.
final class UserInProgress extends UserState {}

/// Login user was successful.
final class UserLoginSuccess extends UserState {
  final User user;

  const UserLoginSuccess({required this.user});
}

/// Login user has failed.
final class UserLoginFailure extends UserState {
  final RepositoryError error;

  const UserLoginFailure({required this.error});
}

/// Register user was successful.
final class UserRegisterSuccess extends UserState {
  final User user;

  const UserRegisterSuccess({required this.user});
}

/// Register user has failed.
final class UserRegisterFailure extends UserState {
  final RepositoryError error;

  const UserRegisterFailure({required this.error});
}

/// Update user was successful.
final class UserUpdateSuccess extends UserState {
  final User user;

  const UserUpdateSuccess({required this.user});
}

/// Update user has failed.
final class UserUpdateFailure extends UserState {
  final RepositoryError error;

  const UserUpdateFailure({required this.error});
}

/// Delete user was successful.
final class UserDeleteSuccess extends UserState {}

/// Delete user has failed.
final class UserDeleteFailure extends UserState {
  final RepositoryError error;

  const UserDeleteFailure({required this.error});
}
