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
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async  => await BlocProvider.of<UserBloc>(context)..add(UserLogin(email: "tester@lester.com", password: "test123")),//RepositoryProvider.of<AuthenticationRepository>(context).loginUser(email: "tester@lester.com", password: "test123"),
                  child: const Text("Login Lester")
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async  => await BlocProvider.of<UserBloc>(context)..add(UserLogin(email: "Smyrno@lester.com", password: "smyrno123")),//RepositoryProvider.of<AuthenticationRepository>(context).loginUser(email: "Smyrno@lester.com", password: "smyrno123"),
                  child: const Text("Login Smyrno")
              ),
              const SizedBox(height: 10),
              // ElevatedButton(
              //     onPressed: () async  => await RepositoryProvider.of<AuthenticationRepository>(context).registerUser(email: "Smyrno@lester.com", password: "smyrno123", userName: 'Smyrno'),
              //     child: const Text("Register user")
              // ),

              const LoginView(),
            ],
          )
      ),
    );
  }
}