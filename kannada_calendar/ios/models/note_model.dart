import 'package:flutter/material.dart';

class NoteModel {
  String text;
  Color color;
  String emoji;

  NoteModel({required this.text, required this.color, required this.emoji});

  Map<String, dynamic> toMap() => {
        'text': text,
        'color': color.value,
        'emoji': emoji,
      };

  factory NoteModel.fromMap(Map<String, dynamic> map) => NoteModel(
        text: map['text'],
        color: Color(map['color']),
        emoji: map['emoji'],
      );
}
