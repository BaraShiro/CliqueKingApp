part of 'user_bloc.dart';

/// Base class for User Events
@immutable
sealed class UserEvent {}

/// Register a user.
final class UserRegister extends UserEvent {
  final String email;
  final String password;
  final String name;

  UserRegister({
    required this.email,
    required this.password,
    required this.name
  });
}

/// Update a user.
final class UserUpdate extends UserEvent {
  final String name;

  UserUpdate({required this.name});
}

/// Log in a user.
final class UserLogin extends UserEvent {
  final String email;
  final String password;

  UserLogin({required this.email, required this.password});
}

/// Delete a user.
final class UserDelete extends UserEvent {}
