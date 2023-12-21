import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if(state is UserRegisterSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('${state.user.name} registered.')),
            );
          Navigator.pop(context);
        }
        if(state is UserRegisterFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Failed to register user. Error: ${state.error}')),
            );
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          switch (state) {
            case UserInProgress():
              return const LoadingPage();
            case _:
              return RegisterForm();
          }
        },
      ),
    );
  }
}

