// screens/panchanga_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PanchangaScreen extends StatefulWidget {
  const PanchangaScreen({Key? key}) : super(key: key);

  @override
  State<PanchangaScreen> createState() => _PanchangaScreenState();
}

class _PanchangaScreenState extends State<PanchangaScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Format year and month
    final selectedYear = selectedDate.year;
    final formattedMonth = DateFormat('MM').format(selectedDate);

    // Panchanga image URL
    final panchangaUrl =
        "https://kannadacalendar.in/wp-content/kannada/panchanga/$selectedYear/$formattedMonth-$selectedYear.jpg";

    return Scaffold(
      appBar: AppBar(
        title: const Text('ಪಂಚಾಂಗ'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Month Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.deepOrange),
                onPressed: () {
                  setState(() {
                    selectedDate =
                        DateTime(selectedDate.year, selectedDate.month - 1, 1);
                  });
                },
              ),
              // ✅ Current Month Name in Kannada (Green Color)
              Text(
                DateFormat('MMMM yyyy', 'kn_IN').format(selectedDate),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.deepOrange),
                onPressed: () {
                  setState(() {
                    selectedDate =
                        DateTime(selectedDate.year, selectedDate.month + 1, 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Panchanga Image
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                panchangaUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                      child: Text(
                    'ಪಂಚಾಂಗ ಚಿತ್ರ ಲಭ್ಯವಿಲ್ಲ',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
