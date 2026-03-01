import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/tournament.dart';
import '../../../providers/tournament_provider.dart';
import 'edit_tournament_screen.dart';
import 'manage_participants_screen.dart';
import 'tournament_results_screen.dart';

class TournamentDetailScreen extends StatelessWidget {
  final Tournament tournament;

  const TournamentDetailScreen({super.key, required this.tournament});

  Future<void> _showDeleteDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Tournament'),
          content: const Text(
              'Are you sure you want to delete this tournament? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await Provider.of<TournamentProvider>(context, listen: false)
                      .deleteTournament(tournament.id);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting tournament: $e')),
                    );
                  }
                }
              },
              child: const Text(
                'DELETE',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditTournamentScreen(tournament: tournament),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tournament Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                tournament.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title and Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    tournament.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(tournament.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tournament.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(tournament.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Game Type
            Text(
              tournament.gameType,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Details Grid
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 16.0;
                int itemsPerRow;
                if (constraints.maxWidth >= 720) {
                  itemsPerRow = 3;
                } else if (constraints.maxWidth >= 400) {
                  itemsPerRow = 2;
                } else {
                  itemsPerRow = 1;
                }

                final detailCards = <Widget>[
                  _buildDetailCard(
                    context,
                    icon: Icons.attach_money,
                    title: 'Prize Pool',
                    value: '₹${tournament.prizePool}',
                  ),
                  _buildDetailCard(
                    context,
                    icon: Icons.credit_card,
                    title: 'Entry Fee',
                    value: '₹${tournament.entryFee}',
                  ),
                  _buildDetailCard(
                    context,
                    icon: Icons.people,
                    title: 'Players',
                    value: '${tournament.maxSlots}',
                  ),
                  _buildDetailCard(
                    context,
                    icon: Icons.calendar_today,
                    title: 'Start Date & Time',
                    value: _formatDateTime(tournament.startTime),
                  ),
                ];

                final totalSpacing = itemsPerRow > 1
                    ? spacing * (itemsPerRow - 1)
                    : 0;
                final itemWidth = (constraints.maxWidth - totalSpacing) / itemsPerRow;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: detailCards
                      .map(
                        (card) => SizedBox(
                          width: itemWidth,
                          child: card,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 24),

            // Action Buttons
            if (['upcoming', 'published']
                .contains(tournament.status.toLowerCase()))
              _buildActionButton(
                context,
                title: 'Start Tournament',
                icon: Icons.play_arrow,
                onPressed: () {
                  // TODO: Implement start tournament
                },
              ),

            _buildActionButton(
              context,
              title: 'Manage Participants',
              icon: Icons.people,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ManageParticipantsScreen(tournament: tournament),
                  ),
                );
              },
            ),

            if (tournament.status.toLowerCase() == 'live')
              _buildActionButton(
                context,
                title: 'End Tournament & Declare Results',
                icon: Icons.flag,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TournamentResultsScreen(tournament: tournament),
                    ),
                  );
                },
              ),

            if (tournament.status.toLowerCase() == 'completed')
              _buildActionButton(
                context,
                title: 'View Results',
                icon: Icons.emoji_events,
                onPressed: () {
                  // TODO: Navigate to results screen
                },
              ),

            const SizedBox(height: 16),

            // Rules Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rules & Regulations',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tournament.rules.isNotEmpty
                          ? tournament.rules
                          : 'No rules specified.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return Colors.blue;
      case 'live':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    return '$day/$month/$year  $hour:$minute $period';
  }
}
