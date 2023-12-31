import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.aspectIsLandscape ? landscapeScaffoldWidth : null,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.push(context, RegisterPage.route()),
                child: const Text("Register")
            ),
          ],
        ),
        body: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if(state is UserLoginSuccess) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('${state.user.name} logged in.')),
                  );
              }
              if(state is UserLoginFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('Failed to log in user. Error: ${state.error}')),
                  );
              }
            },
          child: Center(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                switch (state) {
                  case UserInProgress():
                    return const LoadingPage();
                  case _:
                    return LoginForm();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

