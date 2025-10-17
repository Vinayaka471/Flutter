import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  const NoteCard({required this.note, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color,
      child: ListTile(
        leading: Text(note.emoji, style: const TextStyle(fontSize: 24)),
        title: Text(note.text),
      ),
    );
  }
}
