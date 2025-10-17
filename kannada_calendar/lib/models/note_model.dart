// lib/models/note_model.dart

import 'package:flutter/material.dart';

class NoteModel {
  final String text;
  final Color color;
  final String emoji;

  NoteModel({required this.text, required this.color, required this.emoji});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      // store color as int value so it can be persisted in Hive
      'color': color.value,
      'emoji': emoji,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      text: map['text'] as String? ?? '',
      color: Color((map['color'] as int?) ?? Colors.yellow.value),
      emoji: map['emoji'] as String? ?? '',
    );
  }
}
