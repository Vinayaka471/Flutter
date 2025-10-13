import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class DateCard extends StatelessWidget {
  const DateCard({
    super.key,
    required this.date,
    required this.isFocusedMonth,
    required this.isToday,
    required this.tithi,
    required this.nakshatra,
    required this.festivals,
    required this.onTap,
    this.dayLabel,
    this.subLabel,
    this.backgroundGradient,
    this.backgroundColorOverride,
    this.borderColorOverride,
    this.primaryTextColorOverride,
    this.festivalTextColorOverride,
    this.accentColor,
    this.showBackdrop = true,
  });

  final DateTime date;
  final bool isFocusedMonth;
  final bool isToday;
  final String tithi;
  final String nakshatra;
  final List<String> festivals;
  final VoidCallback onTap;
  final String? dayLabel;
  final String? subLabel;
  final Gradient? backgroundGradient;
  final Color? backgroundColorOverride;
  final Color? borderColorOverride;
  final Color? primaryTextColorOverride;
  final Color? festivalTextColorOverride;
  final Color? accentColor;
  final bool showBackdrop;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color baseColor = isToday
        ? theme.colorScheme.primary
        : (isFocusedMonth
            ? theme.colorScheme.surface.withValues(alpha: theme.brightness == Brightness.dark ? 0.35 : 0.6)
            : theme.colorScheme.surface.withValues(alpha: 0.2));
    final Color defaultTextColor = isToday
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface.withValues(alpha: isFocusedMonth ? 0.85 : 0.45);
    final bool hasFestivals = festivals.isNotEmpty;
    final Gradient? effectiveGradient = backgroundGradient ?? (isToday
        ? LinearGradient(
            colors: <Color>[
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null);
    final Color? effectiveBackgroundColor = backgroundGradient != null
        ? backgroundColorOverride
        : (backgroundColorOverride ?? (isToday ? null : baseColor));
    final Color effectiveBorderColor = borderColorOverride ??
        (hasFestivals
            ? theme.colorScheme.secondary.withValues(alpha: isToday ? 0.4 : 0.7)
            : theme.colorScheme.primary.withValues(alpha: isToday ? 0.4 : 0.1));
    final Color effectiveTextColor = primaryTextColorOverride ?? defaultTextColor;
    final Color effectiveFestivalColor = festivalTextColorOverride ??
        (isToday ? theme.colorScheme.onPrimary : theme.colorScheme.secondary);
    final Color baseShadowColor = accentColor ?? (isToday ? theme.colorScheme.primary : Colors.black12);
    final Color effectiveShadowColor = baseShadowColor.withValues(alpha: 0.25);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 220.ms,
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: effectiveGradient,
          color: effectiveBackgroundColor,
          border: Border.all(
            color: effectiveBorderColor,
            width: hasFestivals ? 1.5 : 1,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: effectiveShadowColor,
              blurRadius: isToday ? 20 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            if (showBackdrop)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: const SizedBox(),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          dayLabel ?? '${date.day}',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: effectiveTextColor,
                          ),
                        ),
                      ),
                      if (hasFestivals)
                        _FestivalDot(
                          color: accentColor ?? effectiveFestivalColor,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (subLabel != null) ...<Widget>[
                    Text(
                      subLabel!,
                      style: GoogleFonts.notoSansKannada(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: effectiveTextColor.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    tithi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: effectiveTextColor.withValues(alpha: 0.95),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nakshatra,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: effectiveTextColor.withValues(alpha: 0.75),
                    ),
                  ),
                  if (hasFestivals) ...<Widget>[
                    const SizedBox(height: 6),
                    ...festivals.take(2).map(
                      (String festival) => Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          festival,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: effectiveFestivalColor.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 180.ms).scale(begin: const Offset(0.96, 0.96), curve: Curves.easeOutBack);
  }
}

class _FestivalDot extends StatelessWidget {
  const _FestivalDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}
