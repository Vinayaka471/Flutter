import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/tournament.dart';
import '../../../providers/tournament_provider.dart';

class TournamentResultsScreen extends StatefulWidget {
  final Tournament tournament;

  const TournamentResultsScreen({Key? key, required this.tournament}) : super(key: key);

  @override
  _TournamentResultsScreenState createState() => _TournamentResultsScreenState();
}

class _TournamentResultsScreenState extends State<TournamentResultsScreen> {
  final Map<String, double> _results = {};
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Enter Prize Distribution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.tournament.joinedPlayers.length,
                  itemBuilder: (context, index) {
                    final playerId = widget.tournament.joinedPlayers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Text('Player ${index + 1}: '),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Prize Amount',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty) {
                                  _results[playerId] = double.parse(value);
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter prize amount';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      await Provider.of<TournamentProvider>(
                        context,
                        listen: false,
                      ).updateTournament(
                        widget.tournament.copyWith(
                          status: 'completed',
                          results: _results,
                        ),
                      );
                      if (mounted) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error saving results: $e')),
                        );
                      }
                    }
                  }
                },
                child: const Text('Save Results'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
