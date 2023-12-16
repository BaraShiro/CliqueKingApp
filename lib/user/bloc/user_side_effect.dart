part of 'user_bloc.dart';

/// Base class for User Side Effects.
@immutable
sealed class UserSideEffect {}

/// Login user was successful.
final class UserLoginSuccess extends UserSideEffect {
  final User user;

  UserLoginSuccess({required this.user});
}

/// Login user has failed.
final class UserLoginFailure extends UserSideEffect {
  final RepositoryError error;

  UserLoginFailure({required this.error});
}

/// Register user was successful.
final class UserRegisterSuccess extends UserSideEffect {
  final User user;

  UserRegisterSuccess({required this.user});
}

/// Register user has failed.
final class UserRegisterFailure extends UserSideEffect {
  final RepositoryError error;

  UserRegisterFailure({required this.error});
}

/// Update user was successful.
final class UserUpdateSuccess extends UserSideEffect {
  final User user;

  UserUpdateSuccess({required this.user});
}

/// Update user has failed.
final class UserUpdateFailure extends UserSideEffect {
  final RepositoryError error;

  UserUpdateFailure({required this.error});
}

/// Logout user was successful.
final class UserLogoutSuccess extends UserSideEffect {}

/// Logout user has failed.
final class UserLogoutFailure extends UserSideEffect {
  final RepositoryError error;

  UserLogoutFailure({required this.error});
}

/// Delete user was successful.
final class UserDeleteSuccess extends UserSideEffect {}

/// Delete user has failed.
final class UserDeleteFailure extends UserSideEffect {
  final RepositoryError error;

  UserDeleteFailure({required this.error});
}