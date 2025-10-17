import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const List<String> _months = <String>[
    'ಜನವರಿ',
    'ಫೆಬ್ರವರಿ',
    'ಮಾರ್ಚ್',
    'ಏಪ್ರಿಲ್',
    'ಮೇ',
    'ಜೂನ್',
    'ಜುಲೈ',
    'ಆಗಸ್ಟ್',
    'ಸೆಪ್ಟೆಂಬರ್',
    'ಅಕ್ಟೋಬರ್',
    'ನವೆಂಬರ್',
    'ಡಿಸೆಂಬರ್',
  ];

const List<_ZodiacPrediction> _predictions = <_ZodiacPrediction>[
    _ZodiacPrediction(
      emoji: '🐏',
      title: 'ಮೇಷ',
      subtitle: '(Aries)',
      months: <String, String>{
        'ಜನವರಿ': 'ಕೆಲಸದಲ್ಲಿ ಹೊಸ ಅವಕಾಶಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಫೆಬ್ರವರಿ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಮಾರ್ಚ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಸವಾಲುಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೇತರಿಕೆ.',
        'ಏಪ್ರಿಲ್': 'ಕೆಲಸದಲ್ಲಿ ಹೊಸ ಅವಕಾಶಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮೇ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಜೂನ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೇತರಿಕೆ.',
        'ಜುಲೈ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸವಾಲುಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಕುಟುಂಬದಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಆಗಸ್ಟ್': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂಬಂಧ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಸೆಪ್ಟೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಪ್ರಗತಿ, ಆರ್ಥಿಕ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಅಕ್ಟೋಬರ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ನವೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಸ್ಥಿತಿ ಸುಧಾರಣೆ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಡಿಸೆಂಬರ್': 'ಸವಾಲುಗಳನ್ನು ಧೈರ್ಯದಿಂದ ಎದುರಿಸಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೇತರಿಕೆ.',
      },
    ),
    _ZodiacPrediction(
      emoji: '🐂',
      title: 'ವೃಷಭ',
      subtitle: '(Taurus)',
      months: <String, String>{
        'ಜನವರಿ': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಫೆಬ್ರವರಿ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮಾರ್ಚ್': 'ಧೈರ್ಯದಿಂದ ಹೊಸ ಸವಾಲುಗಳು, ಹಣಕಾಸು ಸ್ಥಿತಿ ಸುಧಾರಣೆ, ಕುಟುಂಬದಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೇತರಿಕೆ.',
        'ಏಪ್ರಿಲ್': 'ಕೆಲಸದಲ್ಲಿ ಹೊಸ ಅವಕಾಶಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮೇ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಸ್ಥಿತಿ ಸುಧಾರಣೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಜೂನ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೇತರಿಕೆ.',
        'ಜುಲೈ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸವಾಲುಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಕುಟುಂಬದಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಆಗಸ್ಟ್': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂಬಂಧ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಸೆಪ್ಟೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಪ್ರಗತಿ, ಆರ್ಥಿಕ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಅಕ್ಟೋಬರ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ನವೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಸ್ಥಿತಿ ಸುಧಾರಣೆ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಡಿಸೆಂಬರ್': 'ಸವಾಲುಗಳನ್ನು ಧೈರ್ಯದಿಂದ ಎದುರಿಸಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೇತರಿಕೆ.',
      },
    ),
    _ZodiacPrediction(
      emoji: '👭',
      title: 'ಮಿಥುನ',
      subtitle: '(Gemini)',
      months: <String, String>{
        'ಜನವರಿ': 'ಹೊಸ ಯೋಜನೆಗಳು, ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಫೆಬ್ರವರಿ': 'ಧೈರ್ಯದಿಂದ ಸವಾಲುಗಳನ್ನು ಎದುರಿಸಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಕುಟುಂಬ ಮತ್ತು ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಮಾರ್ಚ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಹೊಸ ಅವಕಾಶಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಏಪ್ರಿಲ್': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಮೇ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಲಾಭ, ಸ್ನೇಹಿತರು ಮತ್ತು ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಜೂನ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಜುಲೈ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸವಾಲುಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಕುಟುಂಬದಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಆಗಸ್ಟ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಸುಧಾರಣೆ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂಬಂಧ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಸೆಪ್ಟೆಂಬರ್': 'ಹೊಸ ಯೋಜನೆಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಅಕ್ಟೋಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಸವಾಲುಗಳು, ಆರ್ಥಿಕ ಸ್ಥಿತಿ ಸುಧಾರಣೆ, ಕುಟುಂಬ ಮತ್ತು ಸ್ನೇಹಿತರಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ನವೆಂಬರ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಡಿಸೆಂಬರ್': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
      },
    ),
    _ZodiacPrediction(
      emoji: '🦀',
      title: 'ಕರ್ಕ',
      subtitle: '(Cancer)',
      months: <String, String>{
        'ಜನವರಿ': 'ಹೊಸ ಯೋಜನೆ ಆರಂಭ, ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಫೆಬ್ರವರಿ': 'ಕುಟುಂಬ ಮತ್ತು ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರ್ಥಿಕ ಸ್ಥಿತಿ ಸ್ಥಿರ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಮಾರ್ಚ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಸವಾಲುಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೇತರಿಕೆ.',
        'ಏಪ್ರಿಲ್': 'ಕೆಲಸದಲ್ಲಿ ಹೊಸ ಅವಕಾಶಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮೇ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಸ್ಥಿತಿ ಸುಧಾರಣೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಜೂನ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೇತರಿಕೆ.',
        'ಜುಲೈ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸವಾಲುಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಕುಟುಂಬದಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಆಗಸ್ಟ್': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂಬಂಧ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಸೆಪ್ಟೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಪ್ರಗತಿ, ಆರ್ಥಿಕ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಅಕ್ಟೋಬರ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ನವೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಸ್ಥಿತಿ ಸುಧಾರಣೆ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಡಿಸೆಂಬರ್': 'ಸವಾಲುಗಳನ್ನು ಧೈರ್ಯದಿಂದ ಎದುರಿಸಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೇತರಿಕೆ.',
      },
    ),
    _ZodiacPrediction(
      emoji: '👑',
      title: 'ಸಿಂಹ',
      subtitle: '(Leo)',
      months: <String, String>{
        'ಜನವರಿ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಫೆಬ್ರವರಿ': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮಾರ್ಚ್': 'ವೃತ್ತಿನಲ್ಲಿ ಸವಾಲುಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಏಪ್ರಿಲ್': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಆರ್ಥಿಕ ಸ್ಥಿತಿ ಸುಧಾರಣೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮೇ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಜೂನ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಧೈರ್ಯದಿಂದ ಸವಾಲುಗಳನ್ನು ಎದುರಿಸಿ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಜುಲೈ': 'ವೃತ್ತಿಯಲ್ಲಿ ಪ್ರಗತಿ, ಆರ್ಥಿಕ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಆಗಸ್ಟ್': 'ಹೊಸ ಯೋಜನೆಗಳು, ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಸೆಪ್ಟೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಸವಾಲುಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಅಕ್ಟೋಬರ್': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಆರ್ಥಿಕ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ನವೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಡಿಸೆಂಬರ್': 'ಸವಾಲುಗಳನ್ನು ಧೈರ್ಯದಿಂದ ಎದುರಿಸಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
      },
    ),
    _ZodiacPrediction(
      emoji: '⚖️',
      title: 'ಕನ್ಯಾ',
      subtitle: '(Virgo)',
      months: <String, String>{
        'ಜನವರಿ': 'ಹೊಸ ಯೋಜನೆ ಆರಂಭ, ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಫೆಬ್ರವರಿ': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಮಾರ್ಚ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಸವಾಲುಗಳು, ಆರ್ಥಿಕ ಸ್ಥಿತಿ ಸುಧಾರಣೆ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಏಪ್ರಿಲ್': 'ಧೈರ್ಯದಿಂದ ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಮೇ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಲಾಭ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಜೂನ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಜುಲೈ': 'ವೃತ್ತಿಯಲ್ಲಿ ಪ್ರಗತಿ, ಧೈರ್ಯದಿಂದ ಸವಾಲುಗಳನ್ನು ಎದುರಿಸಿ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಆಗಸ್ಟ್': 'ಹೊಸ ಯೋಜನೆಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಸೆಪ್ಟೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಅಕ್ಟೋಬರ್': 'ಸವಾಲುಗಳನ್ನು ಧೈರ್ಯದಿಂದ ಎದುರಿಸಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ನವೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಪ್ರಗತಿ, ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಡಿಸೆಂಬರ್': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
      },
    ),
    _ZodiacPrediction(
      emoji: '⚖️',
      title: 'ತುಲಾ',
      subtitle: '(Libra)',
      months: <String, String>{
        'ಜನವರಿ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಫೆಬ್ರವರಿ': 'ಧೈರ್ಯದಿಂದ ಹೊಸ ಯೋಜನೆ ಆರಂಭ, ಆರ್ಥಿಕ ಲಾಭ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮಾರ್ಚ್': 'ವೃತ್ತಿನಲ್ಲಿ ಸವಾಲುಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಏಪ್ರಿಲ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಆರ್ಥಿಕ ಲಾಭ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮೇ': 'ವೃತ್ತಿನಲ್ಲಿ ಸಾಧನೆ, ಧೈರ್ಯದಿಂದ ಸವಾಲುಗಳನ್ನು ಎದುರಿಸಿ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಜೂನ್': 'ಹೊಸ ಯೋಜನೆಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಜುಲೈ': 'ವೃತ್ತಿನಲ್ಲಿ ಪ್ರಗತಿ, ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಆಗಸ್ಟ್': 'ವೃತ್ತಿನಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಲಾಭ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಸೆಪ್ಟೆಂಬರ್': 'ಹೊಸ ಯೋಜನೆಗಳು, ಧೈರ್ಯದಿಂದ ಸವಾಲುಗಳನ್ನು ಎದುರಿಸಿ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಅಕ್ಟೋಬರ್': 'ವೃತ್ತಿನಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಸುಧಾರಣೆ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ನವೆಂಬರ್': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಡಿಸೆಂಬರ್': 'ವೃತ್ತಿನಲ್ಲಿ ಪ್ರಗತಿ, ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
      },
    ),
    _ZodiacPrediction(
      emoji: '🦂',
      title: 'ವೃಶ್ಚಿಕ',
      subtitle: '(Scorpio)',
      months: <String, String>{
        'ಜನವರಿ': 'ವೃತ್ತಿನಲ್ಲಿ ಸಾಧನೆ, ಧೈರ್ಯದಿಂದ ಹೊಸ ಯೋಜನೆ ಆರಂಭ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಫೆಬ್ರವರಿ': 'ಹೊಸ ಸವಾಲುಗಳನ್ನು ಧೈರ್ಯದಿಂದ ಎದುರಿಸಿ, ಆರ್ಥಿಕ ಲಾಭ, ಪ್ರೀತಿ ಮತ್ತು ಕುಟುಂಬದಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮಾರ್ಚ್': 'ವೃತ್ತಿನಲ್ಲಿ ಪ್ರಗತಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಸ್ನೇಹಿತರು ಮತ್ತು ಕುಟುಂಬದೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಏಪ್ರಿಲ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮೇ': 'ವೃತ್ತಿನಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಜೂನ್': 'ಸವಾಲುಗಳನ್ನು ಧೈರ್ಯದಿಂದ ಎದುರಿಸಿ, ಆರ್ಥಿಕ ಸ್ಥಿತಿ ಸುಧಾರಣೆ, ಕುಟುಂಬದಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಜುಲೈ': 'ಹೊಸ ಯೋಜನೆಗಳು, ವೃತ್ತಿನಲ್ಲಿ ಪ್ರಗತಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಆಗಸ್ಟ್': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಹೊಸ ಅವಕಾಶಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಸೆಪ್ಟೆಂಬರ್': 'ವೃತ್ತಿನಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಅಕ್ಟೋಬರ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಧೈರ್ಯದಿಂದ ಸವಾಲುಗಳನ್ನು ಎದುರಿಸಿ, ಆರ್ಥಿಕ ಸುಧಾರಣೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ನವೆಂಬರ್': 'ವೃತ್ತಿನಲ್ಲಿ ಪ್ರಗತಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಕುಟುಂಬ ಮತ್ತು ಸ್ನೇಹಿತರೆಲ್ಲರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಡಿಸೆಂಬರ್': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಹೊಸ ಯೋಜನೆಗಳು, ಆರ್ಥಿಕ ಸುಧಾರಣೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
      },
    ),
    _ZodiacPrediction(
      emoji: '🏹',
      title: 'ಧನು',
      subtitle: '(Sagittarius)',
      months: <String, String>{
        'ಜನವರಿ': 'ವೃತ್ತಿನಲ್ಲಿ ಹೊಸ ಅವಕಾಶಗಳು, ಧೈರ್ಯದಿಂದ ಯೋಜನೆ ಆರಂಭ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಫೆಬ್ರವರಿ': 'ವೃತ್ತಿನಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಸುಧಾರಣೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮಾರ್ಚ್': 'ಧೈರ್ಯದಿಂದ ಸವಾಲುಗಳನ್ನು ಎದುರಿಸಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಕುಟುಂಬ ಮತ್ತು ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಏಪ್ರಿಲ್': 'ಹೊಸ ಯೋಜನೆಗಳು, ವೃತ್ತಿನಲ್ಲಿ ಪ್ರಗತಿ, ಆರ್ಥಿಕ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮೇ': 'ವೃತ್ತಿನಲ್ಲಿ ಸಾಧನೆ, ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಜೂನ್': 'ಹೊಸ ಅವಕಾಶಗಳಿಗೆ ಶುರು, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಜುಲೈ': 'ವೃತ್ತಿನಲ್ಲಿ ಸಾಧನೆ, ಆರ್ಥಿಕ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಆಗಸ್ಟ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಧೈರ್ಯದಿಂದ ಸವಾಲುಗಳನ್ನು ಎದುರಿಸಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಸೆಪ್ಟೆಂಬರ್': 'ವೃತ್ತಿನಲ್ಲಿ ಪ್ರಗತಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಕುಟುಂಬ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಅಕ್ಟೋಬರ್': 'ಧೈರ್ಯದಿಂದ ಮುಂದುವರಿಯಿರಿ, ಹೊಸ ಯೋಜನೆಗಳು, ಆರ್ಥಿಕ ಸುಧಾರಣೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ನವೆಂಬರ್': 'ವೃತ್ತಿನಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಡಿಸೆಂಬರ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಧೈರ್ಯದಿಂದ ಸವಾಲುಗಳನ್ನು ಎದುರಿಸಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
      },
    ),
    _ZodiacPrediction(
      emoji: '🐐',
      title: 'ಮಕರ',
      subtitle: '(Capricorn)',
      months: <String, String>{
        'ಜನವರಿ': 'ವೃತ್ತಿನಲ್ಲಿ ಶ್ರಮಕ್ಕೆ ಫಲ, ಹಣಕಾಸಿನಲ್ಲಿ ಸ್ಥಿರತೆ, ಕುಟುಂಬದಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಫೆಬ್ರವರಿ': 'ಹೊಸ ಜವಾಬ್ದಾರಿಗಳು, ಆರ್ಥಿಕ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಉತ್ತಮ ಆರೋಗ್ಯಗಾಗಿ ವಿರಾಮ ಅಗತ್ಯ.',
        'ಮಾರ್ಚ್': 'ವೃತ್ತಿನಲ್ಲಿ ಪ್ರಗತಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಸ್ನೇಹಿತರ ಬೆಂಬಲ, ಆರೋಗ್ಯದಲ್ಲಿ ಚುರುಕು.',
        'ಏಪ್ರಿಲ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ವ್ಯವಸ್ಥಿತ ಯೋಜನೆ, ಆರ್ಥಿಕ ಲಾಭ, ಕುಟುಂಬದಲ್ಲಿ ಒಗ್ಗಟ್ಟು, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮೇ': 'ವೃತ್ತಿನಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಪರಿಶ್ರಮದ ಫಲ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಸ್ಥಿರ.',
        'ಜೂನ್': 'ಹೊಸ ಅವಕಾಶಗಳನ್ನು ಸ್ವೀಕರಿಸಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂವಾದ, ಆರೋಗ್ಯದ ಮೇಲೆ ಗಮನ.',
        'ಜುಲೈ': 'ವೃತ್ತಿನಲ್ಲಿ ಸ್ಥಿರತೆ, ಆರ್ಥಿಕ ಯೋಜನೆ ಯಶಸ್ವಿ, ಕುಟುಂಬದಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಆಗಸ್ಟ್': 'ಹೊಸ ತರಬೇತಿ ಅಥವಾ ಶಿಕ್ಷಣ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಸಮತೋಲನ ಆಹಾರಕ್ಕೆ ಒತ್ತು.',
        'ಸೆಪ್ಟೆಂಬರ್': 'ವೃತ್ತಿನಲ್ಲಿ ಗುರುತಿನೇರಿಕೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರ ನೆರವು, ಮನಸ್ಸಿಗೆ ಶಾಂತಿ.',
        'ಅಕ್ಟೋಬರ್': 'ಹೊಸ ಗುರಿಗಳು, ಆರ್ಥಿಕ ಸ್ಥಿತಿ ಸ್ಥಿರ, ಕುಟುಂಬದಲ್ಲಿ ಸಮಾಧಾನ, ವ್ಯಾಯಾಮಕ್ಕೆ ಸಮಯ ನೀಡಿರಿ.',
        'ನವೆಂಬರ್': 'ವೃತ್ತಿನಲ್ಲಿ ಇನ್ನಷ್ಟು ಅವಕಾಶಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಡಿಸೆಂಬರ್': 'ವರ್ಷಾಂತ್ಯ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಸ್ಥಿರತೆ, ಕುಟುಂಬ ಸಮೇತ ವಿಶ್ರಾಂತಿ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
      },
    ),
    _ZodiacPrediction(
      emoji: '🏺',
      title: 'ಕುಂಭ',
      subtitle: '(Aquarius)',
      months: <String, String>{
        'ಜನವರಿ': 'ಹೊಸ ಆವಿಷ್ಕಾರಗಳಿಗೆ ಪ್ರೋತ್ಸಾಹ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಸ್ನೇಹಿತರ ಬೆಂಬಲ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಫೆಬ್ರವರಿ': 'ಸಂವಾದ ಮತ್ತು ತಂಡದ ಕೆಲಸ ಹೆಚ್ಚಾಗಲಿ, ಆರ್ಥಿಕ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಮಾನಸಿಕ ಶಾಂತಿ.',
        'ಮಾರ್ಚ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಹೊಸ ಯೋಜನೆಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಕುಟುಂಬದೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಏಪ್ರಿಲ್': 'ಸೃಜನಾತ್ಮಕ ಕೆಲಸಗಳಿಗೆ ಅವಕಾಶ, ಆರ್ಥಿಕ ಸ್ಥಿತಿ ಸ್ಥಿರ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂತೋಷ, ಉತ್ತಮ ಆರೋಗ್ಯ.',
        'ಮೇ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯದ ಮೇಲೆ ನಿಯಮಿತ ಗಮನ.',
        'ಜೂನ್': 'ಹೊಸ ಸ್ನೇಹಿತರು, ಆರ್ಥಿಕ ಸುಧಾರಣೆ, ಕುಟುಂಬ ಬೆಂಬಲ, ಮನದಾಳದ ಶಾಂತಿ.',
        'ಜುಲೈ': 'ವೃತ್ತಿಯಲ್ಲಿ ಸವಾಲುಗಳಿಗೆ ಹೊಸ ಪರಿಹಾರ, ಹಣಕಾಸಿನಲ್ಲಿ ಸ್ಥಿರತೆ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಆಗಸ್ಟ್': 'ಹೊಸ ಕಲಿಕೆ ಅವಕಾಶಗಳು, ಆರ್ಥಿಕ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಂಪರ್ಕ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಸೆಪ್ಟೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಗುರುತಿನೇರಿಕೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಕುಟುಂಬದಲ್ಲಿ ಸಂತೋಷ, ಮನಸ್ಸಿಗೆ ಶಾಂತಿ.',
        'ಅಕ್ಟೋಬರ್': 'ಸಂವಹನಕ್ಕೆ ಒತ್ತು, ಆರ್ಥಿಕ ಯೋಜನೆ ಯಶಸ್ವಿ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಉತ್ತಮ ಆರೋಗ್ಯ.',
        'ನವೆಂಬರ್': 'ಹೊಸ ಅನುಭವ ಅಥವಾ ಪ್ರಯಾಣ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರ ಬೆಂಬಲ, ಆರೋಗ್ಯ ಸ್ಥಿರ.',
        'ಡಿಸೆಂಬರ್': 'ವರ್ಷಾಂತ್ಯ ಸಂತೋಷ, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಕುಟುಂಬ ಸಮೇತ ಉತ್ಸವ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
      },
    ),
    _ZodiacPrediction(
      emoji: '🐟',
      title: 'ಮೀನ',
      subtitle: '(Pisces)',
      months: <String, String>{
        'ಜನವರಿ': 'ಸೃಜನಾತ್ಮಕ ಚಟುವಟಿಕೆಗಳಿಗೆ ಪ್ರೋತ್ಸಾಹ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಕುಟುಂಬದಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಫೆಬ್ರವರಿ': 'ಮಾತಿನ ಮೂಲಕ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಆರ್ಥಿಕ ಲಾಭ, ಸ್ನೇಹಿತರ ಬೆಂಬಲ, ಮನಸ್ಸಿಗೆ ಶಾಂತಿ.',
        'ಮಾರ್ಚ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಹೊಸ ಅವಕಾಶಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಪ್ರೀತಿ ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಏಪ್ರಿಲ್': 'ಸಾಧನೆಯ ತಿಂಗಳು, ಹಣಕಾಸಿನಲ್ಲಿ ಸ್ಥಿರತೆ, ಕುಟುಂಬದಲ್ಲಿ ಸಮಾಧಾನ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಮೇ': 'ಹೊಸ ಕಲಿಕೆ ಅಥವಾ ಆಧ್ಯಾತ್ಮಿಕ ಚಟುವಟಿಕೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಮನದ ಶಾಂತಿ.',
        'ಜೂನ್': 'ಸಹಾನುಭೂತಿ ಹೆಚ್ಚಿಸಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಜುಲೈ': 'ವೃತ್ತಿಯಲ್ಲಿ ತುಂಬು ಪ್ರಗತಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಕುಟುಂಬದಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ಆಗಸ್ಟ್': 'ಹೊಸ ಯೋಜನೆಗಳಿಗೆ ಶುರು, ಆರ್ಥಿಕ ಸುಧಾರಣೆ,सัมพันธ’ಗಳಲ್ಲಿ ಸಮಾಧಾನ, ಮನಸ್ಸಿಗೆ ಸಮತೋಲನ.',
        'ಸೆಪ್ಟೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಬದಲಾವಣೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಏರಿಕೆ, ಸ್ನೇಹಿತರ ಬೆಂಬಲ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
        'ಅಕ್ಟೋಬರ್': 'ಸೃಜನಾತ್ಮಕ ಬೆಳವಣಿಗೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸಂಬಂಧಗಳಲ್ಲಿ ಸಂತೋಷ, ಆರೋಗ್ಯ ಚೆನ್ನಾಗಿರಲಿ.',
        'ನವೆಂಬರ್': 'ವೃತ್ತಿಯಲ್ಲಿ ಸಾಧನೆ, ಹಣಕಾಸಿನಲ್ಲಿ ಸುಧಾರಣೆ, ಕುಟುಂಬದಲ್ಲಿ ಸಮಾಧಾನ, ಮನಸ್ಸಿಗೆ ಶಾಂತಿ.',
        'ಡಿಸೆಂಬರ್': 'ವರ್ಷಾಂತ್ಯ ಸಮೃದ್ಧಿ, ಹಣಕಾಸಿನಲ್ಲಿ ಲಾಭ, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಉತ್ಸಾಹ, ಆರೋಗ್ಯ ಉತ್ತಮ.',
      },
    ),
  ];

class RashiBhavishyaScreen extends StatelessWidget {
  const RashiBhavishyaScreen({super.key, this.initialMonth});

  final String? initialMonth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ರಾಶಿ ಭವಿಷ್ಯ'),
      ),
      body: SafeArea(
        child: RashiBhavishyaPanel(initialMonth: initialMonth),
      ),
    );
  }
}

class _RashiDetailCard extends StatelessWidget {
  const _RashiDetailCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.month,
    required this.description,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final String month;
  final String description;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: <Color>[
              theme.colorScheme.primaryContainer.withValues(alpha: 0.9),
              theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: GoogleFonts.notoSansKannada(fontSize: 20, fontWeight: FontWeight.w800, color: theme.colorScheme.onPrimaryContainer),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.calendar_month_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    month,
                    style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w600, height: 1.55, color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.95)),
            ),
          ],
        ),
      ),
    );
  }
}

class _RashiPlaceholder extends StatelessWidget {
  const _RashiPlaceholder({
    super.key,
    required this.icon,
    required this.message,
    required this.theme,
  });

  final IconData icon;
  final String message;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.18), width: 1.1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 32, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w700, color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

class RashiBhavishyaPanel extends StatefulWidget {
  const RashiBhavishyaPanel({
    super.key,
    this.padding,
    this.scrollable = true,
    this.initialZodiac,
    this.initialMonth,
  });

  final EdgeInsetsGeometry? padding;
  final bool scrollable;
  final String? initialZodiac;
  final String? initialMonth;

  @override
  State<RashiBhavishyaPanel> createState() => _RashiBhavishyaPanelState();
}

class _RashiBhavishyaPanelState extends State<RashiBhavishyaPanel> {
  String? _selectedZodiac;
  String? _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedZodiac = widget.initialZodiac;
    _selectedMonth = widget.initialMonth;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final EdgeInsetsGeometry padding = widget.padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 24);

    _ZodiacPrediction? prediction;
    if (_selectedZodiac != null) {
      try {
        prediction = _predictions.firstWhere((_ZodiacPrediction item) => item.title == _selectedZodiac);
      } catch (_) {
        prediction = null;
      }
    }

    final String? horoscopeText =
        prediction != null && _selectedMonth != null ? prediction.months[_selectedMonth!] : null;

    Widget detailSection;
    if (_selectedZodiac == null) {
      detailSection = _RashiPlaceholder(
        key: const ValueKey<String>('placeholder-zodiac'),
        icon: Icons.auto_awesome_rounded,
        message: 'ಉಚಿತ ಮಾರ್ಗದರ್ಶನಕ್ಕಾಗಿ ನಿಮ್ಮ ರಾಶಿಯನ್ನು ಆಯ್ಕೆ ಮಾಡಿ.',
        theme: theme,
      );
    } else if (_selectedMonth == null) {
      detailSection = _RashiPlaceholder(
        key: const ValueKey<String>('placeholder-month'),
        icon: Icons.calendar_month_rounded,
        message: 'ಮಾಸಿಕ ಭವಿಷ್ಯವನ್ನು ನೋಡಲು ತಿಂಗಳ ಆಯ್ಕೆಯನ್ನು ಮಾಡಿ.',
        theme: theme,
      );
    } else if (horoscopeText == null) {
      detailSection = _RashiPlaceholder(
        key: const ValueKey<String>('placeholder-empty'),
        icon: Icons.hourglass_bottom_rounded,
        message: 'ಈ ಆಯ್ಕೆಗೆ ಮಾಹಿತಿಯನ್ನು ದೊರಕಿಸಲು ಸಾಧ್ಯವಾಗಿಲ್ಲ. ದಯವಿಟ್ಟು ಬೇರೆ ತಿಂಗಳನ್ನು ಪ್ರಯತ್ನಿಸಿ.',
        theme: theme,
      );
    } else {
      detailSection = _RashiDetailCard(
        key: ValueKey<String>('detail-${prediction?.title}-${_selectedMonth}'),
        emoji: prediction?.emoji ?? '',
        title: prediction?.title ?? '',
        subtitle: prediction?.subtitle ?? '',
        month: _selectedMonth!,
        description: horoscopeText,
      );
    }

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _DropdownField(
          label: 'ರಾಶಿ',
          value: _selectedZodiac,
          items: _predictions
              .map(
                (_ZodiacPrediction prediction) => DropdownMenuItem<String>(
                  value: prediction.title,
                  child: Text('${prediction.emoji} ${prediction.title} ${prediction.subtitle}'),
                ),
              )
              .toList(),
          onChanged: (String? value) => setState(() => _selectedZodiac = value),
          onClear: () => setState(() => _selectedZodiac = null),
        ),
        const SizedBox(height: 12),
        _DropdownField(
          label: 'ತಿಂಗಳು',
          value: _selectedMonth,
          items: _months
              .map(
                (String month) => DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                ),
              )
              .toList(),
          onChanged: (String? value) => setState(() => _selectedMonth = value),
          onClear: () => setState(() => _selectedMonth = null),
        ),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              FadeTransition(opacity: animation, child: child),
          child: detailSection,
        ),
      ],
    );

    if (widget.scrollable) {
      return SingleChildScrollView(
        padding: padding,
        child: content,
      );
    }

    return Padding(
      padding: padding,
      child: content,
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.items,
    required this.onChanged,
    required this.onClear,
    this.value,
  });

  final String label;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        suffixIcon: value != null
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: onClear,
              )
            : null,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text('ಆಯ್ಕೆ ಮಾಡಿ', style: theme.textTheme.bodyMedium),
          isExpanded: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ZodiacPrediction {
  const _ZodiacPrediction({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.months,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Map<String, String> months;
}
