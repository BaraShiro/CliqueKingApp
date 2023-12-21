import 'package:bloc/bloc.dart';
import 'package:clique_king/clique_king.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'user_event.dart';
part 'user_state.dart';

/// User Bloc class.
final class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepo;
  final AuthenticationRepository _authRepo;

  UserBloc(
      {required UserRepository userRepository,
      required AuthenticationRepository authenticationRepository})
      : _userRepo = userRepository,
        _authRepo = authenticationRepository,
        super(UserInitial()) {
    on<UserEvent>(
      (UserEvent event, Emitter<UserState> emit) async {
        switch (event) {
          case UserRegister():
            await _handleUserRegisterEvent(event: event, emit: emit);
          case UserUpdate():
            await _handleUserUpdateEvent(event: event, emit: emit);
          case UserLogin():
            await _handleUserLoginEvent(event: event, emit: emit);
          case UserDelete():
            await _handleUserDeleteEvent(event: event, emit: emit);
        }
      },
    );
  }

  /// Handles User Register Event
  ///
  /// Emits [UserRegisterInProgress], and then emits either:
  /// * [UserRegisterFailure] if user already exists or unable to check if user
  /// already exists, unable to register user, or unable to write user.
  /// * [UserRegisterSuccess] if user was successfully registered and written.
  Future<void> _handleUserRegisterEvent({required UserRegister event, required Emitter<UserState> emit}) async {
    emit(UserInProgress());

    Either<RepositoryError, bool> existResult = await _userRepo.userExists(userName: event.name);

    bool error = existResult.match(
            (l) {
              emit(UserRegisterFailure(error: l));
              return true;
            },
            (r) {
              if(r) {
                RepositoryError userExistsError = const UserNameAlreadyInUse(errorObject: "User name is already in use.");
                emit(UserRegisterFailure(error: userExistsError));
              }
              return r;
            }
    );

    if(error) return;

    Either<RepositoryError, User> registerResult = await _authRepo.registerUser(email: event.email, password: event.password, userName: event.name);

    await registerResult.match(
            (l) async => emit(UserRegisterFailure(error: l)),
            (r) async {
              Either<RepositoryError, User> createResult = await _userRepo.createUser(user: r);

              createResult.match(
                      (l) => emit(UserRegisterFailure(error: l)),
                      (r) => emit(UserRegisterSuccess(user: r))
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
    emit(UserInProgress());

    Either<RepositoryError, bool> existResult = await _userRepo.userExists(userName: event.name);

    bool error = existResult.match(
            (l) {
              emit(UserUpdateFailure(error: l));
              return true;
        },
            (r) {
          if(r) {
            RepositoryError userExistsError = const UserNameAlreadyInUse(errorObject: "User name is already in use.");
            emit(UserUpdateFailure(error: userExistsError));
          }
          return r;
        }
    );

    if(error) return;

    Either<RepositoryError, User> accountResult = await _authRepo.updateUser(userName: event.name);

    await accountResult.match(
            (l) async => emit(UserUpdateFailure(error: l)),
            (r) async {
              Either<RepositoryError, User> userResult = await _userRepo.updateUser(user: r);

              userResult.match(
                      (l) => emit(UserUpdateFailure(error: l)),
                      (r) => emit(UserUpdateSuccess(user: r))
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
    emit(UserInProgress());

    Either<RepositoryError, User> result = await _authRepo.loginUser(email: event.email, password: event.password);

    result.match(
            (l) => emit(UserLoginFailure(error: l)),
            (r) => emit(UserLoginSuccess(user: r))
    );
  }

  /// Handles User Delete Event
  ///
  /// Emits [UserDeleteInProgress], and then emits either:
  /// * [UserDeleteFailure] if unable to read logged in user, or unable to
  /// delete user account or user.
  /// * [UserDeleteSuccess] if successfully deleted user account and user.
  Future<void> _handleUserDeleteEvent({required UserDelete event, required Emitter<UserState> emit}) async {
    emit(UserInProgress());

    Either<RepositoryError, User> loggedInResult = await _authRepo.getLoggedInUser();

    await loggedInResult.match(
            (l) async => emit(UserDeleteFailure(error: l)),
            (r) async {
              Option<RepositoryError> deleteUserResult = await _userRepo.deleteUser(id: r.id);

              await deleteUserResult.match(
                      () async {
                        Option<RepositoryError> deleteAccountResult = await _authRepo.deleteUser();

                        deleteAccountResult.match(
                                () => emit(UserDeleteSuccess()),
                                (t) => emit(UserDeleteFailure(error: t))
                        );
                      },
                      (t) async => emit(UserDeleteFailure(error: t))
              );
            }
    );
  }
}
