import 'package:universal_io/io.dart';
import 'package:clique_king/clique_king.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A page that shows the details of an [Clique].
class CliquePage extends StatelessWidget {
  final CliqueId cliqueId;

  const CliquePage({super.key, required this.cliqueId});

  static Route<void> route({required CliqueId cliqueId}) {
    if (Platform.isAndroid) {
      return MaterialPageRoute<void>(builder: (context) => CliquePage(cliqueId: cliqueId));
    }

    if (Platform.isIOS) {
      return CupertinoPageRoute<void>(builder: (context) => CliquePage(cliqueId: cliqueId));
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CliquePage(cliqueId: cliqueId),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin = const Offset(1.0, 0.0);
        Offset end = Offset.zero;
        Cubic curve = Curves.ease;

        Animatable<Offset> tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
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
