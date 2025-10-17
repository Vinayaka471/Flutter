import 'package:flutter/material.dart';

class PanchangaImageScreen extends StatefulWidget {
  const PanchangaImageScreen({super.key, required this.month, required this.year});

  final int month;
  final int year;

  @override
  State<PanchangaImageScreen> createState() => _PanchangaImageScreenState();
}

class _PanchangaImageScreenState extends State<PanchangaImageScreen> {
  late final PageController _pageController;
  late final int _initialPage;
  final Map<int, bool> _loadingStates = <int, bool>{};
  final Map<int, bool> _errorStates = <int, bool>{};

  @override
  void initState() {
    super.initState();
    _initialPage = widget.month - 1;
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ಪಂಚಾಂಗ', style: theme.textTheme.titleLarge?.copyWith(color: theme.appBarTheme.titleTextStyle?.color ?? Colors.white)),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) {
          final int month = index + 1;
          final String title = '${_kannadaMonthLabel(month)} ${widget.year}';
          final String url = _imageUrlFor(month);
          final bool isLoading = _loadingStates[index] ?? true;
          final bool hasError = _errorStates[index] ?? false;
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        ),
                        AspectRatio(
                          aspectRatio: 3 / 4,
                          child: Image.network(
                            url,
                            fit: BoxFit.contain,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
                              if (progress == null) {
                                _handleLoaded(index);
                                return child;
                              }
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              _handleError(index);
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    'ಈ ತಿಂಗಳ ಪಂಚಾಂಗವನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.',
                                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (hasError)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: ElevatedButton.icon(
                      onPressed: () => _retryLoad(index),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('ಮತ್ತೊಮ್ಮೆ ಪ್ರಯತ್ನಿಸಿ'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _handleLoaded(int index) {
    if ((_loadingStates[index] ?? true) && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _loadingStates[index] = false;
          _errorStates[index] = false;
        });
      });
    }
  }

  void _handleError(int index) {
    if ((_errorStates[index] ?? false) || !mounted) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorStates[index] = true;
        _loadingStates[index] = false;
      });
    });
  }

  void _retryLoad(int index) {
    setState(() {
      _loadingStates[index] = true;
      _errorStates[index] = false;
    });
  }

  String _imageUrlFor(int month) {
    final String formattedMonth = month.toString().padLeft(2, '0');
    return 'https://kannadacalendar.in/wp-content/kannada/panchanga/${widget.year}/$formattedMonth-${widget.year}.jpg';
  }

  String _kannadaMonthLabel(int month) {
    const List<String> labels = <String>[
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
    return labels[month - 1];
  }
}
