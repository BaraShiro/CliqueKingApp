import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The primary app class, the starting point for the app.
class App extends StatelessWidget {
  final Repositories repositories;

  const App({super.key, required this.repositories});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clique King',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.yellow,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Text(""),
    );
  }
}