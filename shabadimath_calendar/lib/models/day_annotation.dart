class DayAnnotation {
  DayAnnotation({
    String? note,
    String? colorKey,
    List<String>? emojis,
  })  : note = note?.trim() ?? '',
        colorKey = colorKey,
        emojis = List<String>.from(emojis ?? <String>[]);

  final String note;
  final String? colorKey;
  final List<String> emojis;

  bool get hasContent => note.isNotEmpty || colorKey != null || emojis.isNotEmpty;

  DayAnnotation copyWith({String? note, String? colorKey, List<String>? emojis}) {
    return DayAnnotation(
      note: note ?? this.note,
      colorKey: colorKey ?? this.colorKey,
      emojis: emojis ?? this.emojis,
    );
  }

  factory DayAnnotation.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawEmojis = json['emojis'] as List<dynamic>? ?? <dynamic>[];
    final String? rawColorKey = json['colorKey'] as String?;
    final String? normalizedColorKey = rawColorKey == 'green' ? 'bronze' : rawColorKey;
    return DayAnnotation(
      note: json['note'] as String?,
      colorKey: normalizedColorKey,
      emojis: rawEmojis.whereType<String>().toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'note': note,
      'colorKey': colorKey,
      'emojis': List<String>.from(emojis),
    };
  }
}
