part of 'authentication_bloc.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationChanged extends AuthenticationState {
  final auth.User? user;

  const AuthenticationChanged({required this.user});

  @override
  List<Object> get props => user != null ? [user!] : [];
}

final class AuthenticationError extends AuthenticationState {
  final Object error;

  const AuthenticationError({required this.error});

  @override
  List<Object> get props => [error];
}