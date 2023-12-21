import 'package:universal_io/io.dart';
import 'package:clique_king/clique_king.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CliquesPage extends StatelessWidget {

  const CliquesPage({super.key});

  static Route<void> route() {
    if (Platform.isAndroid) {
      MaterialPageRoute<void>(builder: (context) => const CliquesPage());
    }

    if (Platform.isIOS) {
      return CupertinoPageRoute<void>(builder: (context) => const CliquesPage());
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const CliquesPage(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  return ErrorView(
                    error: state.error,
                    reloadFunction: () => BlocProvider.of<CliquesBloc>(context)..add(CliquesLoad()),
                  );
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