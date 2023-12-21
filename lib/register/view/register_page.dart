import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (context) => const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: RegisterView()
      ),
    );
  }
}