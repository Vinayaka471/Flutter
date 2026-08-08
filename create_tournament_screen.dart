import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../models/tournament.dart';
import '../../../providers/tournament_provider.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  _CreateTournamentScreenState createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _prizePoolController = TextEditingController();
  final _entryFeeController = TextEditingController();
  final _maxSlotsController = TextEditingController();
  final _rulesController = TextEditingController();
  final _photoUrlController = TextEditingController();
  
  String? _selectedGameType;
  String _selectedStatus = 'published';
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _startTime = const TimeOfDay(hour: 12, minute: 0);
  String? _imageUrl;
  bool _isLoading = false;
  final List<String> _gameTypes = [
    'BGMI',
    'Free Fire',
    'Call of Duty',
    'PUBG Mobile',
    'Clash Royale',
    'Clash of Clans',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _prizePoolController.dispose();
    _entryFeeController.dispose();
    _maxSlotsController.dispose();
    _rulesController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _startTime.hour,
          _startTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
        _startDate = DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      // TODO: Implement image upload to Firebase Storage
      // For now, we'll just use a placeholder
      setState(() {
        _imageUrl = 'https://via.placeholder.com/300x150?text=Tournament+Image';
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    final hasManualUrl = _photoUrlController.text.trim().isNotEmpty;
    final hasUploadedImage = _imageUrl != null;

    if (!hasManualUrl && !hasUploadedImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide an image or photo URL')),
      );
      return;
    }
    if (_selectedGameType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a game type')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final manualImageUrl = hasManualUrl
          ? _photoUrlController.text.trim()
          : _imageUrl;

      final tournament = Tournament(
        title: _titleController.text.trim(),
        imageUrl: manualImageUrl!,
        prizePool: double.parse(_prizePoolController.text.trim()),
        entryFee: double.parse(_entryFeeController.text.trim()),
        gameType: _selectedGameType!,
        maxSlots: int.parse(_maxSlotsController.text.trim()),
        startTime: _startDate,
        endTime: _startDate.add(const Duration(hours: 2)), // Default 2-hour duration
        rules: _rulesController.text.trim(),
        status: _selectedStatus.toLowerCase(),
      );

      await Provider.of<TournamentProvider>(context, listen: false)
          .createTournament(tournament);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating tournament: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Tournament'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _submitForm,
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
                    // Tournament Image
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: _imageUrl == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate,
                                      size: 50, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('Tap to add tournament image'),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  _imageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Photo URL
                    TextFormField(
                      controller: _photoUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Photo URL',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                        hintText: 'https://example.com/image.jpg',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Tournament Title',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Game Type Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedGameType,
                      decoration: const InputDecoration(
                        labelText: 'Game Type',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.sports_esports),
                      ),
                      items: _gameTypes.map((gameType) {
                        return DropdownMenuItem(
                          value: gameType,
                          child: Text(gameType),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGameType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a game type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Status Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flag),
                      ),
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

                    // Date and Time Picker
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text:
                                  '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: () => _selectDate(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: _startTime.format(context),
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Start Time',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            onTap: () => _selectTime(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Prize Pool and Entry Fee
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _prizePoolController,
                            decoration: const InputDecoration(
                              labelText: 'Prize Pool (₹)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter prize amount';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _entryFeeController,
                            decoration: const InputDecoration(
                              labelText: 'Entry Fee (₹)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.credit_card),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter entry fee';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Max Slots
                    TextFormField(
                      controller: _maxSlotsController,
                      decoration: const InputDecoration(
                        labelText: 'Maximum Slots',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.people),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter number of slots';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Rules
                    TextFormField(
                      controller: _rulesController,
                      decoration: const InputDecoration(
                        labelText: 'Rules & Regulations',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter tournament rules';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Create Button
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Create Tournament'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
