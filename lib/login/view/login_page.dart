import 'package:universal_io/io.dart';
import 'package:clique_king/clique_king.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    if (Platform.isAndroid) {
      MaterialPageRoute<void>(builder: (context) => const LoginPage());
    }

    if (Platform.isIOS) {
      return CupertinoPageRoute<void>(builder: (context) => const LoginPage());
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: LoginView()
      ),
    );
  }
}