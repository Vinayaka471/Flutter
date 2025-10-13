import 'dart:ui';

import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Color> colors = isDark
        ? <Color>[const Color(0xFF111827), const Color(0xFF1E1B4B), const Color(0xFF312E81)]
        : <Color>[const Color(0xFFF9FAFB), const Color(0xFFE9D5FF), const Color(0xFFFDE68A)];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -80,
            right: -60,
            child: _GradientBlob(
              colors: <Color>[colors.last.withValues(alpha: 0.6), colors.first.withValues(alpha: 0.2)],
              size: isDark ? 320 : 280,
            ),
          ),
          Positioned(
            bottom: -70,
            left: -40,
            child: _GradientBlob(
              colors: <Color>[colors.first.withValues(alpha: 0.4), colors.last.withValues(alpha: 0.2)],
              size: isDark ? 300 : 260,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.white.withValues(alpha: isDark ? 0.06 : 0.2),
                  Colors.white.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientBlob extends StatelessWidget {
  const _GradientBlob({
    required this.colors,
    required this.size,
  });

  final List<Color> colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}
