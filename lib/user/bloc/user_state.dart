part of 'user_bloc.dart';

/// Base class for User State.
@immutable
sealed class UserState extends Equatable {}

/// Initial User State.
final class UserInitial extends UserState {
  @override
  List<Object?> get props => [];
}

/// Login user has started.
final class UserLoginInProgress extends UserState {
  @override
  List<Object?> get props => [];
}

/// Login user was successfull.
final class UserLoginSuccess extends UserState {
  final User user;

  UserLoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Login user has failed.
final class UserLoginFailure extends UserState {
  final RepositoryError error;

  UserLoginFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

/// Register user has started.
final class UserRegisterInProgress extends UserState {
  @override
  List<Object?> get props => [];
}

/// Register user was successful.
final class UserRegisterSuccess extends UserState {
  final User user;

  UserRegisterSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Register user has failed.
final class UserRegisterFailure extends UserState {
  final RepositoryError error;

  UserRegisterFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

/// Update user has started.
final class UserUpdateInProgress extends UserState {
  @override
  List<Object?> get props => [];
}

/// Update user was successful.
final class UserUpdateSuccess extends UserState {
  final User user;

  UserUpdateSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Update user has failed.
final class UserUpdateFailure extends UserState {
  final RepositoryError error;

  UserUpdateFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

/// Logout user has started.
final class UserLogoutInProgress extends UserState {
  @override
  List<Object?> get props => [];
}

/// Logout user was successful.
final class UserLogoutSuccess extends UserState {
  @override
  List<Object?> get props => [];
}

/// Logout user has failed.
final class UserLogoutFailure extends UserState {
  final RepositoryError error;

  UserLogoutFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

/// Delete user has started.
final class UserDeleteInProgress extends UserState {
  @override
  List<Object?> get props => [];
}

/// Delete user was successful.
final class UserDeleteSuccess extends UserState {
  @override
  List<Object?> get props => [];
}

/// Delete user has failed.
final class UserDeleteFailure extends UserState {
  final RepositoryError error;

  UserDeleteFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
