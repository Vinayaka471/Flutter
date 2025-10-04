import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybt_match/models/models.dart';
import 'package:ybt_match/services/firestore_service.dart';
import 'package:ybt_match/services/locator.dart';
import 'package:ybt_match/widgets/widgets.dart';

class TournamentDetailScreen extends StatefulWidget {
  final TournamentModel tournament;

  const TournamentDetailScreen({super.key, required this.tournament});

  @override
  State<TournamentDetailScreen> createState() => _TournamentDetailScreenState();
}

class _TournamentDetailScreenState extends State<TournamentDetailScreen> {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  bool _isLoading = false;

  void _joinTournament() async {
    log('Join tournament button pressed');
    final user = Provider.of<UserModel?>(context, listen: false);
    if (user == null) {
      log('User is not logged in');
      return;
    }

    log('User game type: ${user.gameType}, tournament game type: ${widget.tournament.gameType}');
    if (user.gameType != widget.tournament.gameType) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your registered game (${user.gameType}) does not match the tournament game (${widget.tournament.gameType}).')),
      );
      return;
    }

    log('User wallet balance: ${user.walletBalance}, entry fee: ${widget.tournament.entryFee}');
    if (user.walletBalance < widget.tournament.entryFee) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient wallet balance.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Join'),
        content: Text('Joining this tournament will deduct ₹${widget.tournament.entryFee} from your wallet. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              setState(() => _isLoading = true);
              try {
                log('Joining tournament...');
                await _firestoreService.joinTournament(user.uid, widget.tournament.id, widget.tournament.entryFee);
                log('Successfully joined tournament');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successfully joined tournament!')),
                );
                Navigator.of(context).pop();
              } catch (e) {
                log('Failed to join tournament: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to join: ${e.toString()}')),
                );
              } finally {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tournament.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.tournament.imageUrl ?? 'https://placehold.co/600x400.png'),
            const SizedBox(height: 16),
            Text('Description', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(widget.tournament.description),
            const SizedBox(height: 16),
            Text('Game: ${widget.tournament.gameType}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Date: ${widget.tournament.date.toDate()}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Time: ${widget.tournament.time}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            _buildDetailRow('Prize Pool', '₹${widget.tournament.prize}'),
            _buildDetailRow('Entry Fee', '₹${widget.tournament.entryFee}'),
            _buildDetailRow('Slots', '${widget.tournament.slots}'),
            const SizedBox(height: 16),
            Text('Rules', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(widget.tournament.rules),
            const SizedBox(height: 32),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Center(
                child: CustomButton(
                  text: 'Join Tournament',
                  onPressed: _joinTournament,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
