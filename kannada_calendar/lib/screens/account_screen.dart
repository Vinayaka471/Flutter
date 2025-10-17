// screens/account_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _reminderController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _savedReminder;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'ದಿನಾಂಕ ಆಯ್ಕೆಮಾಡಿ',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveReminder() {
    if (_reminderController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ದಯವಿಟ್ಟು ಎಲ್ಲಾ ವಿವರಗಳನ್ನು ತುಂಬಿ!')),
      );
      return;
    }

    final formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate!);
    final formattedTime = _selectedTime!.format(context);

    setState(() {
      _savedReminder =
          'ಸ್ಮರಣೆ: ${_reminderController.text}\nದಿನಾಂಕ: $formattedDate\nಸಮಯ: $formattedTime';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ಸ್ಮರಣೆ ಉಳಿಸಲಾಗಿದೆ ✅')),
    );
  }

  void _cancelReminder() {
    setState(() {
      _reminderController.clear();
      _selectedDate = null;
      _selectedTime = null;
      _savedReminder = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ನಿಮ್ಮ ಖಾತೆ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'ನಿಮ್ಮ ಸ್ಮರಣೆ ಸೇರಿಸಿ 🕒',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _reminderController,
                decoration: const InputDecoration(
                  labelText: 'ಸ್ಮರಣೆಯ ವಿವರ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickDate(context),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_selectedDate == null
                        ? 'ದಿನಾಂಕ ಆಯ್ಕೆಮಾಡಿ'
                        : DateFormat('dd-MM-yyyy').format(_selectedDate!)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickTime(context),
                    icon: const Icon(Icons.access_time),
                    label: Text(_selectedTime == null
                        ? 'ಸಮಯ ಆಯ್ಕೆಮಾಡಿ'
                        : _selectedTime!.format(context)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveReminder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('ಉಳಿಸಿ'),
                  ),
                  ElevatedButton(
                    onPressed: _cancelReminder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('ರದ್ದುಮಾಡಿ'),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              if (_savedReminder != null)
                Card(
                  color: Colors.yellow[50],
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _savedReminder!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
