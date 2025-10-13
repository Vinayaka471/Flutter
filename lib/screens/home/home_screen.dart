import 'package:flutter/material.dart';
import 'package:ybt_match/models/models.dart';
import 'package:ybt_match/screens/home/tournament_detail_screen.dart';
import 'package:ybt_match/services/firestore_service.dart';
import 'package:ybt_match/services/locator.dart';
import 'package:ybt_match/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  String _searchQuery = '';
  String? _gameTypeFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Published Tournaments')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: const InputDecoration(
                      labelText: 'Search by name',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _gameTypeFilter,
                  hint: const Text('Filter'),
                  onChanged: (value) => setState(() => _gameTypeFilter = value),
                  items: ['BGMI', 'Free Fire'] // Example game types
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<TournamentModel>>(
              stream: _firestoreService.getTournaments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong.'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No tournaments found.'));
                }

                var tournaments = snapshot.data!;
                if (_searchQuery.isNotEmpty) {
                  tournaments = tournaments
                      .where((t) => t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                      .toList();
                }
                if (_gameTypeFilter != null) {
                  tournaments = tournaments.where((t) => t.gameType == _gameTypeFilter).toList();
                }

                return ListView.builder(
                  itemCount: tournaments.length,
                  itemBuilder: (context, index) {
                    final tournament = tournaments[index];
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
            ),
          ),
        ],
      ),
    );
  }
}
