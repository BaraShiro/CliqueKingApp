import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';
import 'package:clique_king/clique_king.dart';

/// A repository for handling and storage of [Clique]s.
@immutable
class CliqueRepository {
  final FirebaseFirestore store;

  /// Public constructor.
  const CliqueRepository({required this.store});

  /// Used to perform type-safe read and write operation on a [Clique] collection.
  CollectionReference<Clique> typeSafeCliquesReference() {
    return store.collection(cliqueCollection).withConverter<Clique>(
      fromFirestore: (snapshot, _) => Clique.fromMap(snapshot.data()!),
      toFirestore: (clique, _) => clique.toMap(),
    );
  }

  /// Used to perform type-safe read and write operation on a [Score] collection.
  CollectionReference<Score> typeSafeParticipantsReference(String cliqueId) {
    return store.collection(cliqueCollection).doc(cliqueId)
        .collection(participantCollection).withConverter<Score>(
      fromFirestore: (snapshot, _) => Score.fromMap(snapshot.data()!),
      toFirestore: (score, _) => score.toMap(),
    );
  }

  /// Creates a new [Clique] with a [name] and a [creatorId].
  ///
  /// Returns either the newly created [Clique], or a [FailedToCreateClique] error.
  Future<Either<RepositoryError, Clique>> createClique({required String name, required UserId creatorId}) async {
    final Clique clique = Clique(name: name, creatorId: creatorId);
    final CollectionReference<Clique> cliquesRef = typeSafeCliquesReference();

    try {
      await cliquesRef.doc(clique.id).set(clique);
    } catch (e) {
      return Either.left(FailedToCreateClique(errorObject: e));
    }

    DocumentSnapshot<Clique> document;
    try {
      document = await cliquesRef.doc(clique.id).get();
    } catch (e) {
      return Either.left(FailedToReadClique(errorObject: e));
    }

    if(document.exists){
      return Either.right(document.data()!);
    } else {
      return Either.left(FailedToReadClique(errorObject: "No clique with id ${clique.id} exists."));
    }
  }

  /// Reads all [Clique]s as a [Stream].
  ///
  /// Returns either a [Stream] containing a [List] of [Clique]s,
  /// or a a [FailedToStreamCliques] error.
  Either<RepositoryError, Stream<List<Clique>>> readAllCliques() {
    final CollectionReference<Clique> cliquesRef = typeSafeCliquesReference();
    Stream<List<Clique>> cliqueStream;

    try {
      cliqueStream = cliquesRef.snapshots().map(
              (query) => query.docs.map(
                      (snapshot) => snapshot.data()
              ).toList()
      );
    } catch (e) {
      return Either.left(FailedToStreamCliques(errorObject: e));
    }

    return Either.right(cliqueStream);
  }

  /// Reads all [Score]s from a [Clique] as as [Stream].
  ///
  /// Returns either a [Stream] containing a [List] of [Score]s,
  /// or a [FailedToStreamScores] error.
  Either<RepositoryError, Stream<List<Score>>> readScoresFromClique({required CliqueId cliqueId}) {
    final CollectionReference<Score> participantsRef = typeSafeParticipantsReference(cliqueId);
    Stream<List<Score>> scoreStream;

    try {
      scoreStream = participantsRef.snapshots().map(
              (query) => query.docs.map(
                      (snapshot) => snapshot.data()
              ).toList()
      );
    } catch (e) {
      return Either.left(FailedToStreamScores(errorObject: e));
    }

    return Either.right(scoreStream);
  }

  /// Adds a new [User] to a [Clique].
  ///
  /// Returns a [FailedToAddUserToClique] error if it fails, otherwise nothing.
  Future<Option<RepositoryError>> addUser({required CliqueId cliqueId, required User user}) async {
    Score score = Score.fromUser(user);
    final CollectionReference<Score> participantsRef = typeSafeParticipantsReference(cliqueId);

    try {
      await participantsRef.doc(score.userId).set(score);
    } catch (e) {
      return Option.of(FailedToAddUserToClique(errorObject: e));
    }

    return const Option.none();
  }

  /// Removes a existing [User] from a [Clique].
  ///
  /// Returns a [FailedToRemoveUserFromClique] error if it fails, otherwise nothing.
  Future<Option<RepositoryError>> removeUser({required CliqueId cliqueId, required UserId userId}) async {
    final CollectionReference<Score> participantsRef = typeSafeParticipantsReference(cliqueId);

    try {
      await participantsRef.doc(userId).delete();
    } catch (e) {
      return Option.of(FailedToRemoveUserFromClique(errorObject: e));
    }

    return const Option.none();
  }

  /// Removes a [Clique] from the repository.
  ///
  /// Returns a [FailedToDeleteClique] error if it fails, otherwise nothing.
  ///
  /// Does currently *NOT* delete nested collection of user scores!
  Future<Option<RepositoryError>> deleteClique({required CliqueId cliqueId}) async {
    // TODO: Recursively remove all score documents?
    final CollectionReference<Clique> cliquesRef = typeSafeCliquesReference();

    try {
      await cliquesRef.doc(cliqueId).delete();
    } catch (e) {
      return Option.of(FailedToDeleteClique(errorObject: e));
    }

    return const Option.none();
  }

  /// Retrieves a [Clique] from the repository.
  ///
  /// Returns either the requested [Clique],
  /// or a [FailedToReadClique] error if it fails.
  Future<Either<RepositoryError, Clique>> getClique({required CliqueId cliqueId}) async {
    final CollectionReference<Clique> cliquesRef = typeSafeCliquesReference();
    DocumentSnapshot<Clique> document;

    try {
      document = await cliquesRef.doc(cliqueId).get();
    } catch (e) {
      return Either.left(FailedToReadClique(errorObject: e));
    }

    if(document.exists){
      return Either.right(document.data()!);
    } else {
      return Either.left(FailedToReadClique(errorObject: "No clique with id $cliqueId exists."));
    }
  }

  /// Retrieves a [Score] for a specific [User] from the repository.
  ///
  /// Returns either the [Score] for the requested [User],
  /// or a [FailedToReadScore] error if it fails.
  Future<Either<RepositoryError, Score>> getScore({required CliqueId cliqueId, required UserId userId}) async {
    final CollectionReference<Score> participantsRef = typeSafeParticipantsReference(cliqueId);
    DocumentSnapshot<Score> document;

    try {
      document = await participantsRef.doc(userId).get();
    } catch (e) {
      return Either.left(FailedToReadScore(errorObject: e));
    }

    if(document.exists){
      return Either.right(document.data()!);
    } else {
      return Either.left(FailedToReadScore(errorObject: "No score with id $userId exists in clique with id $cliqueId."));
    }
  }

  /// Increases the value of a certain [Score] by an amount equal to [scoreIncrease].
  ///
  /// Returns a [FailedToIncreaseScore] error if it fails, otherwise nothing.
  Future<Option<RepositoryError>> increaseScore({required CliqueId cliqueId, required Score score, required int scoreIncrease}) async {
    Score newScore = score.increaseScore(increase: scoreIncrease);
    final CollectionReference<Score> participantsRef = typeSafeParticipantsReference(cliqueId);

    try {
      await participantsRef.doc(score.userId).set(newScore, SetOptions(merge: true));
    } catch(e) {
      return Option.of(FailedToIncreaseScore(errorObject: e));
    }

    return const Option.none();
  }

  // TODO: getCliqueKing()
}
