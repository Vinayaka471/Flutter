import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PanchangaWebViewScreen extends StatefulWidget {
  const PanchangaWebViewScreen({super.key, required this.url, this.title = 'ಪಂಚಾಂಗ'});

  final String url;
  final String title;

  @override
  State<PanchangaWebViewScreen> createState() => _PanchangaWebViewScreenState();
}

class _PanchangaWebViewScreenState extends State<PanchangaWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: theme.textTheme.titleLarge?.copyWith(color: theme.appBarTheme.titleTextStyle?.color ?? Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
