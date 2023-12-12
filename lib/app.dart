import 'package:clique_king/clique_king.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The primary app class, the starting point for the app.
class App extends StatelessWidget {

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clique King',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.yellow,
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider (create: (context) {
            return AuthenticationRepository(authentication: FirebaseAuth.instance);
          }),
          RepositoryProvider (create: (context) {
            return CliqueRepository(store: FirebaseFirestore.instance);
          }),
          RepositoryProvider (create: (context) {
            return UserRepository(store: FirebaseFirestore.instance);
          }),
        ],
        child: CliquesPage(),
      ),
    );
  }
}