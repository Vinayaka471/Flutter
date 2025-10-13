import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/shabad.dart';

class ShabadCard extends StatelessWidget {
  const ShabadCard({
    super.key,
    required this.shabad,
    this.onShare,
  });

  final Shabad shabad;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            theme.colorScheme.primary.withValues(alpha: 0.85),
            theme.colorScheme.secondary.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.25),
            offset: const Offset(0, 20),
            blurRadius: 40,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      shabad.title,
                      style: GoogleFonts.playfairDisplay(
                        textStyle: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${shabad.source} • ${shabad.raag}',
                      style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            letterSpacing: 0.6,
                          ),
                    ),
                  ],
                ),
              ),
              if (onShare != null)
                IconButton(
                  onPressed: onShare,
                  icon: const Icon(Icons.share, color: Colors.white),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            shabad.gurmukhi,
            style: GoogleFonts.gurajada(
              textStyle: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    height: 1.6,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  shabad.transliteration,
                  style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  shabad.translation,
                  style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        height: 1.6,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.08, curve: Curves.easeOutCubic);
  }
}
