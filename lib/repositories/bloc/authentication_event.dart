part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class AuthenticationStartSubscribing extends AuthenticationEvent {}

final class AuthenticationLogoutRequested extends AuthenticationEvent {}

