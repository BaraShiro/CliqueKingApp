import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A page that shows the details of an [Exercise].
class CliquePage extends StatelessWidget {
  final CliqueId cliqueId;
  final User user;

  const CliquePage({super.key, required this.cliqueId, required this.user});

  static Route<void> route({required CliqueId cliqueId, required User user}) {
    return MaterialPageRoute<void>(builder: (_) => CliquePage(cliqueId: cliqueId, user: user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clique'),
        // actions: <Widget>[
        //   TextButton.icon(
        //     onPressed: () => {},
        //     icon: const Icon(Symbols.edit_note),
        //     label: const Text("Edit"),
        //     style: TextButton.styleFrom(
        //       backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        //       foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        //     ),
        //   ),
        // ],
      ),
      body: Center(child: Text(user.name)),
    );
  }

}
