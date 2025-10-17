// screens/mantra_screen.dart
import 'package:flutter/material.dart';

class MantraScreen extends StatelessWidget {
  const MantraScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> songs = const [
    {
      'title': 'ಶ್ರೀ ಗಣೇಶ ಅರತನೆ',
      'lyrics': '''
ಒಂ ನಮಃ ಗಣಪತಯೇ
ವಕ್ರತುಂಡ ಮಹಾಕಾಯ ಕೋಟಿಸೂರ್ಯ ಸಂಪ್ರಭಾ।
ನಿರ್ವಿಘ್ನಂ ಕುರು ಮೇ ದೇವ ಸರ್ವಕಾರ್ಯೇಷು ಸರ್ವದಾ॥
'''
    },
    {
      'title': 'ಶ್ರೀ ಲಕ್ಷ್ಮಿ ಅಷ್ಟಕಮ್',
      'lyrics': '''
ನಮಸ್ತೇಸ್ತು ಮಹಾಮಾಯೇ ಶ್ರೀಪೀಠೇ ಸುರಪೂಜಿತೇ।
ಶಂಖಚಕ್ರಗದಾಹಸ್ತೇ ಮಹಾಲಕ್ಷ್ಮಿ ನಮೋಸ್ತುತೇ॥
'''
    },
    {
      'title': 'ಶ್ರೀ ವೆಂಕಟೇಶ್ವರ ಸುಪ್ರಭಾತಮ್',
      'lyrics': '''
ಕೌಸಲ್ಯಾ ಸುಪ್ರಜಾ ರಾಮ ಪೂರ್ವಾ ಸಂಧ್ಯಾ ಪ್ರವರ್ತತೇ।
ಉತ್ತಿಷ್ಠ ನರಶಾರ್ಧೂಲ ಕೃತ್ಯಂ ದೇವಮಹಾನಿಶಂ॥
'''
    },
    {
      'title': 'ಶ್ರೀ ಕೃಷ್ಣ ಭಜನೆ',
      'lyrics': '''
ಹರೆ ಕೃಷ್ಣ ಹರೆ ಕೃಷ್ಣ
ಕೃಷ್ಣ ಕೃಷ್ಣ ಹರೆ ಹರೆ।
ಹರೆ ರಾಮ ಹರೆ ರಾಮ
ರಾಮ ರಾಮ ಹರೆ ಹರೆ॥
'''
    },
    {
      'title': 'ಶ್ರೀ ರಾಮಚಂದ್ರ ಅಷ್ಟಕಮ್',
      'lyrics': '''
ಶ್ರೀ ರಾಮ ರಾಮ ರಘುನಂದನ ರಾಮ ರಾಮ।
ಶ್ರೀ ರಾಮ ರಾಮ ಭವರೋಗ ವಿಮೋಚನ ರಾಮ ರಾಮ॥
'''
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ದೇವರ ಸ್ತೋತ್ರಗಳು',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return Card(
            elevation: 6,
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.yellow[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song['title']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    song['lyrics']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
