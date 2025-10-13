import 'package:flutter/material.dart';

class CalendarEvent {
  CalendarEvent({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    this.type = EventType.general,
    this.icon,
    this.shabadId,
  });

  final String id;
  final DateTime date;
  final String title;
  final String description;
  final EventType type;
  final IconData? icon;
  final String? shabadId;

  bool get isGurpurab => type == EventType.gurpurab;
}

enum EventType {
  general,
  gurpurab,
  hukamnama,
}
