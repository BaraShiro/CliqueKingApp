import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (context) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () async  => await RepositoryProvider.of<AuthenticationRepository>(context).loginUser(email: "tester@lester.com", password: "test123"),
              child: const Text("Login test user")
          )
      ),
    );
  }
}