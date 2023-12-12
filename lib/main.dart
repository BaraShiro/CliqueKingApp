import 'package:flutter/material.dart';
import 'package:clique_king/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// The app entry point, sets up firebase and starts the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}



