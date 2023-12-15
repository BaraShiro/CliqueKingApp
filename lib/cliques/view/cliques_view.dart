import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class CliquesView extends StatelessWidget {
  final List<Clique> cliques;
  final User user;

  const CliquesView({super.key, required this.cliques, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<CliquesBloc, CliquesSideEffect>(
      listener: (context, sideEffect) {
        switch (sideEffect) {
          case CliqueAddSuccess():
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Successfully added clique ${sideEffect.clique.name}')),
              );
          case CliqueAddFailure():
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Failed to add clique. Error: ${sideEffect.error}')),
              );
          case CliqueRemoveSuccess():
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Successfully removed clique')),
              );
          case CliqueRemoveFailure():
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Failed to remove clique. Error: ${sideEffect.error}')),
              );
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          // foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          onPressed: () async {
            CliquesBloc bloc = BlocProvider.of<CliquesBloc>(context);
            String? newCliqueName = "Test Clique 2";
            // Clique newClique = Clique(name: "Test Clique", creatorId: user.id);
            // Clique? newClique = await showModalBottomSheet<Clique>(
            //   enableDrag: false,
            //   context: context,
            //   builder: (BuildContext context) {
            //     return Container(
            //       padding: const EdgeInsets.all(5),
            //       child: AddCliqueModal(user: user),
            //     );
            //   },
            // );
            // print(newClique);
            if(newCliqueName != null) {
              bloc.add(AddClique(name: newCliqueName));
            }
          },
          label: const Text("Add new clique"),
          icon: const Icon(Symbols.add),
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
            children: [
              // header(context),
              switch (cliques.isEmpty) {
                true => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No cliques found!'),
                        Text('Create a new clique and start gaining score!')
                      ],
                    )),
                false => ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 200, top: 10),
                    itemCount: cliques.length,
                    itemBuilder: (BuildContext context, int index) {
                      return cliqueCard(context, cliques[index]);
                    }),
              },
            ],
          ),
        ),
      ),
    );
  }

  Widget cliqueCard(BuildContext context, Clique clique) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Theme.of(context).colorScheme.primary.withAlpha(100),
        onTap: () => Navigator.push(context, CliquePage.route(cliqueId: clique.id, user: user))
            .whenComplete(() => BlocProvider.of<CliquesBloc>(context)
            .add(CliquesLoad())),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(clique.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text("Clique King: "),
                ],
              ),

              const Spacer(),

              TextButton.icon(
                onPressed: () => BlocProvider.of<CliquesBloc>(context)
                    .add(RemoveClique(cliqueId: clique.id)),
                label: Text("Delete",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                icon: Icon(Symbols.delete_forever,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }
}