import 'package:universal_io/io.dart';
import 'package:clique_king/clique_king.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A page that shows a form to register a new [User].
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static Route<void> route() {
    if (Platform.isAndroid) {
      return MaterialPageRoute<void>(builder: (context) => const RegisterPage());
    }

    if (Platform.isIOS) {
      return CupertinoPageRoute<void>(builder: (context) => const RegisterPage());
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const RegisterPage(),
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
    return const Scaffold(
      body: Center(
          child: RegisterView()
      ),
    );
  }
}