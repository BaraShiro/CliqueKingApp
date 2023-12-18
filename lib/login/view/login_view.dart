import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          switch (state) {
            case UserInitial():
              break;
            case UserInProgress():
              break;
            case UserLoginSuccess():
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('User logged in.')),
              );
            case UserLoginFailure():
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Failed to log in user.')),
                );
            case UserRegisterSuccess():
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('User registered.')),
                );
            case UserRegisterFailure():
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Failed to register user.')),
                );
            case UserUpdateSuccess():
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('User updated.')),
                );
            case UserUpdateFailure():
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Failed to update user.')),
                );
            case UserDeleteSuccess():
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('User deleted.')),
                );
            case UserDeleteFailure():
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Failed to delete user.')),
                );
          }
        },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          switch (state) {
            case UserInProgress():
              return const LoadingPage();
            case _:
              return const LoginForm();
          }
        },
      ),
    );
  }


}

