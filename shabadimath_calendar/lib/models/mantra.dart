import 'package:flutter/material.dart';

class Mantra {
  const Mantra({
    required this.title,
    required this.lines,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final String title;
  final List<String> lines;
  final Color primaryColor;
  final Color secondaryColor;
}
