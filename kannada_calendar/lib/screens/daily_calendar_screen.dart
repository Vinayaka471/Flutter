import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive/hive.dart';
import '../widgets/note_card.dart';
import '../models/note_model.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DailyCalendarScreen extends StatefulWidget {
  const DailyCalendarScreen({Key? key}) : super(key: key);

  @override
  State<DailyCalendarScreen> createState() => _DailyCalendarScreenState();
}

class _DailyCalendarScreenState extends State<DailyCalendarScreen> {
  DateTime selectedDay = DateTime.now();
  Box? notesBox;

  // ✅ Dropdown values
  String? selectedRashi;
  String? selectedTingalu;

  final List<String> rashis = [
    'ಮೇಷ',
    'ವೃಷಭ',
    'ಮಿಥುನ',
    'ಕಟಕ',
    'ಸಿಂಹ',
    'ಕನ್ಯಾ',
    'ತುಲಾ',
    'ವೃಶ್ಚಿಕ',
    'ಧನು',
    'ಮಕರ',
    'ಕುಂಭ',
    'ಮೀನ'
  ];

  final List<String> tingalugalu = [
    'ಜನವರಿ',
    'ಫೆಬ್ರವರಿ',
    'ಮಾರ್ಚ್',
    'ಏಪ್ರಿಲ್',
    'ಮೇ',
    'ಜೂನ್',
    'ಜುಲೈ',
    'ಆಗಸ್ಟ್',
    'ಸೆಪ್ಟೆಂಬರ್',
    'ಅಕ್ಟೋಬರ್',
    'ನವೆಂಬರ್',
    'ಡಿಸೆಂಬರ್'
  ];

  @override
  void initState() {
    super.initState();
    if (Hive.isBoxOpen('notes')) {
      notesBox = Hive.box('notes');
    } else {
      notesBox = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final raw = notesBox?.get(selectedDay.toIso8601String()) ?? [];
    List<NoteModel> notesForDay = (raw)
        .map<NoteModel>((n) => NoteModel.fromMap(Map<String, dynamic>.from(n)))
        .toList();

    return SafeArea(
      child: Column(
        children: [
          // 🌟 Title Card "ಕಾಲಸಿರಿ"
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFEB3B), Color(0xFFD32F2F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: const Center(
                child: Text(
                  '🌞 ಕಾಲಸಿರಿ 🌸',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black54,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 🗓 Calendar Section
          TableCalendar(
            locale: 'kn_IN',
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: selectedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
              weekdayStyle: TextStyle(color: Colors.black87),
            ),
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(color: Colors.red),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selected, focused) {
              setState(() {
                selectedDay = selected;
              });
              _addNoteDialog(selected);
            },
          ),

          const SizedBox(height: 10),

          // ✅ Dropdown Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ರಾಶಿ Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedRashi,
                    hint: const Text('ರಾಶಿ ಆಯ್ಕೆಮಾಡಿ'),
                    items: rashis.map((rashi) {
                      return DropdownMenuItem(
                        value: rashi,
                        child: Text(rashi),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRashi = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // ತಿಂಗಳು Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedTingalu,
                    hint: const Text('ತಿಂಗಳು ಆಯ್ಕೆಮಾಡಿ'),
                    items: tingalugalu.map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTingalu = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 📝 Notes List
          Expanded(
            child: ListView.builder(
              itemCount: notesForDay.length,
              itemBuilder: (context, index) {
                return NoteCard(note: notesForDay[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addNoteDialog(DateTime day) {
    TextEditingController textController = TextEditingController();
    Color selectedColor = Colors.yellow;
    String emoji = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ನೋಟ ಸೇರ್ಪಡೆ ಮಾಡಿ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: textController,
                decoration: const InputDecoration(hintText: 'ನೋಟ')),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('ಎಮೋಜಿ:'),
                SizedBox(
                  width: 50,
                  child: TextField(
                    onChanged: (v) => emoji = v,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  child: const Text('ಬಣ್ಣ ಆಯ್ಕೆಮಾಡಿ'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('ಬಣ್ಣ ಆಯ್ಕೆ ಮಾಡಿ'),
                        content: BlockPicker(
                          pickerColor: selectedColor,
                          onColorChanged: (color) {
                            selectedColor = color;
                          },
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'))
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ರದ್ದುಮಾಡಿ'),
          ),
          TextButton(
            onPressed: () {
              final existing = (notesBox?.get(day.toIso8601String()) ?? [])
                  .map<NoteModel>(
                      (n) => NoteModel.fromMap(Map<String, dynamic>.from(n)))
                  .toList();

              existing.add(NoteModel(
                  text: textController.text,
                  color: selectedColor,
                  emoji: emoji));

              if (notesBox != null) {
                notesBox!.put(day.toIso8601String(),
                    existing.map((n) => n.toMap()).toList());
              }

              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('ಸೇವ್ ಮಾಡಿ'),
          ),
        ],
      ),
    );
  }
}
