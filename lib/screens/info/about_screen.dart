import 'package:flutter/material.dart';
import 'package:ybt_match/screens/info/info_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoScreen(
      title: 'About Us',
      content: 'This is the About Us page. Replace this with your content.',
    );
  }
}
