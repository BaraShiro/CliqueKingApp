import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:fpdart/fpdart.dart';
import 'package:clique_king/clique_king.dart';

/// A repository for handling and storage of [User]s.
@immutable
class UserRepository { // TODO: add security
  final FirebaseFirestore store;

  /// Public constructor.
  const UserRepository({required this.store});

  /// Used to perform type-safe read and write operation on a [User] collection.
  CollectionReference<User> typeSafeUsersReference() {
    return store.collection(userCollection).withConverter<User>(
      fromFirestore: (snapshot, _) => User.fromMap(snapshot.data()!),
      toFirestore: (user, _) => user.toMap(),
    );
  }

  /// Stores a [User] in the repository.
  ///
  /// Returns either the [User], or a [FailedToCreateUser] error if it fails.
  Future<Either<RepositoryError, User>> createUser({required User user}) async {
    final CollectionReference<User> usersRef = typeSafeUsersReference();

    try {
      await usersRef.doc(user.id).set(user);
    } catch (e) {
      return Either.left(FailedToCreateUser(errorObject: e));
    }

    DocumentSnapshot<User> document;
    try {
       document = await usersRef.doc(user.id).get();
    } catch (e) {
      return Either.left(FailedToReadUser(errorObject: e));
    }

    if(document.exists){
      return Either.right(document.data()!);
    } else {
      return Either.left(FailedToReadUser(errorObject: "No user with id ${user.id} exists."));
    }
  }

  /// Retrieves a [User] with the user id [id] from the repository.
  ///
  /// Returns either the specified [User],
  /// or a [FailedToReadUser] error if it fails.
  Future<Either<RepositoryError, User>> readUser({required UserId id}) async {
    final CollectionReference<User> usersRef = typeSafeUsersReference();

    DocumentSnapshot<User> document;
    try {
      document = await usersRef.doc(id).get();
    } catch (e) {
      return Either.left(FailedToReadUser(errorObject: e));
    }

    if(document.exists){
      return Either.right(document.data()!);
    } else {
      return Either.left(FailedToReadUser(errorObject: "No user with id $id exists."));
    }
  }

  /// Checks if a [User] with the name [userName] exists in the repository.
  ///
  /// Returns either a [bool] indicating whether the user exists,
  /// or one of two errors:
  /// * [InvalidUserName] if the supplied user name is empty or just whitespace.
  /// * [FailedToQueryUsers] if the repository query fails.
  Future<Either<RepositoryError, bool>> userExists({required String userName}) async {
    userName = sanitizeUserName(userName);
    if(userName.isEmpty) return Either.left(InvalidUserName(errorObject: "Invalid user name, can not be empty or only whitespace."));

    final CollectionReference<User> usersRef = typeSafeUsersReference();

    List<QueryDocumentSnapshot<User>> users;
    try {
      QuerySnapshot<User> query = await usersRef.where("name", isEqualTo: userName).get();
      users = query.docs;
    } catch (e) {
      return Either.left(FailedToQueryUsers(errorObject: e));
    }

    return Either.right(users.isNotEmpty);
  }

  /// Updates a [User] in the repository.
  ///
  /// Returns either the [User], or one of two errors:
  /// * [FailedToUpdateUser] if it fails to update the user in the repository.
  /// * [FailedToReadUser] if it fails to read back the user from the repository.
  Future<Either<RepositoryError, User>> updateUser({required User user}) async {
    final CollectionReference<User> usersRef = typeSafeUsersReference();

    try {
      await usersRef.doc(user.id).set(user, SetOptions(merge: true));
    } catch (e) {
      return Either.left(FailedToCreateUser(errorObject: e));
    }

    DocumentSnapshot<User> document;
    try {
      document = await usersRef.doc(user.id).get();
    } catch (e) {
      return Either.left(FailedToReadUser(errorObject: e));
    }

    if(document.exists){
      return Either.right(document.data()!);
    } else {
      return Either.left(FailedToReadUser(errorObject: "No user with id ${user.id} exists."));
    }
  }

  /// Deletes a [User] from the repository.
  ///
  /// Returns a [FailedToDeleteUser] error if it fails, otherwise nothing.
  Future<Option<RepositoryError>> deleteUser({required UserId id}) async {
    final CollectionReference<User> usersRef = typeSafeUsersReference();

    try {
      await usersRef.doc(id).delete();
    } catch (e) {
      return Option.of(FailedToCreateUser(errorObject: e));
    }

    return const Option.none();
  }
}
