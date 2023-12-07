import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:clique_king/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// The app entry point, sets up the repositories and starts the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  Repositories repositories = await Repositories.setup();
  runApp(App(repositories: repositories));
}



