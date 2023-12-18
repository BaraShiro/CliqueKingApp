import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A page that shows the details of an [Exercise].
class CliquePage extends StatelessWidget {
  final CliqueId cliqueId;

  const CliquePage({super.key, required this.cliqueId});

  static Route<void> route({required CliqueId cliqueId}) {
    return MaterialPageRoute<void>(builder: (_) => CliquePage(cliqueId: cliqueId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider(
          create: (_) => CliqueBloc(
            cliqueRepository: RepositoryProvider.of<CliqueRepository>(context),
            authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
          )..add(CliqueLoad(cliqueId: cliqueId),),
          child: BlocBuilder<CliqueBloc, CliqueState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, CliqueState state) {
              switch (state) {
                case CliqueInitial():
                  return const LoadingPage();
                case CliqueLoadingFailure():
                  return Text("Error: ${state.error}"); // TODO: Error page
                case CliqueLoadingSuccess():
                  return CliqueView(clique: state.clique, scores: state.allScoresSorted, userInClique: state.isInClique);
              }
            },
          ),
        ),
      ),
    );
  }

}
