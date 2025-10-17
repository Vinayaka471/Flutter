import 'package:flutter/material.dart';

class KannadaBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const KannadaBottomNavBar(
      {required this.currentIndex, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: "ದೈನಂದಿನ ದಿನಾಂಕ"),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: "ಪಂಚಾಂಗ"),
        BottomNavigationBarItem(icon: Icon(Icons.mic), label: "ಮಂತ್ರ"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "ನಿಮ್ಮ ಖಾತೆ"),
      ],
    );
  }
}
