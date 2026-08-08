import 'package:flutter/material.dart';
import '../../../models/tournament.dart';

class ManageParticipantsScreen extends StatelessWidget {
  final Tournament tournament;

  const ManageParticipantsScreen({Key? key, required this.tournament}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Participants'),
      ),
      body: ListView.builder(
        itemCount: tournament.joinedPlayers.length,
        itemBuilder: (context, index) {
          final playerId = tournament.joinedPlayers[index];
          return ListTile(
            title: Text('Player ${index + 1}'),
            subtitle: Text('ID: $playerId'),
          );
        },
      ),
    );
  }
}
