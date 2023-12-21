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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        actions: [
          ElevatedButton(
              onPressed: () => BlocProvider.of<UserBloc>(context)..add(UserRegister(email: "", password: "", name: "")),
              child: const Text("Register test user")
          ),
        ],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const RegisterView(),
            ],
          )
      ),
    );
  }
}