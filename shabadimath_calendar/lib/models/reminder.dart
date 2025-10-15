import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum ReminderRepeat { none, daily, weekly, yearly }

class Reminder extends HiveObject {
  Reminder({
    required this.id,
    required this.title,
    required this.date,
    this.hour,
    this.minute,
    this.repeat = ReminderRepeat.none,
    this.description,
  });

  String id;

  String title;

  DateTime date;

  int? hour;

  int? minute;

  ReminderRepeat repeat;

  String? description;

  TimeOfDay? get timeOfDay {
    if (hour == null || minute == null) {
      return null;
    }
    return TimeOfDay(hour: hour!, minute: minute!);
  }

  Reminder copyWith({
    String? title,
    DateTime? date,
    int? hour,
    int? minute,
    ReminderRepeat? repeat,
    String? description,
  }) {
    return Reminder(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      repeat: repeat ?? this.repeat,
      description: description ?? this.description,
    );
  }

  DateTime dueDateTime() {
    final TimeOfDay? time = timeOfDay;
    return DateTime(date.year, date.month, date.day, time?.hour ?? 8, time?.minute ?? 0);
  }

  DateTime? nextOccurrence(DateTime from) {
    DateTime scheduled = dueDateTime();
    if (repeat == ReminderRepeat.none) {
      return scheduled.isAfter(from) ? scheduled : null;
    }
    while (!scheduled.isAfter(from)) {
      switch (repeat) {
        case ReminderRepeat.none:
          return scheduled.isAfter(from) ? scheduled : null;
        case ReminderRepeat.daily:
          scheduled = scheduled.add(const Duration(days: 1));
          break;
        case ReminderRepeat.weekly:
          scheduled = scheduled.add(const Duration(days: 7));
          break;
        case ReminderRepeat.yearly:
          scheduled = DateTime(scheduled.year + 1, scheduled.month, scheduled.day, scheduled.hour, scheduled.minute);
          break;
      }
    }
    return scheduled;
  }
}

class ReminderRepeatAdapter extends TypeAdapter<ReminderRepeat> {
  @override
  final int typeId = 0;

  @override
  ReminderRepeat read(BinaryReader reader) {
    final int value = reader.readInt();
    return ReminderRepeat.values[value];
  }

  @override
  void write(BinaryWriter writer, ReminderRepeat obj) {
    writer.writeInt(obj.index);
  }
}

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 1;

  @override
  Reminder read(BinaryReader reader) {
    final String id = reader.readString();
    final String title = reader.readString();
    final DateTime date = DateTime.parse(reader.readString());
    final bool hasHour = reader.readBool();
    final int? hour = hasHour ? reader.readInt() : null;
    final bool hasMinute = reader.readBool();
    final int? minute = hasMinute ? reader.readInt() : null;
    final ReminderRepeat repeat = ReminderRepeat.values[reader.readInt()];
    String? description;
    if (reader.availableBytes > 0) {
      final bool hasDescription = reader.readBool();
      if (hasDescription && reader.availableBytes > 0) {
        description = reader.readString();
      }
    }
    return Reminder(id: id, title: title, date: date, hour: hour, minute: minute, repeat: repeat, description: description);
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.title)
      ..writeString(obj.date.toIso8601String())
      ..writeBool(obj.hour != null);
    if (obj.hour != null) {
      writer.writeInt(obj.hour!);
    }
    writer..writeBool(obj.minute != null);
    if (obj.minute != null) {
      writer.writeInt(obj.minute!);
    }
    writer.writeInt(obj.repeat.index);
    final String? description = obj.description?.trim().isEmpty ?? true ? null : obj.description?.trim();
    writer.writeBool(description != null);
    if (description != null) {
      writer.writeString(description);
    }
  }
}
