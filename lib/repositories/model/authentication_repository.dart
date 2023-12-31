import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:meta/meta.dart';
import 'package:fpdart/fpdart.dart';
import 'package:clique_king/clique_king.dart';
import 'package:string_validator/string_validator.dart';

/// A repository for handling, authentication, and storage of local [User]s.
@immutable
class AuthenticationRepository {
  final auth.FirebaseAuth authentication;

  /// Whether a user is currently logged in.
  bool get isUserLoggedIn => authentication.currentUser != null;

  /// Public constructor.
  const AuthenticationRepository({required this.authentication});

  /// Registers a new user.
  ///
  /// Must supply a correctly formatted email address,
  /// a password at least 8 characters long,
  /// and a user name that is not empty or just whitespace.
  ///
  /// Returns either the newly registered [User], or any of the following errors:
  /// * [InvalidEmail] if the email is not properly formatted.
  /// * [InvalidPassword] if the password is shorter than 8 characters.
  /// * [InvalidUserName] if the username is empty or just whitespace.
  /// * [FailedToRegisterAccount] if the auth server fails to register the user.
  /// * [FailedToUpdateAccount] if the auth server fails to update the users name.
  /// * [FailedToGetAccount] if the auth server fails to retrieve the user.
  Future<Either<RepositoryError, User>> registerUser({required String email, required String password, required String userName}) async {
    if(isEmail(email)) {
      email = normalizeEmail(email);
    } else {
      return Either.left(const InvalidEmail(errorObject: "Invalid email address."));
    }

    if(!isLength(password, minimumPasswordLength)) {
      return Either.left(const InvalidPassword(errorObject: "Password must be at least $minimumPasswordLength characters long."));
    }

    userName = sanitizeUserName(userName);
    if(userName.isEmpty) return Either.left(const InvalidUserName(errorObject: "Invalid user name, can not be empty or only whitespace."));

    final auth.User authUser;
    final auth.UserCredential userCredential;
    try {
      userCredential = await authentication.createUserWithEmailAndPassword(email: email, password: password);
      authUser = userCredential.user!;
    } catch(e) {
      return Either.left(FailedToRegisterAccount(errorObject: e));
    }

    try {
      await authUser.updateDisplayName(userName);
    } catch(e) {
      return Either.left(FailedToUpdateAccount(errorObject: e));
    }
    return Either.right(User.fromAuthUser(authentication.currentUser!));
  }

  /// Updates the name of a user.
  ///
  /// Supplied name must not be empty or just whitespace.
  ///
  /// Returns either an updated [User], a any of the following errors:
  /// * [InvalidUserName] if the username is empty or just whitespace.
  /// * [FailedToUpdateAccount] if the auth server fails to update the users name.
  /// * [FailedToGetAccount] if the auth server fails to retrieve the user.
  Future<Either<RepositoryError, User>> updateUser({required String userName}) async {
    userName = sanitizeUserName(userName);
    if(userName.isEmpty) return Either.left(const InvalidUserName(errorObject: "Invalid user name, can not be empty or only whitespace."));

    try {
      await authentication.currentUser?.updateDisplayName(userName);
    } catch(e) {
    return Either.left(FailedToUpdateAccount(errorObject: e));
    }

    final auth.User authUser;

    try {
      authUser = authentication.currentUser!;
    } catch(e) {
      return Either.left(FailedToGetAccount(errorObject: e));
    }

    return Either.right(User.fromAuthUser(authUser));
  }

  /// Returns either the currently logged in [User], if any,
  /// or a [FailedToGetAccount] error otherwise.
  Future<Either<RepositoryError, User>> getLoggedInUser() async {
    auth.User authUser;
    try {
      authUser = authentication.currentUser!;
    } catch(e) {
      return Either.left(FailedToGetAccount(errorObject: e));
    }

    return Either.right(User.fromAuthUser(authUser));
  }

  /// Logs in a user associated with [email] if the correct [password] is supplied.
  ///
  /// Returns either the logged in [User] if successful,
  /// or a [WrongLoginCredentials] error otherwise.
  Future<Either<RepositoryError, User>> loginUser({required String email, required String password}) async {
    email = normalizeEmail(email);

    final auth.UserCredential userCredential;
    final auth.User authUser;
    try {
      userCredential = await authentication.signInWithEmailAndPassword(email: email, password: password);
      authUser = userCredential.user!;
    } catch(e) {
      // TODO: differentiate between wrong credentials and database failure
      return Either.left(WrongLoginCredentials(errorObject: e));
    }

    return Either.right(User.fromAuthUser(authUser));
  }

  /// Logs out the currently logged in user.
  ///
  /// Returns a [FailedToLogoutAccount] error if it fails, otherwise nothing.
  Future<Option<RepositoryError>> logoutUser() async {
    try {
      authentication.signOut();
    } catch(e) {
      return Option.of(FailedToLogoutAccount(errorObject: e));
    }

    return const Option.none();
  }

  /// Logs out and _permanently_ deletes the currently logged in user account.
  ///
  /// Returns a [FailedToDeleteAccount] error if it fails, otherwise nothing.
  Future<Option<RepositoryError>> deleteUser() async {
    try {
      await authentication.currentUser?.delete();
    } catch(e) {
      return Option.of(FailedToDeleteAccount(errorObject: e));
    }

    return const Option.none();
  }

  Either<RepositoryError, Stream<auth.User?>> authenticationStateChanges() {
    try {
      return Either.right(authentication.authStateChanges());
    } catch (e) {
      return Either.left(FailedToStreamAuthenticationStatus(errorObject: e));
    }
  }
}
