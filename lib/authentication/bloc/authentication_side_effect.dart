part of 'authentication_bloc.dart';

/// Base class for Authentication Side Effects.
@immutable
sealed class AuthenticationSideEffect {}

/// Logout user was successful.
final class AuthenticationLogoutSuccess extends AuthenticationSideEffect {}

/// Logout user has failed.
final class AuthenticationLogoutFailure extends AuthenticationSideEffect {
  final RepositoryError error;

  AuthenticationLogoutFailure({required this.error});
}