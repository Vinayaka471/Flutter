import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/tournament.dart';
import '../../../providers/tournament_provider.dart';

class EditTournamentScreen extends StatefulWidget {
  final Tournament tournament;

  const EditTournamentScreen({Key? key, required this.tournament}) : super(key: key);

  @override
  _EditTournamentScreenState createState() => _EditTournamentScreenState();
}

class _EditTournamentScreenState extends State<EditTournamentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _prizePoolController;
  late TextEditingController _entryFeeController;
  late TextEditingController _maxSlotsController;
  late TextEditingController _rulesController;
  String _selectedGameType = 'BGMI';
  late String _selectedStatus;
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.tournament.title);
    _prizePoolController = TextEditingController(text: widget.tournament.prizePool.toString());
    _entryFeeController = TextEditingController(text: widget.tournament.entryFee.toString());
    _maxSlotsController = TextEditingController(text: widget.tournament.maxSlots.toString());
    _rulesController = TextEditingController(text: widget.tournament.rules);
    _selectedGameType = widget.tournament.gameType;
    _selectedStatus = widget.tournament.status.toLowerCase();
    _startDate = widget.tournament.startTime;
    _endDate = widget.tournament.endTime;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _prizePoolController.dispose();
    _entryFeeController.dispose();
    _maxSlotsController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: isStart 
          ? _startTime ?? TimeOfDay.now() 
          : _endTime ?? TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      final dateTime = DateTime(
        date.year, 
        date.month, 
        date.day, 
        time.hour, 
        time.minute
      );
      
      if (isStart) {
        _startDate = dateTime;
        _startTime = time;
      } else {
        _endDate = dateTime;
        _endTime = time;
      }
    });
  }

  Future<void> _saveTournament() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end dates')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final tournament = Tournament(
        id: widget.tournament.id,
        title: _titleController.text.trim(),
        imageUrl: widget.tournament.imageUrl, // Using existing image URL
        prizePool: double.parse(_prizePoolController.text),
        entryFee: double.parse(_entryFeeController.text),
        gameType: _selectedGameType,
        maxSlots: int.parse(_maxSlotsController.text),
        startTime: _startDate!,
        endTime: _endDate!,
        rules: _rulesController.text.trim(),
        status: _selectedStatus.toLowerCase(),
        joinedPlayers: widget.tournament.joinedPlayers,
        results: widget.tournament.results,
        createdAt: widget.tournament.createdAt,
        updatedAt: DateTime.now(),
      );

      await Provider.of<TournamentProvider>(context, listen: false)
          .updateTournament(tournament);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating tournament: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tournament'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveTournament,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Tournament Title'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedGameType,
                      items: ['BGMI', 'Free Fire', 'COD Mobile', 'Other']
                          .map((game) => DropdownMenuItem(
                                value: game,
                                child: Text(game),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGameType = value);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Game'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: const [
                        DropdownMenuItem(value: 'published', child: Text('Published')),
                        DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedStatus = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _prizePoolController,
                            decoration: const InputDecoration(
                              labelText: 'Prize Pool',
                              prefixText: '₹ ',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Enter prize amount' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _entryFeeController,
                            decoration: const InputDecoration(
                              labelText: 'Entry Fee',
                              prefixText: '₹ ',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Enter entry fee' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _maxSlotsController,
                      decoration: const InputDecoration(labelText: 'Max Players'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Enter max players' : null,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Tournament Schedule',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              _startDate == null
                                  ? 'Select Start Date/Time'
                                  : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} ${_startTime?.format(context) ?? ''}',
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () => _selectDateTime(context, true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              _endDate == null
                                  ? 'Select End Date/Time'
                                  : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year} ${_endTime?.format(context) ?? ''}',
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () => _selectDateTime(context, false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Tournament Rules',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _rulesController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Enter tournament rules...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter rules' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveTournament,
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
