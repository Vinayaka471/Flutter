import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/tournament.dart';
import '../../providers/tournament_provider.dart';
import 'create_tournament_screen.dart';
import 'tournament_detail_screen.dart';

class TournamentListScreen extends StatefulWidget {
  const TournamentListScreen({super.key});

  @override
  _TournamentListScreenState createState() => _TournamentListScreenState();
}

class _TournamentListScreenState extends State<TournamentListScreen> {
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load tournaments when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TournamentProvider>(context, listen: false).fetchTournaments();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search tournaments...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      // Implement search functionality
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: const [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text('All'),
                    ),
                    DropdownMenuItem(
                      value: 'upcoming',
                      child: Text('Upcoming'),
                    ),
                    DropdownMenuItem(
                      value: 'live',
                      child: Text('Live'),
                    ),
                    DropdownMenuItem(
                      value: 'completed',
                      child: Text('Completed'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedFilter = value;
                      });
                      // Filter tournaments based on selected filter
                      Provider.of<TournamentProvider>(context, listen: false)
                          .filterTournaments(status: value);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TournamentProvider>(
              builder: (context, tournamentProvider, _) {
                if (tournamentProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (tournamentProvider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text('Error: ${tournamentProvider.errorMessage}'),
                  );
                }

                final tournaments = tournamentProvider.filteredTournaments;

                if (tournaments.isEmpty) {
                  return const Center(
                    child: Text('No tournaments found'),
                  );
                }

                return ListView.builder(
                  itemCount: tournaments.length,
                  itemBuilder: (context, index) {
                    final tournament = tournaments[index];
                    return _buildTournamentCard(context, tournament);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTournamentScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTournamentCard(BuildContext context, Tournament tournament) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text(
          tournament.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Prize Pool: ₹${tournament.prizePool}'),
            Text('Entry Fee: ₹${tournament.entryFee}'),
            Text('Slots: ${tournament.joinedPlayers.length}/${tournament.maxSlots}'),
            Text('Starts: ${_formatDate(tournament.startTime)}'),
            _buildStatusChip(tournament.status),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TournamentDetailScreen(tournament: tournament),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    switch (status.toLowerCase()) {
      case 'upcoming':
        backgroundColor = Colors.blue;
        break;
      case 'live':
        backgroundColor = Colors.green;
        break;
      case 'completed':
        backgroundColor = Colors.grey;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: backgroundColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
