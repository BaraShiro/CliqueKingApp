export 'clique/clique.dart';
export 'cliques/cliques.dart';
export 'user/user.dart';
export 'repositories/repositories.dart';
export 'loading/loading.dart';
export 'login/login.dart';
export 'register/register.dart';
export 'extensions/extensions.dart';
export 'error/error.dart';

/// A user id corresponding to a Firebase Authentication User UID.
typedef UserId = String;
/// A v4 UUID clique id.
typedef CliqueId = String;

/// /// Key to users collection i database.
const String userCollection = "users";
/// Key to cliques collection i database.
const String cliqueCollection = "cliques";
/// Key to participants collection i database.
const String participantCollection = "participants";
/// Passwords must be at least this long.
const int minimumPasswordLength = 8;

/// The width of the app scaffold in landscape view
const double landscapeScaffoldWidth = 700;
/// The width of the app content in landscape view
const double landscapeContentWidth = 600;