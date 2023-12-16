import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:clique_king/clique_king.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:side_effect_bloc/side_effect_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_side_effect.dart';

/// User Bloc class.
final class UserBloc extends SideEffectBloc<UserEvent, UserState, UserSideEffect> {
  final UserRepository _userRepo;
  final AuthenticationRepository _authRepo;

  UserBloc(
      {required UserRepository userRepository,
      required AuthenticationRepository authenticationRepository})
      : _userRepo = userRepository,
        _authRepo = authenticationRepository,
        super(UserInitial()) {

    on<UserStarted>((UserStarted event, Emitter<UserState> emit) async {
      Either<RepositoryError, Stream<auth.User?>> result = _authRepo.authenticationStateChanges();

      await result.match(
              (l) async => emit(UserAuthenticationError(error: l)),
              (r) async => await emit.onEach(
              r,
              onData: (auth.User? user) {
                print("Got data, emitting from stream");
                emit(UserAuthenticationChanged(user: user));
              }
          )
      );

    },
      transformer: restartable(),
    );

    on<UserEvent>(
      (UserEvent event, Emitter<UserState> emit) async {
        switch (event) {
          case UserStarted():
            break;
          case UserRegister():
            await _handleUserRegisterEvent(event: event, emit: emit);
          case UserUpdate():
            await _handleUserUpdateEvent(event: event, emit: emit);
          case UserLogin():
            await _handleUserLoginEvent(event: event, emit: emit);
          case UserLogout():
            await _handleUserLogoutEvent(event: event, emit: emit);
          case UserDelete():
            await _handleUserDeleteEvent(event: event, emit: emit);
        }
      },
    );
  }

  /// Handles User Started Event
  ///
  /// Emits [UserLoginInProgress], and then emits either:
  /// * [UserLoginFailure] if no user is logged in.
  /// * [UserLoginSuccess] if a user is logged in.
  Future<void> _handleUserStartedEvent({required UserStarted event, required Emitter<UserState> emit}) async {
    if(_authRepo.isUserLoggedIn) {
      Either<RepositoryError, User> result = await _authRepo.getLoggedInUser();
      result.match(
              (l) => produceSideEffect(UserLoginFailure(error: l)),
              (r) => produceSideEffect(UserLoginSuccess(user: r))
      );
    } else {
      RepositoryError notLoggedInError = AccountNotLoggedIn(errorObject: "User is not logged in");
      produceSideEffect(UserLoginFailure(error: notLoggedInError));
    }
  }

  /// Handles User Register Event
  ///
  /// Emits [UserRegisterInProgress], and then emits either:
  /// * [UserRegisterFailure] if user already exists or unable to check if user
  /// already exists, unable to register user, or unable to write user.
  /// * [UserRegisterSuccess] if user was successfully registered and written.
  Future<void> _handleUserRegisterEvent({required UserRegister event, required Emitter<UserState> emit}) async {
    Either<RepositoryError, bool> existResult = await _userRepo.userExists(userName: event.name);

    bool error = existResult.match(
            (l) {
              produceSideEffect(UserRegisterFailure(error: l));
              return true;
            },
            (r) {
              if(r) {
                RepositoryError userExistsError = UserNameAlreadyInUse(errorObject: "User name is already in use.");
                produceSideEffect(UserRegisterFailure(error: userExistsError));
              }
              return r;
            }
    );

    if(error) return;

    Either<RepositoryError, User> registerResult = await _authRepo.registerUser(email: event.email, password: event.password, userName: event.name);

    await registerResult.match(
            (l) async => produceSideEffect(UserRegisterFailure(error: l)),
            (r) async {
              Either<RepositoryError, User> createResult = await _userRepo.createUser(user: r);

              createResult.match(
                      (l) => produceSideEffect(UserRegisterFailure(error: l)),
                      (r) => produceSideEffect(UserRegisterSuccess(user: r))
              );
            }
    );
  }

  /// Handles User Update Event
  ///
  /// Emits [UserUpdateInProgress], and then emits either:
  /// * [UserUpdateFailure] if user already exists or unable to check if user
  // already exists, unable to update user account, or unable to update user.
  /// * [UserUpdateSuccess] if successfully updated user and user account.
  Future<void> _handleUserUpdateEvent({required UserUpdate event, required Emitter<UserState> emit}) async {
    Either<RepositoryError, bool> existResult = await _userRepo.userExists(userName: event.name);

    bool error = existResult.match(
            (l) {
              produceSideEffect(UserUpdateFailure(error: l));
              return true;
        },
            (r) {
          if(r) {
            RepositoryError userExistsError = UserNameAlreadyInUse(errorObject: "User name is already in use.");
            produceSideEffect(UserUpdateFailure(error: userExistsError));
          }
          return r;
        }
    );

    if(error) return;

    Either<RepositoryError, User> accountResult = await _authRepo.updateUser(userName: event.name);

    await accountResult.match(
            (l) async => produceSideEffect(UserUpdateFailure(error: l)),
            (r) async {
              Either<RepositoryError, User> userResult = await _userRepo.updateUser(user: r);

              userResult.match(
                      (l) => produceSideEffect(UserUpdateFailure(error: l)),
                      (r) => produceSideEffect(UserUpdateSuccess(user: r))
              );
            }
    );
  }

  /// Handles User Login Event
  ///
  /// Emits [UserLoginInProgress], and then emits either:
  /// * [UserLoginFailure] if unable to log in.
  /// * [UserLoginSuccess] if successfully logged in.
  Future<void> _handleUserLoginEvent({required UserLogin event, required Emitter<UserState> emit}) async {
    Either<RepositoryError, User> result = await _authRepo.loginUser(email: event.email, password: event.password);

    result.match(
            (l) => produceSideEffect(UserLoginFailure(error: l)),
            (r) => produceSideEffect(UserLoginSuccess(user: r))
    );
  }

  /// Handles User Logout Event
  ///
  /// Emits [UserLogoutInProgress], and then emits either:
  /// * [UserLogoutFailure] if unable to log out.
  /// * [UserLogoutSuccess] if successfully logged out.
  Future<void> _handleUserLogoutEvent({required UserLogout event, required Emitter<UserState> emit}) async {
    Option<RepositoryError> result = await _authRepo.logoutUser();

    result.match(
            () => produceSideEffect(UserLogoutSuccess()),
            (t) => produceSideEffect(UserLogoutFailure(error: t))
    );
  }

  /// Handles User Delete Event
  ///
  /// Emits [UserDeleteInProgress], and then emits either:
  /// * [UserDeleteFailure] if unable to read logged in user, or unable to
  /// delete user account or user.
  /// * [UserDeleteSuccess] if successfully deleted user account and user.
  Future<void> _handleUserDeleteEvent({required UserDelete event, required Emitter<UserState> emit}) async {
    Either<RepositoryError, User> loggedInResult = await _authRepo.getLoggedInUser();

    await loggedInResult.match(
            (l) async => produceSideEffect(UserDeleteFailure(error: l)),
            (r) async {
              Option<RepositoryError> deleteUserResult = await _userRepo.deleteUser(id: r.id);

              await deleteUserResult.match(
                      () async {
                        Option<RepositoryError> deleteAccountResult = await _authRepo.deleteUser();

                        deleteAccountResult.match(
                                () => produceSideEffect(UserDeleteSuccess()),
                                (t) => produceSideEffect(UserDeleteFailure(error: t))
                        );
                      },
                      (t) async => produceSideEffect(UserDeleteFailure(error: t))
              );
            }
    );
  }
}
