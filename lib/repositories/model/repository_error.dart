import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Base class for errors pertaining to interactions with various repositories.
@immutable
sealed class RepositoryError extends Equatable{
  final Object errorObject;

  const RepositoryError({required this.errorObject});

  @override
  List<Object?> get props => [errorObject];
}

final class FailedToGetAccount extends RepositoryError {
  const FailedToGetAccount({required super.errorObject});
}

final class FailedToRegisterAccount extends RepositoryError {
  const FailedToRegisterAccount({required super.errorObject});
}

final class FailedToUpdateUser extends RepositoryError {
  const FailedToUpdateUser({required super.errorObject});
}

final class FailedToUpdateAccount extends RepositoryError {
  const FailedToUpdateAccount({required super.errorObject});
}

final class AccountNotLoggedIn extends RepositoryError {
  const AccountNotLoggedIn({required super.errorObject});
}

final class UserNameAlreadyInUse extends RepositoryError {
  const UserNameAlreadyInUse({required super.errorObject});
}

final class InvalidPassword extends RepositoryError {
  const InvalidPassword({required super.errorObject});
}

final class InvalidEmail extends RepositoryError {
  const InvalidEmail({required super.errorObject});
}

final class InvalidUserName extends RepositoryError {
  const InvalidUserName({required super.errorObject});
}

final class WrongLoginCredentials extends RepositoryError {
  const WrongLoginCredentials({required super.errorObject});
}

final class FailedToLogoutAccount extends RepositoryError {
  const FailedToLogoutAccount({required super.errorObject});
}

final class FailedToDeleteAccount extends RepositoryError {
  const FailedToDeleteAccount({required super.errorObject});
}

final class FailedToStreamAuthenticationStatus extends RepositoryError {
  const FailedToStreamAuthenticationStatus({required super.errorObject});
}

final class FailedToCreateUser extends RepositoryError {
  const FailedToCreateUser({required super.errorObject});
}

final class FailedToReadUser extends RepositoryError {
  const FailedToReadUser({required super.errorObject});
}

final class FailedToQueryUsers extends RepositoryError {
  const FailedToQueryUsers({required super.errorObject});
}

final class FailedToDeleteUser extends RepositoryError {
  const FailedToDeleteUser({required super.errorObject});
}

final class FailedToCreateClique extends RepositoryError {
  const FailedToCreateClique({required super.errorObject});
}

final class FailedToStreamCliques extends RepositoryError {
  const FailedToStreamCliques({required super.errorObject});
}

final class FailedToStreamScores extends RepositoryError {
  const FailedToStreamScores({required super.errorObject});
}

final class FailedToAddUserToClique extends RepositoryError {
  const FailedToAddUserToClique({required super.errorObject});
}

final class FailedToRemoveUserFromClique extends RepositoryError {
  const FailedToRemoveUserFromClique({required super.errorObject});
}

final class FailedToDeleteClique extends RepositoryError {
  const FailedToDeleteClique({required super.errorObject});
}

final class FailedToReadClique extends RepositoryError {
  const FailedToReadClique({required super.errorObject});
}

final class FailedToIncreaseScore extends RepositoryError {
  const FailedToIncreaseScore({required super.errorObject});
}

final class FailedToReadScore extends RepositoryError {
  const FailedToReadScore({required super.errorObject});
}

final class FailedToLoadCliques extends RepositoryError {
  const FailedToLoadCliques({required super.errorObject});
}

final class UserPermissionViolation extends RepositoryError {
  const UserPermissionViolation({required super.errorObject});
}