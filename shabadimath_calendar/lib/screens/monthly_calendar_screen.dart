import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyCalendarScreen extends StatefulWidget {
  const MonthlyCalendarScreen({super.key});

  static const String routeName = '/monthly_calendar';

  @override
  State<MonthlyCalendarScreen> createState() => _MonthlyCalendarScreenState();
}

class _MonthlyCalendarScreenState extends State<MonthlyCalendarScreen> {
  late DateTime _currentDate;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isPanchangaView = false; // false = monthly calendar, true = panchanga

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String monthYearText = _getMonthYearText();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isPanchangaView ? 'ಪಂಚಾಂಗ' : 'ಮಾಸಿಕ ಕ್ಯಾಲೆಂಡರ್',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.appBarTheme.titleTextStyle?.color ?? Colors.white,
          ),
        ),
        actions: <Widget>[
          if (!_isPanchangaView) // Only show navigation buttons in monthly calendar view
            IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: _goToPreviousMonth,
              tooltip: 'ಹಿಂದಿನ ತಿಂಗಳು',
            ),
          if (!_isPanchangaView) // Only show navigation buttons in monthly calendar view
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed: _goToNextMonth,
              tooltip: 'ಮುಂದಿನ ತಿಂಗಳು',
            ),
          IconButton(
            icon: Icon(_isPanchangaView ? Icons.calendar_month : Icons.calendar_view_day),
            onPressed: _toggleView,
            tooltip: _isPanchangaView ? 'ಮಾಸಿಕ ಕ್ಯಾಲೆಂಡರ್' : 'ಪಂಚಾಂಗ',
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: theme.colorScheme.surface,
            child: Text(
              monthYearText,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 5.0,
                    child: Image.network(
                      _getImageUrl(),
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
                        if (progress == null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                                _hasError = false;
                              });
                            }
                          });
                          return child;
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                              _hasError = true;
                            });
                          }
                        });
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: theme.colorScheme.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _isPanchangaView
                                    ? 'ಈ ತಿಂಗಳ ಪಂಚಾಂಗವನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.'
                                    : 'ಈ ತಿಂಗಳ ಕ್ಯಾಲೆಂಡರ್ ಅನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: _retryLoadImage,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('ಮತ್ತೊಮ್ಮೆ ಪ್ರಯತ್ನಿಸಿ'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleView() {
    setState(() {
      _isPanchangaView = !_isPanchangaView;
      _isLoading = true;
      _hasError = false;
    });
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
      _isLoading = true;
      _hasError = false;
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
      _isLoading = true;
      _hasError = false;
    });
  }

  void _retryLoadImage() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
  }

  String _getImageUrl() {
    final String monthStr = _currentDate.month.toString().padLeft(2, '0');
    final String yearStr = _currentDate.year.toString();

    if (_isPanchangaView){
      // Monthly calendar URL pattern: https://kannadacalendar.in/wp-content/kannada/monthly/{year}/{month}-{year}.jpg
      return 'https://kannadacalendar.in/wp-content/kannada/monthly/$yearStr/$monthStr-$yearStr.jpg';
    } else {
      // Monthly calendar URL pattern: https://kannadacalendar.in/wp-content/kannada/monthly/{year}/{month}-{year}.jpg
      return 'https://kannadacalendar.in/wp-content/kannada/monthly/$yearStr/$monthStr-$yearStr.jpg';
    }
  }

  String _getMonthYearText() {
    final DateFormat formatter = DateFormat.MMMM('kn_IN');
    final String monthName = formatter.format(_currentDate);
    return '$monthName ${_currentDate.year}';
  }
}
