import 'package:clique_king/clique_king.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class CliqueView extends StatelessWidget {
  final Clique clique;
  final List<Score> scores;
  final bool userInClique;

  const CliqueView({super.key, required this.clique, required this.scores, required this.userInClique});

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<CliqueBloc, CliqueSideEffect>(
      listener: (context, sideEffect) {
        switch (sideEffect) {
          case CliqueIncreaseScoreSuccess():
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Successfully increased score with ${sideEffect.increase} ${sideEffect.increase == 1 ? "point" : "points"}')),
              );
          case CliqueIncreaseScoreFailure():
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Failed to increase score. Error: ${sideEffect.error}')),
              );
          case CliqueJoinSuccess():
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Successfully joined clique')),
              );
          case CliqueJoinFailure():
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Failed to join clique. Error: ${sideEffect.error}')),
              );
          case CliqueLeaveSuccess():
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Successfully left clique')),
              );
          case CliqueLeaveFailure():
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Failed to leave clique. Error: ${sideEffect.error}')),
              );
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.aspectIsLandscape ? landscapeScaffoldWidth : null,
        child: Scaffold(
          appBar: AppBar(
            title: Text(clique.name),
            actions: [
              if(userInClique) ElevatedButton(
                  onPressed: () async {
                    CliqueBloc bloc = BlocProvider.of<CliqueBloc>(context);
                    bloc.add(CliqueLeave(cliqueId: clique.id));
                  },
                  child: const Text("Leave clique")
              ),
            ],
          ),
          floatingActionButton: switch (userInClique) {
            true => FloatingActionButton.extended(
              // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              // foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              onPressed: () async {
                CliqueBloc bloc = BlocProvider.of<CliqueBloc>(context);
                bloc.add(CliqueIncreaseScore(cliqueId: clique.id, increase: 1));
              },
              label: const Text("Add score"),
              icon: const Icon(Symbols.add),
            ),

            false => FloatingActionButton.extended(
              // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              // foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              onPressed: () async {
                CliqueBloc bloc = BlocProvider.of<CliqueBloc>(context);
                bloc.add(CliqueJoin(cliqueId: clique.id));
              },
              label: const Text("Join"),
              icon: const Icon(Symbols.person_add),
            ),
          },
          body: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.aspectIsLandscape ? landscapeContentWidth : null,
              child: ListView(
                padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                children: [
                  // header(context),
                  switch (scores.isEmpty) {
                    true => const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No participants found!'),
                            Text('Join the clique and start gaining score!')
                          ],
                        )),
                    false => ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 200, top: 10),
                        itemCount: scores.length,
                        itemBuilder: (BuildContext context, int index) {
                          return scoreCard(context, scores[index], index == 0);
                        }),
                  },
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget scoreCard(BuildContext context, Score score, bool isKing) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if(isKing) Text("👑",
              style: Theme.of(context).textTheme.bodyLarge
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(score.userName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text("Score: ${score.score}"),
              ],
            ),

            const Spacer(),

            // TextButton.icon(
            //   onPressed: () => BlocProvider.of<CliquesBloc>(context)
            //       .add(RemoveClique(cliqueId: clique.id)),
            //   label: Text("Delete",
            //     style: TextStyle(color: Theme.of(context).colorScheme.error),
            //   ),
            //   icon: Icon(Symbols.delete_forever,
            //     color: Theme.of(context).colorScheme.error,
            //   ),
            // ),
          ],

        ),
      ),
    );
  }
}