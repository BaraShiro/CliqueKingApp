import 'package:flutter/material.dart';
import 'package:clique_king/clique_king.dart';

/// An error view that is shown on a page when a [RepositoryError] has occurred.
///
/// The supplied [reloadFunction] should ideally retry to get the data from
/// the repository.
class ErrorView extends StatelessWidget {
  final RepositoryError error;
  final void Function() reloadFunction;
  const ErrorView({super.key, required this.error, required this.reloadFunction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
            Text("${error.errorObject}"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: reloadFunction,
        label: const Text("Reload"),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}