import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybt_match/models/models.dart';
import 'package:ybt_match/screens/screens.dart';
import 'package:ybt_match/services/firestore_service.dart';
import 'package:ybt_match/services/locator.dart';
import 'package:ybt_match/widgets/widgets.dart';

class MyTournamentsScreen extends StatelessWidget {
  const MyTournamentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final FirestoreService _firestoreService = locator<FirestoreService>();

    if (user == null) {
      return const Center(child: Text('Please log in.'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Tournaments')),
      body: StreamBuilder<List<EntryModel>>(
        stream: _firestoreService.getUserEntries(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You have not joined any tournaments.'));
          }

          final entries = snapshot.data!;

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              // Fetch tournament details for each entry
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('tournaments')
                    .doc(entry.tournamentId)
                    .get(),
                builder: (context, tournamentSnapshot) {
                  if (!tournamentSnapshot.hasData) {
                    return const SizedBox.shrink(); // Or a loading indicator
                  }
                  final tournament = TournamentModel.fromFirestore(tournamentSnapshot.data!);
                  return TournamentCard(
                    tournament: tournament,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TournamentDetailScreen(tournament: tournament),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
