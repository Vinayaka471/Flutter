class PanchangaDay {
  PanchangaDay({
    required this.date,
    required this.tithi,
    required this.paksha,
    required this.nakshatra,
    required this.yoga,
    required this.karana,
    required this.festivals,
  });

  final DateTime date;
  final String tithi;
  final String paksha;
  final String nakshatra;
  final String yoga;
  final String karana;
  final List<String> festivals;

  bool get hasFestival => festivals.isNotEmpty;
}
