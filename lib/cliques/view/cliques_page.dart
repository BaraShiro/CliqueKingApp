import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CliquesPage extends StatelessWidget {

  const CliquesPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (context) => CliquesPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cliques"),
        actions: [
          ElevatedButton(
              onPressed: () => BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLogoutRequested()),
              child: const Text("Log out")
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
                  return Text("Error: ${state.error}"); // TODO: Error page
                case CliquesLoadingSuccess():
                  return CliquesView(cliques: state.cliques, user: state.user);
              }
            },
          ),
        ),
      ),
    );
  }
}