import 'package:clique_king/authentication/authentication.dart';
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
            )..add(AuthenticationStartSubscribing()),
          ),
          BlocProvider(
            create: (context) => UserBloc(
              authenticationRepository: RepositoryProvider.of<AuthenticationRepository>(context),
              userRepository: RepositoryProvider.of<UserRepository>(context),
            ),
          )
        ],
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
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            switch (state) {
              case AuthenticationInitial():
                return const LoadingPage();
              case AuthenticationChanged():
                if(state.user != null) {
                  return const CliquesPage();
                } else {
                  return const LoginPage();
                }
              case AuthenticationError():
                return ErrorView(
                    error: state.error,
                    reloadFunction: () => BlocProvider.of<AuthenticationBloc>(context)
                      ..add(AuthenticationStartSubscribing()),
                );
            }
          }
      ),
      onGenerateRoute: (_) => LoadingPage.route(),
    );
  }
}