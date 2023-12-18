import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:clique_king/clique_king.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';
part 'authentication_side_effect.dart';

class AuthenticationBloc extends SideEffectBloc<AuthenticationEvent, AuthenticationState, AuthenticationSideEffect> {
  final  AuthenticationRepository authenticationRepository;

  auth.User? get user {
    AuthenticationState state = this.state;
    switch(state) {
      case AuthenticationInitial():
        return null;
      case AuthenticationChanged():
        return state.user;
      case AuthenticationError():
        return null;
    }
  }

  bool get authenticated => user != null;

  AuthenticationBloc({required this.authenticationRepository}) : super(AuthenticationInitial()) {
    on<AuthenticationStartSubscribing>((AuthenticationStartSubscribing event, Emitter<AuthenticationState> emit) async {
      Either<RepositoryError, Stream<auth.User?>> result = authenticationRepository.authenticationStateChanges();

      await result.match(
              (l) async => emit(AuthenticationError(error: l)),
              (r) async => await emit.onEach(
              r,
              onData: (auth.User? user) {
                print("Got data, emitting from stream");
                emit(AuthenticationChanged(user: user));
              }
          )
      );

    },
      transformer: restartable(),
    );

    on<AuthenticationLogoutRequested>((AuthenticationLogoutRequested event, Emitter<AuthenticationState> emit) async {
      print("Logout requested");
      Option<RepositoryError> result = await authenticationRepository.logoutUser();
      result.match(
              () => produceSideEffect(AuthenticationLogoutSuccess()),
              (t) => produceSideEffect(AuthenticationLogoutFailure(error: t))
      );
    },
    );
  }
}