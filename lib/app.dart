import 'package:clique_king/clique_king.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The primary app class, the starting point for the app.
class App extends StatelessWidget {

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) {
          return AuthenticationRepository(
              authentication: auth.FirebaseAuth.instance);
        }),
        RepositoryProvider(create: (context) {
          return CliqueRepository(store: FirebaseFirestore.instance);
        }),
        RepositoryProvider(create: (context) {
          return UserRepository(store: FirebaseFirestore.instance);
        }),
      ],
      child: BlocProvider(
        create: (context) => UserBloc(
            authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
            userRepository: RepositoryProvider.of<UserRepository>(context)
        )..add(UserStarted()),
        child: AppView(),
      ),
    );
  }
}

/// The app view, listens for authentication state changes.
/// Navigates to [LoginPage] if the user is not authenticated,
/// or [CliquePage] if the user is.
class AppView extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Clique King',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.amber,
      ),
      home: BlocBuilder<UserBloc, UserState>(
          builder: (context,  UserState state) {
            switch (state) {
              case UserAuthenticationChanged():
                return const CliquesPage();
              case _:
                return const LoginPage();
            }
          }
      ),

      //const CliquesPage(user: BlocProvider.of<AuthenticationBloc>(context).state == AuthenticationChanged()),

      builder: (context, child) {
        return BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            switch (state) {
              case UserInitial():
                break;
              case UserAuthenticationChanged():
                switch (state.user != null) {
                  case true:
                    _navigator.pushReplacement(CliquesPage.route());
                    // );
                  case false:
                    _navigator.pushReplacement(LoginPage.route());
                }
              case UserAuthenticationError():
                // TODO: add error page with reload button
                print("Repository error: ${state.error}");
                _navigator.pushReplacement(LoginPage.route());
            }
          },
          child: child,
        );
      },
      // onGenerateRoute: (_) => LoadingPage.route(),
    );
  }
}