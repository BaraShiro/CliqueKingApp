import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CliquesPage extends StatelessWidget {
  final User user;

  const CliquesPage({super.key, required this.user});

  static Route<void> route({required User user}) {
    return MaterialPageRoute<void>(builder: (context) => CliquesPage(user: user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cliques"),
        actions: [
          ElevatedButton(
              onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLogoutRequested()),
              child: const Text("Logout user")
          ),
        ],
      ),
      body: Center(
        child: BlocProvider(
          create: (_) => CliquesBloc(
            cliqueRepository: RepositoryProvider.of<CliqueRepository>(context),
            authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
          )..add(CliquesLoad(),),
          child: BlocBuilder<CliquesBloc, CliquesState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, CliquesState state) {
              switch (state) {
                case CliquesInitial():
                  return const LoadingPage();
                case CliquesLoadingFailure():
                  return Text("Error: ${state.error}");
                case CliquesLoadingSuccess():
                  return CliquesView(cliques: state.cliques, user: user);
              }
            },
          ),
        ),
      ),
    );
  }
}