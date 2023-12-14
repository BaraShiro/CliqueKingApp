import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CliquesPage extends StatelessWidget {
  const CliquesPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (context) => const CliquesPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cliques"),
      ),
      body: Center(
        child: BlocProvider(
          create: (_) => CliquesBloc(
            cliqueRepository: RepositoryProvider.of<CliqueRepository>(context),
            authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
          )..add(CliquesLoad(),
          ),
          child: BlocBuilder<CliquesBloc, CliquesState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, CliquesState state) {
              switch (state) {
                case CliquesInitial():
                  return const LoadingPage();
                case CliquesStateInProgress():
                  return const LoadingPage();
                case CliquesStateFailure():
                  return Text("Error: ${state.error}");
                case CliquesLoadingSuccess():
                  return Column(
                    children: [
                      Text("Success! number of cliques: ${state.cliques.length}"),
                      Text("User logged in: ${RepositoryProvider.of<AuthenticationRepository>(context).isUserLoggedIn}"),
                      ElevatedButton(
                          onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLogoutRequested()),
                          child: const Text("Logout user")
                      ),
                    ],
                  );
                case AddCliqueSuccess():
                  return Text("Success! Clique name: ${state.clique.name}");
                case RemoveCliqueSuccess():
                  return const Text("Success, clique removed!");
              }
            },
          ),
        ),
      ),
    );
  }
}