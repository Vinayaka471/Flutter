import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/day_annotation.dart';
import '../models/panchanga_day.dart';
import '../models/reminder.dart';
import '../providers/app_state.dart';
import '../providers/reminder_provider.dart';
import '../utils/data_utils.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';
import 'panchanga_image_screen.dart';
import 'rashi_bhavishya_screen.dart';
import '../services/ad_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _MonthlySlidePageRoute<T> extends PageRouteBuilder<T> {
  _MonthlySlidePageRoute({required WidgetBuilder builder})
      : super(
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 260),
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => builder(context),
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            final Animation<Offset> slideAnimation = Tween<Offset>(
              begin: const Offset(0.1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic));
            final Animation<double> fadeAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutQuad, reverseCurve: Curves.easeInQuad);
            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            );
          },
        );
}

class _MonthlyActionButton extends StatelessWidget {
  const _MonthlyActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.theme,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        textStyle: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 5,
        shadowColor: theme.colorScheme.primary.withValues(alpha: 0.45),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }
}

class _PanchangaYearButton extends StatelessWidget {
  const _PanchangaYearButton({
    required this.year,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final int year;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? <Color>[const Color(0xFF0F4AA3), const Color(0xFF1E88E5)]
                : <Color>[Colors.white, const Color(0xFFF8FAFC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F4AA3) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1.2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF0F4AA3).withValues(alpha: isSelected ? 0.3 : 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: GoogleFonts.notoSansKannada(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : const Color(0xFF0F4AA3),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'ಪಂಚಾಂಗ',
              style: GoogleFonts.notoSansKannada(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.9)
                    : const Color(0xFF0F4AA3).withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayAnnotationSheet extends StatefulWidget {
  const _DayAnnotationSheet({
    required this.formattedDateLabel,
    required this.details,
    required this.events,
    required this.existingAnnotation,
    required this.shabadTitle,
    required this.shabadGurmukhi,
  });

  final String formattedDateLabel;
  final PanchangaDay? details;
  final List<String> events;
  final DayAnnotation? existingAnnotation;
  final String shabadTitle;
  final String shabadGurmukhi;

  @override
  State<_DayAnnotationSheet> createState() => _DayAnnotationSheetState();
}

class _DayAnnotationSheetState extends State<_DayAnnotationSheet> {
  late final TextEditingController _noteController;
  String? _selectedColorKey;
  late Set<String> _selectedEmojis;
  bool _showColorPalette = false;
  bool _showEmojiSelection = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.existingAnnotation?.note ?? '');
    _selectedColorKey = widget.existingAnnotation?.colorKey;
    _selectedEmojis = <String>{...widget.existingAnnotation?.emojis ?? <String>[]};
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _NoteHighlightPalette? selectedPalette =
        _selectedColorKey != null ? _noteHighlightPalettes[_selectedColorKey] : null;
    final DayAnnotation? savedAnnotation = widget.existingAnnotation;
    final bool hasSavedAnnotation = savedAnnotation != null && savedAnnotation.hasContent;
    final String savedNote = savedAnnotation?.note ?? '';
    final String? savedColorKey = savedAnnotation?.colorKey;
    final _NoteHighlightPalette? savedPalette = savedColorKey != null ? _noteHighlightPalettes[savedColorKey] : null;
    final List<String> savedEmojis = savedAnnotation?.emojis ?? <String>[];

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: GlassCard(
        borderRadius: 28,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 64,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F4AA3).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              if (hasSavedAnnotation)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: savedPalette != null
                        ? savedPalette.accent.withValues(alpha: 0.18)
                        : const Color(0xFF0F4AA3).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: (savedPalette?.accent ?? const Color(0xFF0F4AA3)).withValues(alpha: 0.45),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'ಸಂಗ್ರಹಿತ ವಿವರಗಳು',
                        style: GoogleFonts.notoSansKannada(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: (savedPalette?.accent ?? const Color(0xFF0F4AA3)).withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'ಟಿಪ್ಪಣಿ',
                            style: GoogleFonts.notoSansKannada(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F4AA3).withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              savedNote.isNotEmpty ? savedNote : '—',
                              style: GoogleFonts.notoSansKannada(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F4AA3),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Text(
                            'ಬಣ್ಣ',
                            style: GoogleFonts.notoSansKannada(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F4AA3).withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 36,
                            height: 20,
                            decoration: BoxDecoration(
                              color: savedPalette?.accent.withValues(alpha: 0.16) ?? const Color(0xFF0F4AA3).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: (savedPalette?.accent ?? const Color(0xFF0F4AA3)).withValues(alpha: 0.7),
                                width: 1.2,
                              ),
                            ),
                            child: savedPalette != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9),
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          savedPalette.accent.withValues(alpha: 0.92),
                                          savedPalette.accent,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      '—',
                                      style: GoogleFonts.notoSansKannada(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F4AA3).withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'ಇಮೋಜಿ',
                            style: GoogleFonts.notoSansKannada(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F4AA3).withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              savedEmojis.isNotEmpty ? savedEmojis.join(' ') : '—',
                              style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF0F4AA3)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (hasSavedAnnotation) const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.formattedDateLabel,
                      style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF0F4AA3)),
                    ),
                  ),
                  if (selectedPalette != null)
                    Container(
                      width: 48,
                      height: 20,
                      decoration: BoxDecoration(
                        color: selectedPalette.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: selectedPalette.accent.withValues(alpha: 0.75), width: 1.2),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          gradient: LinearGradient(
                            colors: <Color>[
                              selectedPalette.accent.withValues(alpha: 0.9),
                              selectedPalette.accent,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              _HomeScreenState._detailRow(theme, 'ತಿಥಿ', widget.details?.tithi ?? '—'),
              _HomeScreenState._detailRow(theme, 'ಪಕ್ಷ', widget.details?.paksha ?? '—'),
              _HomeScreenState._detailRow(theme, 'ನಕ್ಷತ್ರ', widget.details?.nakshatra ?? '—'),
              _HomeScreenState._detailRow(theme, 'ಯೋಗ', widget.details?.yoga ?? '—'),
              _HomeScreenState._detailRow(theme, 'ಕರಣ', widget.details?.karana ?? '—'),
              if (widget.events.isNotEmpty) ...<Widget>[
                const SizedBox(height: 18),
                Text(
                  'ಉತ್ಸವಗಳು',
                  style: GoogleFonts.notoSansKannada(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F4AA3),
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.events.map(
                  (String festival) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $festival', style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF0F4AA3))),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text('ದಿನದ ಶಬ್ದ', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF0F4AA3))),
              const SizedBox(height: 6),
              Text(widget.shabadTitle, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF0F4AA3))),
              const SizedBox(height: 6),
              Text(widget.shabadGurmukhi, style: theme.textTheme.bodyMedium?.copyWith(height: 1.4, color: const Color(0xFF0F4AA3))),
              const SizedBox(height: 22),
              Text(
                'ಟಿಪ್ಪಣಿ ಸೇರಿಸಿ',
                style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0F4AA3)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 3,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'ನಿಮ್ಮ ಟಿಪ್ಪಣಿಯನ್ನು ಇಲ್ಲಿ ಬರೆಯಿರಿ...',
                  hintStyle: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w500, color: const Color(0xFF0F4AA3).withValues(alpha: 0.6)),
                  filled: true,
                  fillColor: const Color(0xFF0F4AA3).withValues(alpha: 0.1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: const Color(0xFF0F4AA3).withValues(alpha: 0.3))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: const Color(0xFF0F4AA3), width: 1.4)),
                ),
                style: GoogleFonts.notoSansKannada(fontSize: 14.5, fontWeight: FontWeight.w600, color: const Color(0xFF0F4AA3)),
              ),
              const SizedBox(height: 18),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showColorPalette = !_showColorPalette;
                          _showEmojiSelection = false; // Close emoji when opening color
                        });
                      },
                      icon: const Icon(Icons.palette_rounded, color: Colors.white),
                      label: Text('ಬಣ್ಣ', style: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F4AA3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showEmojiSelection = !_showEmojiSelection;
                          _showColorPalette = false; // Close color when opening emoji
                        });
                      },
                      icon: const Icon(Icons.emoji_emotions_rounded, color: Colors.white),
                      label: Text('ಇಮೋಜಿ', style: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F4AA3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 3,
                      ),
                    ),
                  ),
                ],
              ),
              if (_showColorPalette) ...<Widget>[
                const SizedBox(height: 18),
                Text(
                  'ಬಣ್ಣದಿಂದ ಹೈಲೈಟ್ ಮಾಡಿ',
                  style: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF0F4AA3)),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _noteHighlightPalettes.entries.map((MapEntry<String, _NoteHighlightPalette> entry) {
                    final bool isSelected = entry.key == _selectedColorKey;
                    final List<Color> gradientColors = isSelected
                        ? <Color>[entry.value.accent.withValues(alpha: 0.92), entry.value.accent]
                        : <Color>[entry.value.background, entry.value.accent.withValues(alpha: 0.75)];
                    return ChoiceChip(
                      label: Container(
                        width: 36,
                        height: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (bool value) {
                        setState(() {
                          _selectedColorKey = value ? entry.key : null;
                        });
                      },
                      selectedColor: entry.value.accent.withValues(alpha: 0.22),
                      backgroundColor: const Color(0xFF0F4AA3).withValues(alpha: 0.1),
                      side: BorderSide(color: entry.value.accent.withValues(alpha: isSelected ? 0.9 : 0.4), width: isSelected ? 1.6 : 1),
                      labelStyle: GoogleFonts.notoSansKannada(color: entry.value.accent, fontWeight: FontWeight.w800),
                    );
                  }).toList(),
                ),
              ],
              if (_showEmojiSelection) ...<Widget>[
                const SizedBox(height: 18),
                Text(
                  'ಇಮೋಜಿ ಆಯ್ಕೆಮಾಡಿ',
                  style: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF0F4AA3)),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _annotationEmojis.map((String emoji) {
                    final bool isSelected = _selectedEmojis.contains(emoji);
                    return FilterChip(
                      label: Text(emoji, style: const TextStyle(fontSize: 18)),
                      selected: isSelected,
                      onSelected: (bool value) {
                        setState(() {
                          if (value) {
                            _selectedEmojis.add(emoji);
                          } else {
                            _selectedEmojis.remove(emoji);
                          }
                        });
                      },
                      selectedColor: const Color(0xFF0F4AA3).withValues(alpha: 0.2),
                      showCheckmark: false,
                      backgroundColor: const Color(0xFF0F4AA3).withValues(alpha: 0.1),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 26),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(_AnnotationResult.clear());
                      },
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: Text('ಅಳಿಸಿ', style: GoogleFonts.notoSansKannada(fontWeight: FontWeight.w700, color: const Color(0xFF0F4AA3))),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        side: BorderSide(color: const Color(0xFF0F4AA3).withValues(alpha: 0.5), width: 1.2),
                        foregroundColor: const Color(0xFF0F4AA3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        final DayAnnotation annotation = DayAnnotation(
                          note: _noteController.text,
                          colorKey: _selectedColorKey,
                          emojis: _selectedEmojis.toList(),
                        );
                        Navigator.of(context).pop(_AnnotationResult.save(annotation));
                      },
                      icon: const Icon(Icons.save_rounded),
                      label: Text('ಸಂಗ್ರಹಿಸಿ', style: GoogleFonts.notoSansKannada(fontWeight: FontWeight.w800, color: Colors.white)),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0F4AA3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FestivalStaticEntry {
  _FestivalStaticEntry({required this.name, required this.date});

  final String name;
  final DateTime date;
}

final Map<int, List<_FestivalStaticEntry>> _curatedMonthlyFestivals2026 = <int, List<_FestivalStaticEntry>>{
  1: <_FestivalStaticEntry>[
    _FestivalStaticEntry(name: 'ಹಜ್ರತ್ ಅಲಿ ಹುಬ್ಬು', date: DateTime(2026, 1, 3)),
    _FestivalStaticEntry(name: 'ಹಬ್ಬ್ ಅಲಿ ಹುಬ್ಬು', date: DateTime(2026, 1, 3)),
    _FestivalStaticEntry(name: 'ಮಕರ ಸಂಕ್ರಾಂತಿ', date: DateTime(2026, 1, 14)),
    _FestivalStaticEntry(name: 'ವಸಂತ ಪಂಚಮಿ', date: DateTime(2026, 1, 23)),
  ],
  2: <_FestivalStaticEntry>[
    _FestivalStaticEntry(name: 'ಹನುಮಾನ್ ಜಯಂತಿ', date: DateTime(2026, 2, 2)),
    _FestivalStaticEntry(name: 'ಹಬ್ಬ್ ಅಲಿ ಹುಬ್ಬು', date: DateTime(2026, 2, 3)),
    _FestivalStaticEntry(name: 'ಮಹಾಶಿವರಾತ್ರಿ', date: DateTime(2026, 2, 15)),
    _FestivalStaticEntry(name: 'ಬಸಂತ ಪಂಚಮಿ', date: DateTime(2026, 2, 23)),
  ],
  3: <_FestivalStaticEntry>[
    _FestivalStaticEntry(name: 'ಹೋಳಿ', date: DateTime(2026, 3, 4)),
    _FestivalStaticEntry(name: 'ರಮಜಾನ್ ಆರಂಭ', date: DateTime(2026, 3, 20)),
    _FestivalStaticEntry(name: 'ರಮಜಾನ್ ಮುಕ್ತಾಯ', date: DateTime(2026, 3, 20)),
  ],
  4: <_FestivalStaticEntry>[
    _FestivalStaticEntry(name: 'ಬೈಸಾಖಿ', date: DateTime(2026, 4, 14)),
    _FestivalStaticEntry(name: 'ಅಂಬೇಡ್ಕರ್ ಜಯಂತಿ', date: DateTime(2026, 4, 14)),
    _FestivalStaticEntry(name: 'ಗುರು ರವೀದಾಸ್ ಜಯಂತಿ', date: DateTime(2026, 4, 14)),
    _FestivalStaticEntry(name: 'ಬುದ್ಧ ಪೂರ್ಣಿಮಾ', date: DateTime(2026, 4, 14)),
  ],
  5: <_FestivalStaticEntry>[
    _FestivalStaticEntry(name: 'ಗುರು ರವೀದಾಸ್ ಜಯಂತಿ', date: DateTime(2026, 5, 14)),
    _FestivalStaticEntry(name: 'ಬುದ್ಧ ಪೂರ್ಣಿಮಾ', date: DateTime(2026, 5, 14)),
  ],
  6: <_FestivalStaticEntry>[
    _FestivalStaticEntry(name: 'ಜುಲೈ', date: DateTime(2026, 6, 4)),
  ],
  7: <_FestivalStaticEntry>[
    _FestivalStaticEntry(name: 'ಕ್ರಿಷ್ಣ ಜನ್ಮಾಷ್ಟಮಿ', date: DateTime(2026, 7, 7)),
    _FestivalStaticEntry(name: 'ಯೋಗಿನಿ ಏಕಾದಶಿ', date: DateTime(2026, 7, 10)),
    _FestivalStaticEntry(name: 'ಮಾಸಿಕ ಶಿವರಾತ್ರಿ', date: DateTime(2026, 7, 12)),
    _FestivalStaticEntry(name: 'ಅಶಾಢ ಪೂರ್ಣಿಮಾ', date: DateTime(2026, 7, 12)),
  ],
  8: <_FestivalStaticEntry>[
    _FestivalStaticEntry(name: 'ನಾಗ ಪಂಚಮಿ', date: DateTime(2026, 8, 17)),
    _FestivalStaticEntry(name: 'ತೂಲ್ಸಿದಾಸ್ ಜಯಂತಿ', date: DateTime(2026, 8, 19)),
    _FestivalStaticEntry(name: 'ಊಣಂ', date: DateTime(2026, 8, 26)),
  ],
  9: <_FestivalStaticEntry>[
    _FestivalStaticEntry(name: 'ವಿಜಯದಶಮಿ', date: DateTime(2026, 9, 26)),
  ],
  10: <_FestivalStaticEntry>[
    _FestivalStaticEntry(name: 'ದೀಪಾವಳಿ', date: DateTime(2026, 10, 20)),
  ],
  11: <_FestivalStaticEntry>[
    _FestivalStaticEntry(name: 'ಕ್ರಿಸ್‌ಮಸ್', date: DateTime(2026, 12, 25)),
  ],
  12: <_FestivalStaticEntry>[
    _FestivalStaticEntry(name: 'ಕ್ರಿಸ್‌ಮಸ್', date: DateTime(2026, 12, 25)),
  ],
};

class _NoteHighlightPalette {
  const _NoteHighlightPalette({required this.background, required this.accent});

  final Color background;
  final Color accent;
}

class _AnnotationResult {
  const _AnnotationResult._({this.annotation, required this.shouldClear});

  final DayAnnotation? annotation;
  final bool shouldClear;

  factory _AnnotationResult.save(DayAnnotation annotation) => _AnnotationResult._(annotation: annotation, shouldClear: false);
  factory _AnnotationResult.clear() => const _AnnotationResult._(annotation: null, shouldClear: true);
}

const Map<String, _NoteHighlightPalette> _noteHighlightPalettes = <String, _NoteHighlightPalette>{
  'pink': _NoteHighlightPalette(
    background: Color(0xFF4A0D2C), // deep wine pink background
    accent: Color(0xFFAD1457),     // strong magenta accent
  ),
 'skyblue': _NoteHighlightPalette(
  background: Color(0xFF001F33), // deep navy-teal background (very dark sky blue)
  accent: Color(0xFF0288D1),     // vibrant sky blue accent
),

  'yellow': _NoteHighlightPalette(
    background: Color(0xFF3A3000), // dark golden brown background
    accent: Color(0xFFFFD600),     // vivid golden accent
  ),
  'orange': _NoteHighlightPalette(
    background: Color(0xFF4E1F00), // deep burnt orange background
    accent: Color(0xFFFF6F00),     // bright fire orange accent
  ),
  'brown': _NoteHighlightPalette(
    background: Color(0xFF2B1B12), // espresso brown background
    accent: Color(0xFF795548),     // warm brown accent
  ),
  'purple': _NoteHighlightPalette(
    background: Color(0xFF1A0033), // deep royal violet background
    accent: Color(0xFF7B1FA2),     // vibrant purple accent
  ),
};


const List<String> _annotationEmojis = <String>[
  '🛕',
  '🚗',
  '🚌',
  '❌',
  '✅',
  '🔴',
  '➕',
  '🐄',
  '😀',
  '🚩',
  '🎂',
  '⭐',
  '📍',
  '💍',
  '🎉',
  '🍽️',
  '💼',
];

class _MonthlyFestivalList extends StatelessWidget {
  const _MonthlyFestivalList({required this.entries});

  final List<_MonthlyFestivalEntry> entries;

  @override
  Widget build(BuildContext context) {
    final bool shouldScroll = entries.length > 3;
    final double listHeight = math.min(320, entries.length * 74 + 16);

    if (!shouldScroll) {
      return Column(
        children: entries
            .map<Widget>(
              (_MonthlyFestivalEntry entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MonthlyFestivalListTile(entry: entry),
              ),
            )
            .toList(),
      );
    }

    return SizedBox(
      height: listHeight,
      child: ListView.separated(
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int index) => _MonthlyFestivalListTile(entry: entries[index]),
      ),
    );
  }
}

class _MonthlyFestivalListTile extends StatelessWidget {
  const _MonthlyFestivalListTile({required this.entry});

  final _MonthlyFestivalEntry entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateFormat dateFormat = DateFormat('d MMMM', 'en_US');
    final String dateLabel = entry.dates.isEmpty
        ? ''
        : entry.dates.map((DateTime date) => dateFormat.format(date)).join(', ');

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.16), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            entry.name,
            style: GoogleFonts.notoSansKannada(fontSize: 15.5, fontWeight: FontWeight.w800, color: theme.colorScheme.primary),
          ),
          if (dateLabel.isNotEmpty) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              dateLabel,
              style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ],
        ],
      ),
    );
  }
}

class _MonthlyFestivalEntry {
  _MonthlyFestivalEntry({required this.name, required this.dates});

  final String name;
  final List<DateTime> dates;
}

class _MonthlyPanchangaSection extends StatefulWidget {
  const _MonthlyPanchangaSection({super.key, required this.month, required this.onShowFull});

  final DateTime month;
  final VoidCallback onShowFull;

  @override
  State<_MonthlyPanchangaSection> createState() => _MonthlyPanchangaSectionState();
}

class _MonthlyPanchangaSectionState extends State<_MonthlyPanchangaSection> {
  static const int _initialPage = 1000;

  late final PageController _pageController;
  int _currentPage = _initialPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _monthForPage(int page) {
    final int offset = page - _initialPage;
    return DateTime(widget.month.year, widget.month.month + offset, 1);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateTime activeMonth = _monthForPage(_currentPage);
    final String monthLabel = PanchangaDataUtils.kannadaMonthLabel(activeMonth);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.12), width: 1.1),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x140F172A), blurRadius: 18, offset: Offset(0, 10)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'ಪಂಚಾಂಗ',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKannada(fontSize: 19, fontWeight: FontWeight.w900, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 6),
          Text(
            'ಮಾಸಿಕ ಪಂಚಾಂಗವನ್ನು ನೋಡಲು ಎಡ-ಬಲಕ್ಕೆ ಸ್ವೈಪ್ ಮಾಡಿ',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKannada(fontSize: 13.5, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 460,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) => setState(() => _currentPage = page),
                itemBuilder: (BuildContext context, int index) {
                  final DateTime month = _monthForPage(index);
                  return _PanchangaWebViewPage(month: month);
                },
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              _PanchangaNavButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => _pageController.previousPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$monthLabel ${activeMonth.year}',
                      style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w800, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMMM yyyy').format(activeMonth),
                      style: GoogleFonts.notoSansKannada(fontSize: 12.5, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.65)),
                    ),
                  ],
                ),
              ),
              _PanchangaNavButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => _pageController.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: widget.onShowFull,
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(
                'ಪೂರ್ಣ ಪಂಚಾಂಗ ನೋಡಿ',
                style: GoogleFonts.notoSansKannada(fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PanchangaNavButton extends StatelessWidget {
  const _PanchangaNavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        color: theme.colorScheme.primary,
        onPressed: onTap,
      ),
    );
  }
}

class _PanchangaWebViewPage extends StatefulWidget {
  const _PanchangaWebViewPage({required this.month});

  final DateTime month;

  @override
  State<_PanchangaWebViewPage> createState() => _PanchangaWebViewPageState();
}

class _PanchangaWebViewPageState extends State<_PanchangaWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF8FAFC))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (_) => setState(() => _isLoading = false),
        ),
      );
    _loadMonth(widget.month);
  }

  @override
  void didUpdateWidget(covariant _PanchangaWebViewPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.month.year != widget.month.year || oldWidget.month.month != widget.month.month) {
      _loadMonth(widget.month);
    }
  }

  void _loadMonth(DateTime month) {
    final String formattedMonth = month.month.toString().padLeft(2, '0');
    final String imageUrl = 'https://kannadacalendar.in/wp-content/kannada/panchanga/${month.year}/$formattedMonth-${month.year}.jpg';
    final String html = '''
<!DOCTYPE html><html lang="kn"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><style>html,body{margin:0;padding:0;background:#f8fafc;}img{display:block;width:100%;height:auto;}</style></head><body><img src="$imageUrl" alt="Panchanga" /></body></html>
''';
    _controller.loadHtmlString(html);
    setState(() => _isLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

class _MantraTabContent extends StatelessWidget {
  const _MantraTabContent();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFFFF7E6), Color(0xFFFFF1D0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        itemCount: PanchangaDataUtils.mantras.length,
        separatorBuilder: (_, __) => const SizedBox(height: 18),
        itemBuilder: (BuildContext context, int index) {
          final mantra = PanchangaDataUtils.mantras[index];
          if (mantra.title == 'ಶ್ರೀ ಗಾಯತ್ರಿ ಮಂತ್ರ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFFF7AE), Color(0xFFFFD166), Color(0xFFF97316)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFFFE082), width: 1.4),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x66FBBF24), blurRadius: 40, spreadRadius: 10, offset: Offset(0, 18)),
                    BoxShadow(color: Color(0x33EA580C), blurRadius: 24, offset: Offset(0, 12)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3B0).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(color: Color(0x4DFBBF24), blurRadius: 18, offset: Offset(0, 8)),
                          ],
                        ),
                        child: Text(
                          'ॐ',
                          style: GoogleFonts.notoSansKannada(fontSize: 28, fontWeight: FontWeight.w800, color: const Color(0xFFC08401), letterSpacing: 4),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        mantra.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFFB91C1C)),
                      ),
                      const SizedBox(height: 20),
                      ...mantra.lines.map(
                        (String line) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            line,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              height: 1.45,
                              color: const Color(0xFF7C2D12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ಪದ್ಮಾವತಿ ಸ್ತೋತ್ರ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFFF7FB), Color(0xFFFCE7F3), Color(0xFFFBCFE8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFF9A8D4), width: 1.2),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x66F472B6), blurRadius: 30, spreadRadius: 8, offset: Offset(0, 18)),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[Colors.white.withValues(alpha: 0.8), Colors.transparent],
                            radius: 0.82,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: <Color>[Color(0xFFF472B6), Color(0xFFFDA4AF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(color: Color(0x33F472B6), blurRadius: 16, offset: Offset(0, 8)),
                              ],
                            ),
                            child: Text(
                              '🌸',
                              style: GoogleFonts.notoSansKannada(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 3),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mantra.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFFBE185D)),
                          ),
                          const SizedBox(height: 18),
                          ...mantra.lines.map(
                            (String line) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                line,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansKannada(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  height: 1.5,
                                  color: const Color(0xFFF472B6),
                                  shadows: const <Shadow>[
                                    Shadow(color: Color(0x66FFFFFF), blurRadius: 8, offset: Offset(0, 2)),
                                    Shadow(color: Color(0x33BE185D), blurRadius: 12, offset: Offset(0, 4)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ಶನೇಶ್ವರ ಸ್ತೋತ್ರ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 28,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF0B1120), Color(0xFF111F4A), Color(0xFF1E3A8A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFF93C5FD).withValues(alpha: 0.35), width: 1.2),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x661E3A8A), blurRadius: 32, spreadRadius: 6, offset: Offset(0, 18)),
                    BoxShadow(color: Color(0x4D0B1120), blurRadius: 18, offset: Offset(0, 8)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: <Color>[Color(0xFFFACC15), Color(0xFFFCD34D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(color: Color(0x4DFACC15), blurRadius: 16, offset: Offset(0, 8)),
                          ],
                        ),
                        child: Text(
                          '♄',
                          style: GoogleFonts.notoSansKannada(fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF1E293B), letterSpacing: 3),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mantra.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSansKannada(fontSize: 21, fontWeight: FontWeight.w900, color: const Color(0xFFBFDBFE)),
                      ),
                      const SizedBox(height: 18),
                      ...mantra.lines.map(
                        (String line) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            line,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.5,
                              color: const Color(0xFFDBEAFE),
                              shadows: const <Shadow>[
                                Shadow(color: Color(0x661E3A8A), blurRadius: 8, offset: Offset(0, 2)),
                                Shadow(color: Color(0x661E293B), blurRadius: 14, offset: Offset(0, 4)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ದುರ್ಗಾ ಸ್ತೋತ್ರ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFFFBEB), Color(0xFFFFE08A), Color(0xFFFFA94D)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFFFE5A5), width: 1.3),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x66FDBA74), blurRadius: 34, spreadRadius: 8, offset: Offset(0, 20)),
                    BoxShadow(color: Color(0x33EA580C), blurRadius: 20, offset: Offset(0, 10)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: <Color>[Color(0xFFFACC15), Color(0xFFF59E0B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(color: Color(0x4DF59E0B), blurRadius: 18, offset: Offset(0, 8)),
                          ],
                        ),
                        child: Text(
                          '🔱',
                          style: GoogleFonts.notoSansKannada(fontSize: 28, fontWeight: FontWeight.w800, color: const Color(0xFF7C2D12), letterSpacing: 3),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mantra.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSansKannada(fontSize: 21, fontWeight: FontWeight.w900, color: const Color(0xFFB45309)),
                      ),
                      const SizedBox(height: 18),
                      ...mantra.lines.map(
                        (String line) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            line,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.5,
                              color: const Color(0xFF7C2D12),
                              shadows: const <Shadow>[
                                Shadow(color: Color(0x66EA580C), blurRadius: 8, offset: Offset(0, 2)),
                                Shadow(color: Color(0x4DF97316), blurRadius: 14, offset: Offset(0, 4)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ಚೌಡೇಶ್ವರಿ ಸ್ತೋತ್ರ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 28,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF022C22), Color(0xFF064E3B), Color(0xFF14532D)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFBBF7D0).withValues(alpha: 0.4), width: 1.2),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x6614522D), blurRadius: 32, spreadRadius: 6, offset: Offset(0, 18)),
                    BoxShadow(color: Color(0x3314522D), blurRadius: 18, offset: Offset(0, 8)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: <Color>[Color(0xFFEAB308), Color(0xFFFACC15)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(color: Color(0x4DEAB308), blurRadius: 16, offset: Offset(0, 8)),
                          ],
                        ),
                        child: Text(
                          '🔱',
                          style: GoogleFonts.notoSansKannada(fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF1F2937), letterSpacing: 3),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mantra.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSansKannada(fontSize: 21, fontWeight: FontWeight.w900, color: const Color(0xFFD1FAE5)),
                      ),
                      const SizedBox(height: 18),
                      ...mantra.lines.map(
                        (String line) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            line,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              height: 1.5,
                              color: const Color(0xFFC3F0C9),
                              shadows: const <Shadow>[
                                Shadow(color: Color(0x66FACC15), blurRadius: 10, offset: Offset(0, 3)),
                                Shadow(color: Color(0x6614522D), blurRadius: 14, offset: Offset(0, 4)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ಗುರು ರಾಘವೇಂದ್ರ ಸ್ವಾಮಿ ಪ್ರಾರ್ಥನೆ') {
            return GlassCard(
              padding: const EdgeInsets.all(26),
              borderRadius: 32,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFFF8E7), Color(0xFFFFE1A6), Color(0xFFF97316)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFFFFF0C2), width: 1.4),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x66FDBA74), blurRadius: 38, spreadRadius: 10, offset: Offset(0, 22)),
                    BoxShadow(color: Color(0x33EA580C), blurRadius: 24, offset: Offset(0, 12)),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[const Color(0xFFFFF4D6).withValues(alpha: 0.85), Colors.transparent],
                            radius: 0.8,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 36),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              gradient: const LinearGradient(
                                colors: <Color>[Color(0xFFFACC15), Color(0xFFFBBF24)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(color: Color(0x4DF59E0B), blurRadius: 20, offset: Offset(0, 10)),
                              ],
                            ),
                            child: Text(
                              '🕉️',
                              style: GoogleFonts.notoSansKannada(fontSize: 30, fontWeight: FontWeight.w800, color: const Color(0xFF7C2D12), letterSpacing: 4),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            mantra.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF9A3412)),
                          ),
                          const SizedBox(height: 20),
                          ...mantra.lines.map(
                            (String line) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                line,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansKannada(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  height: 1.5,
                                  color: const Color(0xFF7C2D12),
                                  shadows: const <Shadow>[
                                    Shadow(color: Color(0x66F59E0B), blurRadius: 8, offset: Offset(0, 2)),
                                    Shadow(color: Color(0x4DEA580C), blurRadius: 14, offset: Offset(0, 4)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ಸೂರ್ಯ ನಾರಾಯಣ ಪ್ರಾರ್ಥನೆ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFFFBCC), Color(0xFFFFD166), Color(0xFFF97316), Color(0xFFDC2626)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFFFECB3), width: 1.3),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x66FBBF24), blurRadius: 36, spreadRadius: 9, offset: Offset(0, 20)),
                    BoxShadow(color: Color(0x33DC2626), blurRadius: 18, offset: Offset(0, 10)),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[const Color(0xFFFFF3B0).withValues(alpha: 0.85), Colors.transparent],
                            radius: 0.85,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 34),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: <Color>[Color(0xFFFACC15), Color(0xFFF97316)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(color: Color(0x4DFACC15), blurRadius: 18, offset: Offset(0, 9)),
                              ],
                            ),
                            child: Text(
                              '☀',
                              style: GoogleFonts.notoSansKannada(fontSize: 30, fontWeight: FontWeight.w800, color: const Color(0xFF7C2D12), letterSpacing: 4),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mantra.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFFB91C1C)),
                          ),
                          const SizedBox(height: 18),
                          ...mantra.lines.map(
                            (String line) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                line,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansKannada(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  height: 1.5,
                                  color: const Color(0xFF7C2D12),
                                  shadows: const <Shadow>[
                                    Shadow(color: Color(0x66F97316), blurRadius: 8, offset: Offset(0, 2)),
                                    Shadow(color: Color(0x4DDB2777), blurRadius: 14, offset: Offset(0, 4)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ಗಣೇಶ ಮಂತ್ರ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFFF1F2), Color(0xFFFECACA), Color(0xFFE11D48)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFFFCDD2), width: 1.3),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x66E11D48), blurRadius: 32, spreadRadius: 8, offset: Offset(0, 18)),
                    BoxShadow(color: Color(0x33F97316), blurRadius: 20, offset: Offset(0, 10)),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[const Color(0xFFFFEBF0).withValues(alpha: 0.85), Colors.transparent],
                            radius: 0.8,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: <Color>[Color(0xFFF97316), Color(0xFFE11D48)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(color: Color(0x4DE11D48), blurRadius: 18, offset: Offset(0, 8)),
                              ],
                            ),
                            child: Text(
                              '🐘',
                              style: GoogleFonts.notoSansKannada(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 3),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mantra.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFFB91C1C)),
                          ),
                          const SizedBox(height: 18),
                          ...mantra.lines.map(
                            (String line) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                line,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansKannada(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  height: 1.5,
                                  color: Colors.white,
                                  shadows: const <Shadow>[
                                    Shadow(color: Color(0x66E11D48), blurRadius: 8, offset: Offset(0, 2)),
                                    Shadow(color: Color(0x4DF97316), blurRadius: 14, offset: Offset(0, 4)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ಹನುಮಾನ್ ಚಾಲಿಸಾ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFFFBEB), Color(0xFFFFE08A), Color(0xFFF97316)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFFCD34D), width: 1.3),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x66F97316), blurRadius: 32, spreadRadius: 8, offset: Offset(0, 18)),
                    BoxShadow(color: Color(0x33FACC15), blurRadius: 18, offset: Offset(0, 10)),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[const Color(0xFFFFF0C2).withValues(alpha: 0.85), Colors.transparent],
                            radius: 0.8,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: <Color>[Color(0xFFFACC15), Color(0xFFF97316)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(color: Color(0x4DF97316), blurRadius: 18, offset: Offset(0, 8)),
                              ],
                            ),
                            child: Text(
                              '🪔',
                              style: GoogleFonts.notoSansKannada(fontSize: 28, fontWeight: FontWeight.w800, color: const Color(0xFF7C2D12), letterSpacing: 3),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mantra.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFFB45309)),
                          ),
                          const SizedBox(height: 18),
                          ...mantra.lines.map(
                            (String line) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                line,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansKannada(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  height: 1.5,
                                  color: const Color(0xFF7C2D12),
                                  shadows: const <Shadow>[
                                    Shadow(color: Color(0x66FACC15), blurRadius: 8, offset: Offset(0, 2)),
                                    Shadow(color: Color(0x4DF97316), blurRadius: 14, offset: Offset(0, 4)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ಲಕ್ಷ್ಮೀ ಮಂತ್ರ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFFFBF0), Color(0xFFFED7AA), Color(0xFFFACC15)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFFDE68A), width: 1.3),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x66FACC15), blurRadius: 32, spreadRadius: 8, offset: Offset(0, 18)),
                    BoxShadow(color: Color(0x33FB923C), blurRadius: 20, offset: Offset(0, 10)),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[const Color(0xFFFFF4CE).withValues(alpha: 0.85), Colors.transparent],
                            radius: 0.8,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: <Color>[Color(0xFFFACC15), Color(0xFFFB923C)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(color: Color(0x4DFB923C), blurRadius: 18, offset: Offset(0, 8)),
                              ],
                            ),
                            child: Text(
                              '🌸',
                              style: GoogleFonts.notoSansKannada(fontSize: 28, fontWeight: FontWeight.w800, color: const Color(0xFF7C2D12), letterSpacing: 3),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mantra.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFFB45309)),
                          ),
                          const SizedBox(height: 18),
                          ...mantra.lines.map(
                            (String line) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                line,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansKannada(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  height: 1.5,
                                  color: const Color(0xFF7C2D12),
                                  shadows: const <Shadow>[
                                    Shadow(color: Color(0x66FACC15), blurRadius: 8, offset: Offset(0, 2)),
                                    Shadow(color: Color(0x4DFB923C), blurRadius: 14, offset: Offset(0, 4)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ಶಿವ ಮಂತ್ರ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFF5F3FF), Color(0xFFE0E7FF), Color(0xFF7C3AED)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFC7D2FE), width: 1.3),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x667C3AED), blurRadius: 32, spreadRadius: 8, offset: Offset(0, 18)),
                    BoxShadow(color: Color(0x3338BDF8), blurRadius: 20, offset: Offset(0, 10)),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[Colors.white.withValues(alpha: 0.9), Colors.transparent],
                            radius: 0.82,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: <Color>[Color(0xFF38BDF8), Color(0xFF7C3AED)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(color: Color(0x4D38BDF8), blurRadius: 18, offset: Offset(0, 8)),
                              ],
                            ),
                            child: Text(
                              '🔱',
                              style: GoogleFonts.notoSansKannada(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 3),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mantra.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF312E81)),
                          ),
                          const SizedBox(height: 18),
                          ...mantra.lines.map(
                            (String line) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                line,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansKannada(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  height: 1.5,
                                  color: const Color(0xFF1E3A8A),
                                  shadows: const <Shadow>[
                                    Shadow(color: Color(0x66FFFFFF), blurRadius: 10, offset: Offset(0, 3)),
                                    Shadow(color: Color(0x4D38BDF8), blurRadius: 14, offset: Offset(0, 4)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ಸರಸ್ವತಿ ಸ್ತೋತ್ರ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFFFFFF), Color(0xFFF8FAFC), Color(0xFFE5E7EB)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x33576382), blurRadius: 28, spreadRadius: 6, offset: Offset(0, 16)),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[Colors.white.withValues(alpha: 0.92), Colors.transparent],
                            radius: 0.78,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: <Color>[Color(0xFFF9FAFB), Color(0xFFD1D5DB)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(color: Color(0x33CBD5F5), blurRadius: 14, offset: Offset(0, 6)),
                              ],
                            ),
                            child: Text(
                              '🎶',
                              style: GoogleFonts.notoSansKannada(fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF1E293B), letterSpacing: 3),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mantra.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF1E3A8A)),
                          ),
                          const SizedBox(height: 18),
                          ...mantra.lines.map(
                            (String line) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                line,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansKannada(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  height: 1.5,
                                  color: const Color(0xFF0F172A),
                                  shadows: const <Shadow>[
                                    Shadow(color: Color(0x55FFFFFF), blurRadius: 8, offset: Offset(0, 2)),
                                    Shadow(color: Color(0x332563EB), blurRadius: 12, offset: Offset(0, 4)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ಸಾಯಿಬಾಬಾ ಸ್ತೋತ್ರ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF111827), Color(0xFF1F2937), Color(0xFF312E81)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFF4C1D95).withValues(alpha: 0.35), width: 1.2),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x4D312E81), blurRadius: 30, spreadRadius: 8, offset: Offset(0, 18)),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[Colors.white.withValues(alpha: 0.12), Colors.transparent],
                            radius: 0.75,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: <Color>[Color(0xFFEAB308), Color(0xFFFACC15)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(color: Color(0x33FACC15), blurRadius: 16, offset: Offset(0, 8)),
                              ],
                            ),
                            child: Text(
                              '🕉️',
                              style: GoogleFonts.notoSansKannada(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 3),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mantra.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white.withValues(alpha: 0.9)),
                          ),
                          const SizedBox(height: 18),
                          ...mantra.lines.map(
                            (String line) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                line,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansKannada(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  height: 1.5,
                                  color: Colors.white,
                                  shadows: const <Shadow>[
                                    Shadow(color: Color(0x55FFFFFF), blurRadius: 10, offset: Offset(0, 3)),
                                    Shadow(color: Color(0x33312E81), blurRadius: 16, offset: Offset(0, 5)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (mantra.title == 'ಶ್ರೀ ವಿಷ್ಣು ಸ್ತೋತ್ರ') {
            return GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFF0F9FF), Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFBFDBFE), width: 1.2),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x4D38BDF8), blurRadius: 28, spreadRadius: 6, offset: Offset(0, 18)),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: <Color>[Colors.white.withValues(alpha: 0.75), Colors.transparent],
                            radius: 0.82,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: <Color>[Color(0xFF38BDF8), Color(0xFF0EA5E9)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(color: Color(0x3338BDF8), blurRadius: 14, offset: Offset(0, 6)),
                              ],
                            ),
                            child: Text(
                              '🌀',
                              style: GoogleFonts.notoSansKannada(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 3),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mantra.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKannada(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF1D4ED8)),
                          ),
                          const SizedBox(height: 18),
                          ...mantra.lines.map(
                            (String line) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                line,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.notoSansKannada(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  height: 1.5,
                                  color: const Color(0xFF38BDF8),
                                  shadows: const <Shadow>[
                                    Shadow(color: Color(0x66FFFFFF), blurRadius: 8, offset: Offset(0, 2)),
                                    Shadow(color: Color(0x332563EB), blurRadius: 12, offset: Offset(0, 4)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return GlassCard(
            padding: const EdgeInsets.all(20),
            borderRadius: 24,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[mantra.primaryColor, mantra.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: mantra.primaryColor.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      mantra.title,
                      style: GoogleFonts.notoSansKannada(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    ...mantra.lines.map(
                      (String line) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          line,
                          style: GoogleFonts.notoSansKannada(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FestivalsContent extends StatelessWidget {
  const _FestivalsContent({required this.year, required this.onDayTap});

  final int year;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ReminderProvider reminderProvider = Provider.of<ReminderProvider>(context);
    final List<_FestivalEntry> festivalEntries = _buildFestivalEntries(year);
    final List<Reminder> reminders = reminderProvider.upcomingReminders;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFE0F2FE), Color(0xFFDBEAFE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'ಉತ್ಸವಗಳ ಸೂಚಿ',
                      style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w800, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final _FestivalEntry entry = festivalEntries[index];
                    final bool isLast = index == festivalEntries.length - 1;
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                      child: GestureDetector(
                        onTap: () => onDayTap(entry.date),
                        child: GlassCard(
                          borderRadius: 24,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    entry.formattedDate,
                                    style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w800, color: theme.colorScheme.primary),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      const Icon(Icons.event_available_rounded, size: 18, color: Color(0xFF1D4ED8)),
                                      const SizedBox(width: 6),
                                      Text(
                                        DateFormat.MMMd('kn_IN').format(entry.date),
                                        style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface.withValues(alpha: 0.65)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ...entry.festivals.map(
                                (String festival) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: <Widget>[
                                      const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF59E0B)),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          festival,
                                          style: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: festivalEntries.length,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'ಸ್ಮರಣಿಕೆಗಳು',
                      style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w800, color: theme.colorScheme.secondary),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openReminderSheet(context, reminderProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F4AA3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        textStyle: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w700),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('ಹೊಸ ರಿಮೈಂಡರ್'),
                    ),
                  ],
                ),
              ),
            ),
            if (reminders.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: GlassCard(
                    borderRadius: 24,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.alarm_on_rounded, size: 48, color: Color(0xFF1D4ED8)),
                        const SizedBox(height: 12),
                        Text(
                          'ರವಿಭಕ್ತಿ ಸ್ಮರಣಿಕೆ ಇಲ್ಲ',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface.withValues(alpha: 0.8)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ಉತ್ಸವ ಅಥವಾ ವೈಯಕ್ತಿಕ ದಿನಗಳನ್ನು ಇಲ್ಲಿ ಸೇರಿಸಿ ಮತ್ತು ಸಮಯಕ್ಕೆ ಸೂಚನೆ ಪಡೆಯಿರಿ.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSansKannada(fontSize: 13.5, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final Reminder reminder = reminders[index];
                      final bool isLast = index == reminders.length - 1;
                      return Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                        child: _ReminderCard(reminder: reminder, provider: reminderProvider),
                      );
                    },
                    childCount: reminders.length,
                  ),
                ),
              ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
          ],
        ),
      ),
    );
  }

  static List<_FestivalEntry> _buildFestivalEntries(int year) {
    final DateTime start = DateTime(year, 1, 1);
    final DateTime end = DateTime(year, 12, 31);
    final List<_FestivalEntry> entries = <_FestivalEntry>[];
    for (DateTime current = start; !current.isAfter(end); current = current.add(const Duration(days: 1))) {
      final List<String> festivals = PanchangaDataUtils.festivalsFor(current);
      if (festivals.isEmpty) {
        continue;
      }
      entries.add(
        _FestivalEntry(
          date: current,
          festivals: festivals,
          formattedDate: DateFormat('EEEE, d MMMM', 'kn_IN').format(current),
        ),
      );
    }
    return entries;
  }

  static Future<void> _openReminderSheet(BuildContext context, ReminderProvider provider, {Reminder? editing}) async {
    final ThemeData theme = Theme.of(context);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String title = editing?.title ?? '';
    DateTime date = editing?.date ?? DateTime.now();
    TimeOfDay? time = editing?.timeOfDay;
    ReminderRepeat repeat = editing?.repeat ?? ReminderRepeat.none;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: GlassCard(
                borderRadius: 28,
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 60,
                          height: 6,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        editing == null ? 'ಹೊಸ ಸ್ಮರಣಿಕೆ' : 'ಸ್ಮರಣಿಕೆ ಸಂಪಾದನೆ',
                        style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w800, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: title,
                        decoration: const InputDecoration(
                          labelText: 'ಗಮನಿಸುವ ದಿನದ ಹೆಸರು',
                        ),
                        style: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w600),
                        validator: (String? value) => value == null || value.trim().isEmpty ? 'ಶೀರ್ಷಿಕೆ ಅಗತ್ಯ' : null,
                        onSaved: (String? value) => title = value!.trim(),
                      ),
                      const SizedBox(height: 16),
                      _DateSelector(
                        date: date,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                            locale: const Locale('kn', 'IN'),
                          );
                          if (picked != null) {
                            setModalState(() {
                              date = picked;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _TimeSelector(
                        time: time,
                        onPick: () async {
                          final TimeOfDay initial = time ?? TimeOfDay(hour: 8, minute: 0);
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: initial,
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                                child: child ?? const SizedBox.shrink(),
                              );
                            },
                          );
                          setModalState(() {
                            time = picked;
                          });
                        },
                        onClear: () => setModalState(() {
                          time = null;
                        }),
                      ),
                      const SizedBox(height: 16),
                      _RepeatSelector(
                        repeat: repeat,
                        onChanged: (ReminderRepeat value) {
                          setModalState(() {
                            repeat = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  formKey.currentState?.save();
                                  Navigator.of(context).pop(<dynamic>[title, date, time, repeat]);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF166534),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                textStyle: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w700),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              ),
                              child: Text(editing == null ? 'ಸೇರಿಸಿ' : 'ನವೀಕರಿಸಿ'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.4)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                textStyle: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w700),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              ),
                              child: const Text('ರದ್ದು'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((dynamic result) async {
      if (result is List<dynamic> && result.length == 4) {
        final String newTitle = result[0] as String;
        final DateTime newDate = result[1] as DateTime;
        final TimeOfDay? newTime = result[2] as TimeOfDay?;
        final ReminderRepeat newRepeat = result[3] as ReminderRepeat;
        if (editing == null) {
          await provider.addReminder(title: newTitle, date: newDate, time: newTime, repeat: newRepeat);
        } else {
          await provider.updateReminder(editing, title: newTitle, date: newDate, time: newTime, repeat: newRepeat);
        }
      }
    });
  }

}

class _FestivalEntry {
  const _FestivalEntry({required this.date, required this.festivals, required this.formattedDate});

  final DateTime date;
  final List<String> festivals;
  final String formattedDate;
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({required this.reminder, required this.provider});

  final Reminder reminder;
  final ReminderProvider provider;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateFormat dateFormatter = DateFormat('d MMMM yyyy, EEEE', 'kn_IN');
    final TimeOfDay? time = reminder.timeOfDay;
    final String timeLabel = time == null
        ? 'ಸಮಯ ನಿರ್ಧರಿಸಲಾಗಿಲ್ಲ'
        : DateFormat('hh:mm a').format(DateTime(0).add(Duration(hours: time.hour, minutes: time.minute)));
    final String repeatLabel = _repeatLabel(reminder.repeat);

    return GlassCard(
      borderRadius: 22,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: <Color>[Color(0xFFFBCFE8), Color(0xFFF472B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.alarm_rounded, color: Color(0xFF831843)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      reminder.title,
                      style: GoogleFonts.notoSansKannada(fontSize: 16.5, fontWeight: FontWeight.w800, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormatter.format(reminder.date),
                      style: GoogleFonts.notoSansKannada(fontSize: 13.5, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'ತಿದ್ದು',
                onPressed: () => _FestivalsContent._openReminderSheet(context, provider, editing: reminder),
                icon: const Icon(Icons.edit_rounded, color: Color(0xFF0F4AA3)),
              ),
              IconButton(
                tooltip: 'ಅಳಿಸಿ',
                onPressed: () => _confirmDelete(context),
                icon: const Icon(Icons.delete_rounded, color: Color(0xFFB91C1C)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              const Icon(Icons.schedule_rounded, size: 18, color: Color(0xFF1E3A8A)),
              const SizedBox(width: 8),
              Text(
                timeLabel,
                style: GoogleFonts.notoSansKannada(fontSize: 13.5, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              const Icon(Icons.repeat_rounded, size: 18, color: Color(0xFF831843)),
              const SizedBox(width: 8),
              Text(
                repeatLabel,
                style: GoogleFonts.notoSansKannada(fontSize: 13.5, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('ಸ್ಮರಣಿಕೆ ಅಳಿಸಬೇಕೇ?', style: GoogleFonts.notoSansKannada(fontWeight: FontWeight.w800)),
        content: Text('"${reminder.title}" ಸ್ಮರಣಿಕೆಯನ್ನು ಅಳಿಸುವಿರಾ?', style: GoogleFonts.notoSansKannada(fontWeight: FontWeight.w600)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('ರದ್ದು', style: GoogleFonts.notoSansKannada(fontWeight: FontWeight.w700)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('ಅಳಿಸಿ', style: GoogleFonts.notoSansKannada(fontWeight: FontWeight.w700, color: const Color(0xFFB91C1C))),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await provider.deleteReminder(reminder);
    }
  }

  String _repeatLabel(ReminderRepeat repeat) {
    switch (repeat) {
      case ReminderRepeat.none:
        return 'ಎಲ್ಲಾ ಬಾರಿ ಮಾತ್ರ';
      case ReminderRepeat.daily:
        return 'ಪ್ರತಿ ದಿನ';
      case ReminderRepeat.weekly:
        return 'ವಾರಕ್ಕೊಮ್ಮೆ';
      case ReminderRepeat.yearly:
        return 'ಪ್ರತಿ ವರ್ಷ';
    }
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateFormat formatter = DateFormat('d MMMM yyyy, EEEE', 'kn_IN');
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: <Widget>[
            const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF1D4ED8)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                formatter.format(date),
                style: GoogleFonts.notoSansKannada(fontSize: 14.5, fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              'ಬದಲಿಸಿ',
              style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w700, color: theme.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeSelector extends StatelessWidget {
  const _TimeSelector({required this.time, required this.onPick, required this.onClear});

  final TimeOfDay? time;
  final Future<void> Function() onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String label = time == null
        ? 'ಸಮಯವನ್ನು ಸೇರಿಸಿ (ಐಚ್ಛಿಕ)'
        : '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}';
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onPick,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F4AA3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w700),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            icon: const Icon(Icons.access_time_rounded, size: 18),
            label: Text(label),
          ),
        ),
        const SizedBox(width: 12),
        if (time != null)
          OutlinedButton(
            onPressed: onClear,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.4)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w700),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: const Text('ತೆಗೆದುಹಾಕಿ'),
          ),
      ],
    );
  }
}

class _RepeatSelector extends StatelessWidget {
  const _RepeatSelector({required this.repeat, required this.onChanged});

  final ReminderRepeat repeat;
  final ValueChanged<ReminderRepeat> onChanged;

  @override
  Widget build(BuildContext context) {
    final Map<ReminderRepeat, String> labels = <ReminderRepeat, String>{
      ReminderRepeat.none: 'ಒಮ್ಮೆ',
      ReminderRepeat.daily: 'ಪ್ರತಿ ದಿನ',
      ReminderRepeat.weekly: 'ವಾರದಂತೆ',
      ReminderRepeat.yearly: 'ವಾರ್ಷಿಕ',
    };
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: labels.entries.map(
        (MapEntry<ReminderRepeat, String> entry) {
          final bool selected = repeat == entry.key;
          return ChoiceChip(
            label: Text(entry.value, style: GoogleFonts.notoSansKannada(fontWeight: FontWeight.w700)),
            selected: selected,
            onSelected: (_) => onChanged(entry.key),
            selectedColor: const Color(0xFFF472B6),
            backgroundColor: const Color(0xFFFCE7F3),
            labelStyle: GoogleFonts.notoSansKannada(
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xFF831843),
            ),
          );
        },
      ).toList(),
    );
  }
}

enum _HomeSection { daily, monthly, mantra, festivals }

enum _DailyNavAction { yesterday, today, tomorrow }

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late List<DateTime> _months;
  late DateTime _dailyMonth;
  late DateTime _monthlyMonth;
  late PageController _pageController;
  bool _yesterdayLabelUpdated = false;
  bool _tomorrowLabelUpdated = false;
  bool _isDayTransitioning = false;
  _DailyNavAction? _activeNavAction;
  int _navIndex = 0;
  _HomeSection _section = _HomeSection.daily;
  late Timer _clockTimer;
  late DateTime _headerDateTime;
  late DateTime _calendarDate;
  bool _drawerOpen = false;

  @override
  void initState() {
    super.initState();
    final AppState state = Provider.of<AppState>(context, listen: false);
    final DateTime selectedDay = state.selectedDay;
    _months = _generateMonthsForMultipleYears(selectedDay.year);
    _dailyMonth = DateTime(selectedDay.year, selectedDay.month, 1);
    _monthlyMonth = DateTime(selectedDay.year, selectedDay.month, 1);
    _tabController = TabController(length: _months.length, vsync: this, initialIndex: _calculateInitialTabIndex(selectedDay));
    _tabController.addListener(_handleTabChange);
    _pageController = PageController(initialPage: _section.index);
    _headerDateTime = DateTime.now();
    _calendarDate = DateUtils.dateOnly(DateTime.now());
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (Timer _) {
      setState(() {
        _headerDateTime = DateTime.now();
      });
    });
  }

  static List<DateTime> _generateMonthsForMultipleYears(int centerYear) {
    // Generate months for 3 years: centerYear-1, centerYear, centerYear+1
    // This gives us 36 months total (12 months × 3 years)
    final List<DateTime> months = <DateTime>[];

    for (int year = centerYear - 1; year <= centerYear + 1; year++) {
      for (int month = 1; month <= 12; month++) {
        months.add(DateTime(year, month, 1));
      }
    }

    return months;
  }

  int _calculateInitialTabIndex(DateTime selectedDay) {
    // Calculate the correct tab index for the selected month in the multi-year list
    // The list is organized as: [year-1 months] + [current year months] + [year+1 months]
    final int centerYear = selectedDay.year;
    final int targetYear = selectedDay.year;
    final int targetMonth = selectedDay.month;

    // Calculate offset: (targetYear - (centerYear - 1)) * 12 + (targetMonth - 1)
    final int yearOffset = (targetYear - (centerYear - 1)) * 12;
    final int monthOffset = targetMonth - 1;

    return yearOffset + monthOffset;
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      return;
    }
    setState(() {
      _monthlyMonth = _months[_tabController.index];
    });
  }

  void _loadCalendar(DateTime date) {
    setState(() {
      _calendarDate = DateUtils.dateOnly(date);
      _dailyMonth = DateTime(_calendarDate.year, _calendarDate.month, 1);
      _section = _HomeSection.daily;
      _navIndex = _section.index;
      _pageController.jumpToPage(_section.index);
    });
  }

  void _openWebPanchanga() {
    final DateTime month = _monthlyMonth;
    Navigator.of(context).push(
      MaterialPageRoute<PanchangaImageScreen>(
        builder: (_) => PanchangaImageScreen(month: month.month, year: month.year),
      ),
    );
  }

  void _openMonthlyPanchanga(BuildContext context, DateTime month) {
    final ThemeData theme = Theme.of(context);
    final List<PanchangaDay> days = PanchangaDataUtils.daysForMonth(month);
    final String title = '${PanchangaDataUtils.kannadaMonthLabel(month)} ${month.year}';

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final double maxHeight = MediaQuery.of(context).size.height * 0.7;
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 16,
          ),
          child: GlassCard(
            borderRadius: 28,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 60,
                    height: 6,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'ಪಂಚಾಂಗ • $title',
                  style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w800, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: days.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final PanchangaDay day = days[index];
                      final List<String> festivals = day.festivals ?? <String>[];
                      return GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        borderRadius: 26,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                final bool hasFestivals = festivals.isNotEmpty;
                                return ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: Icon(Icons.event, color: theme.colorScheme.primary),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              DateFormat('EEEE, d MMMM', 'kn_IN').format(day.date),
                                              style: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              DateFormat('d MMM yyyy').format(day.date),
                                              style: GoogleFonts.notoSansKannada(fontSize: 12.5, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.65)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (hasFestivals)
                                        Flexible(
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: theme.colorScheme.secondary.withValues(alpha: 0.12),
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              child: Text(
                                                '${festivals.length}+ ಉತ್ಸವಗಳು',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.notoSansKannada(fontSize: 12.5, fontWeight: FontWeight.w700, color: theme.colorScheme.secondary),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'ತಿಥಿ: ${day.tithi}',
                              style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.82)),
                            ),
                            Text(
                              'ನಕ್ಷತ್ರ: ${day.nakshatra}',
                              style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.82)),
                            ),
                            Text(
                              'ಯೋಗ: ${day.yoga}',
                              style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.82)),
                            ),
                            Text(
                              'ಪಕ್ಷ: ${day.paksha}',
                              style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.82)),
                            ),
                            const SizedBox(height: 12),
                            if (festivals.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: festivals
                                    .map(
                                      (String fest) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              theme.colorScheme.primary.withValues(alpha: 0.12),
                                              theme.colorScheme.surfaceVariant.withValues(alpha: 0.05),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.25), width: 1),
                                        ),
                                        child: Text(
                                          fest,
                                          style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            else
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.26),
                                ),
                                child: Text(
                                  'ಈ ದಿನಕ್ಕೆ ವಿಶೇಷ ಉತ್ಸವಗಳಿಲ್ಲ',
                                  style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _loadYesterdayCalendar() {
    if (_isDayTransitioning) {
      return;
    }
    setState(() {
      if (!_yesterdayLabelUpdated) {
        _yesterdayLabelUpdated = true;
      }
      _isDayTransitioning = true;
      _activeNavAction = _DailyNavAction.yesterday;
    });
    Future<void>.microtask(() {
      final DateTime target = _calendarDate.subtract(const Duration(days: 1));
      final AppState state = Provider.of<AppState>(context, listen: false);
      state.onDaySelected(target, DateTime(target.year, target.month, 1));
      _loadCalendar(target);
      if (!mounted) {
        return;
      }
      setState(() {
        _isDayTransitioning = false;
        _activeNavAction = null;
      });
    });
  }

  void _loadTodayCalendar() {
    if (_isDayTransitioning) {
      return;
    }
    setState(() {
      _isDayTransitioning = true;
      _activeNavAction = _DailyNavAction.today;
    });
    Future<void>.microtask(() {
      final DateTime target = DateUtils.dateOnly(DateTime.now());
      final AppState state = Provider.of<AppState>(context, listen: false);
      state.onDaySelected(target, DateTime(target.year, target.month, 1));
      _loadCalendar(target);
      if (!mounted) {
        return;
      }
      setState(() {
        _isDayTransitioning = false;
        _activeNavAction = null;
      });
    });
  }

  void _loadTomorrowCalendar() {
    if (_isDayTransitioning) {
      return;
    }
    setState(() {
      if (!_tomorrowLabelUpdated) {
        _tomorrowLabelUpdated = true;
      }
      _isDayTransitioning = true;
      _activeNavAction = _DailyNavAction.tomorrow;
    });
    Future<void>.microtask(() {
      final DateTime target = _calendarDate.add(const Duration(days: 1));
      final AppState state = Provider.of<AppState>(context, listen: false);
      state.onDaySelected(target, DateTime(target.year, target.month, 1));
      _loadCalendar(target);
      if (!mounted) {
        return;
      }
      setState(() {
        _isDayTransitioning = false;
        _activeNavAction = null;
      });
    });
  }

  void _goToPreviousMonth() {
    setState(() {
      _dailyMonth = DateTime(_dailyMonth.year, _dailyMonth.month - 1, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _dailyMonth = DateTime(_dailyMonth.year, _dailyMonth.month + 1, 1);
    });
  }

  String _formattedKannadaDate(DateTime date) {
    final String day = DateFormat('EEEE', 'kn_IN').format(date);
    final String month = DateFormat('MMMM', 'kn_IN').format(date);
    final String dayNumber = DateFormat('d').format(date);
    final String year = DateFormat('yyyy').format(date);
    return '$day $dayNumber $month $year';
  }

  String _formattedTime(DateTime dateTime) {
    return DateFormat('hh:mm a', 'kn_IN').format(dateTime);
  }

  String _calendarImageUrl(DateTime date) {
    final String day = DateFormat('dd').format(date);
    final String month = DateFormat('MM').format(date);
    final String year = DateFormat('yyyy').format(date);
    return 'https://kannadacalendar.in/wp-content/kannada/daily/$year/$month/$day-$month-$year.jpg';
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _pageController.dispose();
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = Provider.of<AppState>(context);
    final DateTime today = state.selectedDay;
    final List<DateTime?> monthCells = PanchangaDataUtils.monthCells(_dailyMonth);
    final DateTime headerMonth = _section == _HomeSection.monthly ? _monthlyMonth : _dailyMonth;
    final Widget dailyContent = _DailyContent(
      selectedMonth: _dailyMonth,
      today: today,
      monthCells: PanchangaDataUtils.monthCells(_dailyMonth),
      calendarDate: state.selectedDay,
      formattedDate: DateFormat('d MMMM y', 'kn_IN').format(state.selectedDay),
      formattedTime: _formattedTime(_headerDateTime),
      calendarImageUrl: _calendarImageUrl(state.selectedDay),
      onDaySheet: (DateTime date) => _openDaySheet(context, date, state),
      onYesterday: _loadYesterdayCalendar,
      onToday: _loadTodayCalendar,
      onTomorrow: _loadTomorrowCalendar,
      onPrevMonth: _goToPreviousMonth,
      onNextMonth: _goToNextMonth,
      yesterdayLabelUpdated: _yesterdayLabelUpdated,
      tomorrowLabelUpdated: _tomorrowLabelUpdated,
      isLoading: _isDayTransitioning,
      loadingAction: _activeNavAction,
      annotations: state.dayAnnotations,
    );

    final Widget monthlyContent = _MonthlyContent(
      month: _monthlyMonth,
      onShowPanchanga: () => _showPanchangaYearSelection(),
    );
    final Widget mantraContent = const _MantraTabContent();
    final Widget festivalsContent = _FestivalsContent(
      year: headerMonth.year,
      onDayTap: (DateTime date) => _openDaySheet(context, date, state),
    );

    return _HomeScreenScope(
      state: this,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            const _TempleBackdrop(),
            SafeArea(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      _TopBar(
                        year: headerMonth.year,
                        onMenuTap: () => setState(() => _drawerOpen = true),
                      ),
                      const SizedBox(height: 10),
                      if (_section == _HomeSection.monthly) ...<Widget>[
                        _MonthTabBar(controller: _tabController, months: _months),
                        const SizedBox(height: 12),
                      ],
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (int page) {
                            if (page >= _HomeSection.values.length) {
                              return;
                            }
                            setState(() {
                              _section = _HomeSection.values[page];
                              _navIndex = page;
                            });
                          },
                          children: <Widget>[
                            dailyContent,
                            monthlyContent,
                            mantraContent,
                            festivalsContent,
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_drawerOpen)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () => setState(() => _drawerOpen = false),
                        child: Container(color: Colors.black.withValues(alpha: 0.35)),
                      ),
                    ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOut,
                    top: 16,
                    bottom: 16,
                    left: _drawerOpen ? 0 : -MediaQuery.of(context).size.width * 0.6,
                    child: _HomeDrawer(
                      width: MediaQuery.of(context).size.width * 0.6,
                      onClose: () => setState(() => _drawerOpen = false),
                      onNavigate: (int index) {
                        setState(() => _drawerOpen = false);
                        if (index < _HomeSection.values.length) {
                          _navigateToSection(_HomeSection.values[index]);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _BottomNavBar(
          currentIndex: _navIndex,
          onTap: (int index) {
            if (index < _HomeSection.values.length) {
              _navigateToSection(_HomeSection.values[index]);
            }
          },
        ),
      ),
    );
  }

  void _handleMenuTap() {
    _openHomeMenu();
  }

  Future<void> _openHomeMenu() async {
    final _HomeSection? selection = await Navigator.of(context).push<_HomeSection>(
      MaterialPageRoute<_HomeSection>(
        builder: (BuildContext context) => HomeMenuPage(currentSection: _section),
      ),
    );
    if (selection != null) {
      _navigateToSection(selection);
    }
  }

  void _navigateToSection(_HomeSection section) {
    final int targetIndex = section.index;
    if (_navIndex == targetIndex && _section == section) {
      return;
    }
    setState(() {
      _section = section;
      _navIndex = targetIndex;
    });
    _pageController.animateToPage(
      targetIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _openDaySheet(BuildContext context, DateTime date, AppState state) async {
    final ThemeData theme = Theme.of(context);
    final PanchangaDay? details = PanchangaDataUtils.dayFor(date);
    final LinkedHashSet<String> events = LinkedHashSet<String>.from(PanchangaDataUtils.festivalsFor(date));
    final String dayNameKannada = DateFormat('EEEE', 'kn_IN').format(date);
    final String monthNameKannada = DateFormat('MMMM', 'kn_IN').format(date);
    final String formattedDateLabel = '$dayNameKannada, ${date.day} $monthNameKannada ${date.year}';
    final DayAnnotation? existingAnnotation = state.annotationForDay(date);

    final _AnnotationResult? result = await showModalBottomSheet<_AnnotationResult>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _DayAnnotationSheet(
          formattedDateLabel: formattedDateLabel,
          details: details,
          events: events.toList(),
          existingAnnotation: existingAnnotation,
          shabadTitle: state.dailyShabad.title,
          shabadGurmukhi: state.dailyShabad.gurmukhi,
        );
      },
    );
    if (result == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    final AppState appState = Provider.of<AppState>(context, listen: false);
    if (result.shouldClear) {
      appState.clearAnnotation(date);
      return;
    }
    final DayAnnotation? annotation = result.annotation;
    if (annotation != null) {
      appState.saveAnnotation(date, annotation);
    }
  }

  void _showPanchangaYearSelection() {
    showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  width: 64,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F4AA3).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'ಪಂಚಾಂಗ ವರ್ಷವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansKannada(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F4AA3),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _PanchangaYearButton(
                      year: 2025,
                      label: '2025',
                      isSelected: false,
                      onTap: () => Navigator.of(context).pop(2025),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PanchangaYearButton(
                      year: 2026,
                      label: '2026',
                      isSelected: false,
                      onTap: () => Navigator.of(context).pop(2026),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    ).then((int? selectedYear) {
      if (selectedYear != null) {
        _openPanchangaPage(selectedYear);
      }
    });
  }

  void _openPanchangaPage(int year) {
    InterstitialAdManager.instance.showAd(onAdDismissed: () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).push(_MonthlySlidePageRoute(
        builder: (BuildContext context) => PanchangaImageScreen(month: _monthlyMonth.month, year: year),
      ));
    });
  }

  static Widget _detailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: GoogleFonts.notoSansKannada(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.notoSansKannada(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F4AA3).withValues(alpha: 0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.year, required this.onMenuTap});

  final int year;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onMenuTap,
            tooltip: 'ಮೆನು',
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF0F172A)),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[Color(0xFF0F4AA3), Color(0xFF1E88E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: const <BoxShadow>[
                  BoxShadow(color: Color(0x330F4AA3), blurRadius: 14, offset: Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      // App Title (Logo removed)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'ಕನ್ನಡ ಕ್ಯಾಲೆಂಡರ್',
                              style: GoogleFonts.notoSansKannada(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Kannada Calendar • $year',
                              style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.85)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer({required this.width, required this.onClose, required this.onNavigate});

  final double width;
  final VoidCallback onClose;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final List<_HomeSection> sections = _HomeSection.values;
    final List<String> labels = <String>['ದೈನಂದಿನ', 'ಮಾಸಿಕ ಕ್ಯಾಲೆಂಡರ್', 'ಧ್ಯಾನ / ಪ್ರಾರ್ಥನೆ', 'ಉತ್ಸವಗಳು'];
    final List<IconData> icons = <IconData>[Icons.calendar_today_rounded, Icons.calendar_month_rounded, Icons.self_improvement_rounded, Icons.celebration_rounded];

    return SizedBox(
      width: width,
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Color(0x330F172A), blurRadius: 24, offset: Offset(6, 12)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Logo in upper part of hamburger menu - just the logo without circle
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                'assets/icons/dailylogo.jpg',
                fit: BoxFit.contain,
                width: 80,
                height: 80,
                alignment: Alignment.center,
                cacheWidth: 160,
                filterQuality: FilterQuality.high,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: const Color(0xFF0F4AA3).withValues(alpha: 0.1),
                    child: Icon(
                      Icons.calendar_today_rounded,
                      color: const Color(0xFF0F4AA3),
                      size: 40,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('ಮೆನು', style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F4AA3))),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                  color: const Color(0xFF0F4AA3),
                ),
              ],
            ),
            const Divider(height: 26, thickness: 1.2),
            for (int i = 0; i < sections.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton.icon(
                  onPressed: () => onNavigate(i),
                  icon: Icon(icons[i], size: 22),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(labels[i], style: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF0F4AA3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 3,
                  ),
                ),
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class HomeMenuPage extends StatelessWidget {
  const HomeMenuPage({super.key, required this.currentSection});

  final _HomeSection currentSection;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<_HomeMenuOption> options = <_HomeMenuOption>[
      _HomeMenuOption(
        label: 'ದೈನಂದಿನ',
        section: _HomeSection.daily,
        icon: Icons.calendar_today_rounded,
      ),
      _HomeMenuOption(
        label: 'ಮಾಸಿಕ ಕ್ಯಾಲೆಂಡರ್',
        section: _HomeSection.monthly,
        icon: Icons.calendar_month_rounded,
      ),
      _HomeMenuOption(
        label: 'ಧ್ಯಾನ / ಮಂತ್ರಗಳು',
        section: _HomeSection.mantra,
        icon: Icons.self_improvement_rounded,
      ),
      _HomeMenuOption(
        label: 'ಉತ್ಸವಗಳು',
        section: _HomeSection.festivals,
        icon: Icons.celebration_rounded,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            const Text('ಮೆನು'),
          ],
        ),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (BuildContext context, int index) {
          final _HomeMenuOption option = options[index];
          final bool selected = option.section == currentSection;
          return ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            tileColor: selected ? theme.colorScheme.primary.withValues(alpha: 0.1) : theme.colorScheme.surface,
            iconColor: theme.colorScheme.primary,
            leading: Icon(option.icon, size: 26),
            title: Text(
              option.label,
              style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w700, color: theme.colorScheme.primary),
            ),
            onTap: () => Navigator.of(context).pop<_HomeSection>(option.section),
          );
        },
      ),
    );
  }
}

class _HomeMenuOption {
  const _HomeMenuOption({required this.label, required this.section, required this.icon});

  final String label;
  final _HomeSection section;
  final IconData icon;
}

class LogoSplashScreen extends StatelessWidget {
  const LogoSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F4AA3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Main App Logo shows when hamburger is clicked
            Container(
              width: 140,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 3),
                boxShadow: const <BoxShadow>[
                  BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 10)),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/icons/dailylogo.jpg', // Use correct logo path
                  fit: BoxFit.contain, // Changed to contain for full visibility
                  width: 140,
                  height: 120,
                  alignment: Alignment.center,
                  cacheWidth: 280,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 60,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'ಕನ್ನಡ ಕ್ಯಾಲೆಂಡರ್',
              style: GoogleFonts.notoSansKannada(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Sanātana Panchanga',
              style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeScreenScope extends InheritedWidget {
  const _HomeScreenScope({required this.state, required super.child});

  final _HomeScreenState state;

  _HomeSection get section => state._section;

  void navigateToSection(_HomeSection section) => state._navigateToSection(section);

  static _HomeScreenScope of(BuildContext context) {
    final _HomeScreenScope? scope = context.dependOnInheritedWidgetOfExactType<_HomeScreenScope>();
    assert(scope != null, 'HomeScreen scope is not available in the context');
    return scope!;
  }

  @override
  bool updateShouldNotify(_HomeScreenScope oldWidget) => state != oldWidget.state;
}

class _MonthTabBar extends StatelessWidget {
  const _MonthTabBar({required this.controller, required this.months});

  final TabController controller;
  final List<DateTime> months;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = months
        .map(
          (DateTime month) => Tab(
            child: Text(
              PanchangaDataUtils.kannadaMonthLabel(month),
              style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        )
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E7FF), width: 1.2),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x140F4AA3), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        labelColor: const Color(0xFF0F4AA3),
        unselectedLabelColor: const Color(0xFF64748B),
        indicator: BoxDecoration(
          color: const Color(0xFFE0F2FE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0F4AA3), width: 1.2),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        tabs: tabs,
      ),
    );
  }
}

class _DailyContent extends StatelessWidget {
  const _DailyContent({
    required this.selectedMonth,
    required this.today,
    required this.monthCells,
    required this.calendarDate,
    required this.formattedDate,
    required this.formattedTime,
    required this.calendarImageUrl,
    required this.onDaySheet,
    required this.onYesterday,
    required this.onToday,
    required this.onTomorrow,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.yesterdayLabelUpdated,
    required this.tomorrowLabelUpdated,
    required this.isLoading,
    required this.loadingAction,
    required this.annotations,
  });

  final DateTime selectedMonth;
  final DateTime today;
  final List<DateTime?> monthCells;
  final DateTime calendarDate;
  final String formattedDate;
  final String formattedTime;
  final String calendarImageUrl;
  final ValueChanged<DateTime> onDaySheet;
  final VoidCallback onYesterday;
  final VoidCallback onToday;
  final VoidCallback onTomorrow;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final bool yesterdayLabelUpdated;
  final bool tomorrowLabelUpdated;
  final bool isLoading;
  final _DailyNavAction? loadingAction;
  final Map<DateTime, DayAnnotation> annotations;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: <Widget>[
          _DailyCalendarCard(
            date: calendarDate,
            formattedDate: formattedDate,
            currentTime: formattedTime,
            imageUrl: calendarImageUrl,
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _CalendarNavButton(
                  label: yesterdayLabelUpdated ? 'ಹಿಂದೆ' : 'ನಿನ್ನೆ',
                  onTap: onYesterday,
                  color: const Color(0xFF166534),
                  isLoading: isLoading && loadingAction == _DailyNavAction.yesterday,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CalendarNavButton(
                  label: 'ಇಂದು',
                  onTap: onToday,
                  color: const Color(0xFFF97316),
                  isLoading: isLoading && loadingAction == _DailyNavAction.today,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CalendarNavButton(
                  label: tomorrowLabelUpdated ? 'ಮುಂದೆ' : 'ನಾಳೆ',
                  onTap: onTomorrow,
                  color: const Color(0xFFE11D48),
                  isLoading: isLoading && loadingAction == _DailyNavAction.tomorrow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _CalendarBoard(
            month: selectedMonth,
            today: today,
            cells: monthCells,
            onDayTap: (DateTime date) => onDaySheet(date),
            onPrevMonth: onPrevMonth,
            onNextMonth: onNextMonth,
            annotations: annotations,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _MonthlyContent extends StatefulWidget {
  const _MonthlyContent({required this.month, required this.onShowPanchanga});

  final DateTime month;
  final VoidCallback onShowPanchanga;

  @override
  State<_MonthlyContent> createState() => _MonthlyContentState();
}

class _MonthlyContentState extends State<_MonthlyContent> {
  @override
  void initState() {
    super.initState();
    InterstitialAdManager.instance.preload();
  }

  void _openRashiPage() {
    final String initialMonth = PanchangaDataUtils.kannadaMonthLabel(widget.month);
    InterstitialAdManager.instance.showAd(onAdDismissed: () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).push(_MonthlySlidePageRoute(
        builder: (BuildContext context) => RashiBhavishyaScreen(initialMonth: initialMonth),
      ));
    });
  }

  void _openZoomableCalendar(BuildContext context, DateTime month) {
    final String networkUrl = 'https://kannadacalendar.in/wp-content/kannada/monthly/${month.year}/${month.month.toString().padLeft(2, '0')}-${month.year}.jpg';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: Text(
              'ಮಾಸಿಕ ಕ್ಯಾಲೆಂಡರ್ - ${PanchangaDataUtils.kannadaMonthLabel(month)} ${month.year}',
              style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
          ),
          body: Container(
            color: Colors.black,
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.5,
              maxScale: 5.0,
              child: Center(
                child: Image.network(
                  networkUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
                    if (progress == null) {
                      return child;
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Container(
                      color: Colors.black,
                      child: const Center(
                        child: Text(
                          'ಮಾಸಿಕ ಕ್ಯಾಲೆಂಡರ್ ಚಿತ್ರ ಲೋಡ್ ಆಗಲಿಲ್ಲ\nಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕವನ್ನು ಪರಿಶೀಲಿಸಿ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<PanchangaDay> days = PanchangaDataUtils.daysForMonth(widget.month);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Month/Year header - above calendar, centered
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: <Widget>[
                Text(
                  PanchangaDataUtils.kannadaMonthLabel(widget.month),
                  style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w700, color: theme.colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${widget.month.year}',
                  style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w500, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Fixed calendar image - no swiping
          Container(
            height: MediaQuery.of(context).size.height * 0.5, // 50% of screen height for calendar
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE0E7FF), width: 1.5),
              boxShadow: const <BoxShadow>[
                BoxShadow(color: Color(0x1A0F4AA3), blurRadius: 20, offset: Offset(0, 8)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _MonthlyCalendarImage(
                month: widget.month,
                onTap: () => _openZoomableCalendar(context, widget.month),
              ),
            ),
          ),

          // Special day highlights
          _MonthlyHighlights(
            month: widget.month,
            days: days,
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: <Widget>[
              Expanded(
                child: _MonthlyActionButton(
                  label: 'ರಾಶಿ',
                  icon: Icons.auto_awesome_rounded,
                  onPressed: _openRashiPage,
                  theme: theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MonthlyActionButton(
                  label: 'ಪಂಚಾಂಗ',
                  icon: Icons.menu_book_rounded,
                  onPressed: widget.onShowPanchanga,
                  theme: theme,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16), // Bottom spacing for safe area
        ],
      ),
    );
  }
}

class _MonthlyCalendarImage extends StatelessWidget {
  const _MonthlyCalendarImage({required this.month, this.onTap});

  final DateTime month;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Load monthly calendar image from network URL
    final String networkUrl = 'https://kannadacalendar.in/wp-content/kannada/monthly/${month.year}/${month.month.toString().padLeft(2, '0')}-${month.year}.jpg';

    return GestureDetector(
      onTap: onTap,
      child: _MonthlyCalendarFallback(url: networkUrl, onTap: onTap),
    );
  }
}

class _MonthlyCalendarFallback extends StatelessWidget {
  const _MonthlyCalendarFallback({required this.url, this.onTap});

  final String url;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        onTap: onTap,
        child: Image.network(
          url,
          fit: BoxFit.contain, // Changed from cover to contain for full image visibility
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? progress) {
            if (progress == null) {
              return child;
            }
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F4AA3)),
              ),
            );
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return Container(
              color: const Color(0xFFF1F5F9),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.calendar_month_rounded, size: 48, color: Color(0xFF64748B)),
                  const SizedBox(height: 12),
                  Text(
                    'ಮಾಸಿಕ ಕ್ಯಾಲೆಂಡರ್\nಲಭ್ಯವಿಲ್ಲ',
                    style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF64748B)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕವನ್ನು\nಪರಿಶೀಲಿಸಿ',
                    style: GoogleFonts.notoSansKannada(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF94A3B8)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DailyCalendarCard extends StatelessWidget {
  const _DailyCalendarCard({
    required this.date,
    required this.formattedDate,
    required this.currentTime,
    required this.imageUrl,
  });

  final DateTime date;
  final String formattedDate;
  final String currentTime;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF1E88E5).withValues(alpha: 0.18), width: 1.3),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x1A0F4AA3), blurRadius: 18, offset: Offset(0, 10)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            formattedDate,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0F4AA3)),
          ),
          const SizedBox(height: 4),
          Text(
            currentTime,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF0F4AA3).withValues(alpha: 0.75)),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: SizedBox(
              width: double.infinity,
              child: _CalendarImage(imageUrl: imageUrl),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarImage extends StatelessWidget {
  const _CalendarImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Container(
          color: const Color(0xFFE2E8F0),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.broken_image_outlined, size: 32, color: Color(0xFF64748B)),
              const SizedBox(height: 8),
              Text('ಚಿತ್ರ ನೋಡಲು ಸಾಧ್ಯವಾಗುತ್ತಿಲ್ಲ', style: GoogleFonts.notoSansKannada(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF64748B))),
            ],
          ),
        );
      },
    );
  }
}

class _CalendarNavButton extends StatelessWidget {
  const _CalendarNavButton({required this.label, required this.onTap, required this.color, this.isLoading = false});

  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        textStyle: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(opacity: animation, child: child),
        child: isLoading
            ? Row(
                key: const ValueKey<String>('loading'),
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(label, style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w700)),
                ],
              )
            : Text(
                label,
                key: ValueKey<String>(label),
              ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String monthLabelKannada = PanchangaDataUtils.kannadaMonthLabel(month);
    final String monthLabelEnglish = DateFormat('MMMM').format(month);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFFFF6DA), Color(0xFFFFEDD5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFF3C969), width: 1.4),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x28F59E0B), blurRadius: 20, offset: Offset(0, 12)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _HeroInfoBox(
              title: 'ಮಾಸ ಮಾಹಾತ್ಮ್ಯ',
              bulletPoints: const <String>[
                'ವ್ರತ ಮತ್ತು ಹಬ್ಬಗಳ ವೈಶಿಷ್ಟ್ಯಗಳು',
                'ದೈನಂದಿನ ಆಚರಣೆಗಳಿಗೆ ಸೂಚನೆಗಳು',
                'ಪರಂಪರೆಯ ಮಾಂತ್ರಿಕ ವಾಕ್ಯಗಳು',
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 130,
                  width: 130,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xFFFFD166), Color(0xFFF97316)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/devi.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.brightness_5, color: Colors.white.withValues(alpha: 0.9), size: 68),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$monthLabelKannada - $monthLabelEnglish',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF9C2F00)),
                ),
                const SizedBox(height: 6),
                Text(
                  'ಶ್ಲೋಕ, ಸಂತೋಚಿತ ಪದಗಳು ಹಾಗೂ ದೇವಿಯ ಆರಾಧನೆಗಾಗಿ ಮಾಸಿಕ ಮಾರ್ಗದರ್ಶಿ.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFF7C4200)),
                ),
              ],
            ),
          ),
          Expanded(
            child: _HeroInfoBox(
              title: 'ದಿನಚರ್ಯೆ',
              bulletPoints: const <String>[
                'ಪ್ರಾತಃಕಾಲದ ಜಪ ಮತ್ತು ಪಾರಾಯಣ',
                'ಪರಮಾತ್ಮನಿಗೆ ನೈವೇದ್ಯ ಸೂಚನೆ',
                'ಸಂಜೆ ದೀಪಾರಾಧನೆಯ ಮುಖ್ಯ ವಿಧಿ',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroInfoBox extends StatelessWidget {
  const _HeroInfoBox({required this.title, required this.bulletPoints});

  final String title;
  final List<String> bulletPoints;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF9C74F).withValues(alpha: 0.6), width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: GoogleFonts.notoSansKannada(fontSize: 15, fontWeight: FontWeight.w800, color: const Color(0xFFB45309)),
          ),
          const SizedBox(height: 10),
          ...bulletPoints.map(
            (String point) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('• ', style: TextStyle(fontSize: 12, color: Color(0xFFB45309))),
                  Expanded(
                    child: Text(
                      point,
                      style: GoogleFonts.notoSansKannada(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFF734200)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarNavIcon extends StatelessWidget {
  const _CalendarNavIcon({
    required this.icon,
    required this.onTap,
    required this.background,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _CalendarBoard extends StatelessWidget {
  const _CalendarBoard({
    required this.month,
    required this.today,
    required this.cells,
    required this.onDayTap,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.annotations,
  });

  final DateTime month;
  final DateTime today;
  final List<DateTime?> cells;
  final ValueChanged<DateTime> onDayTap;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final Map<DateTime, DayAnnotation> annotations;

  @override
  Widget build(BuildContext context) {
    final String kannadaMonth = PanchangaDataUtils.kannadaMonthLabel(month);
    final String englishMonth = DateFormat('MMMM').format(month);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x140F172A), blurRadius: 14, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A8A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: <Widget>[
                _CalendarNavIcon(
                  icon: Icons.chevron_left,
                  onTap: onPrevMonth,
                  background: const Color(0xFF1D4ED8),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$kannadaMonth - ${month.year}',
                        style: GoogleFonts.notoSansKannada(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${PanchangaDataUtils.kannadaMonthLabel(month)} • $englishMonth',
                        style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _CalendarNavIcon(
                  icon: Icons.chevron_right,
                  onTap: onNextMonth,
                  background: const Color(0xFF1D4ED8),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(color: Color(0xFFEFF6FF)),
            child: Row(
              children: PanchangaDataUtils.kannadaWeekdayShort
                  .map(
                    (String label) => Expanded(
                      child: Center(
                        child: Text(
                          label,
                          style: GoogleFonts.notoSansKannada(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF1E3A8A)),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            child: GridView.builder(
              itemCount: cells.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (BuildContext context, int index) {
                final DateTime? date = cells[index];
                if (date == null) {
                  return const SizedBox.shrink();
                }

                final bool isCurrentMonth = date.month == month.month;
                final bool isToday = DateUtils.isSameDay(date, today);
                final bool isSunday = date.weekday == DateTime.sunday;
                final List<String> festivals = PanchangaDataUtils.festivalsFor(date);
                final PanchangaDay? info = PanchangaDataUtils.dayFor(date);
                final DayAnnotation? annotation = annotations[DateTime(date.year, date.month, date.day)];

                return _CalendarCell(
                  date: date,
                  info: info,
                  festivals: festivals,
                  isCurrentMonth: isCurrentMonth,
                  isToday: isToday,
                  isSunday: isSunday,
                  annotation: annotation,
                  onTap: () => onDayTap(date),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({
    required this.date,
    required this.info,
    required this.festivals,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSunday,
    required this.annotation,
    required this.onTap,
  });

  final DateTime date;
  final PanchangaDay? info;
  final List<String> festivals;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSunday;
  final DayAnnotation? annotation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasFestival = festivals.isNotEmpty;
    final _NoteHighlightPalette? highlightPalette = annotation?.colorKey != null
        ? _noteHighlightPalettes[annotation!.colorKey]
        : null;
    final bool hasAnnotation = annotation != null && annotation!.hasContent;

    Color baseAccent = isToday
        ? const Color(0xFF16A34A)
        : (hasFestival ? const Color(0xFFB91C1C) : (isSunday ? const Color(0xFFDC2626) : const Color(0xFF0F172A)));
    Color background = !isCurrentMonth
        ? const Color(0xFFF1F5F9)
        : (isToday
            ? const Color(0xFFD1FAE5)
            : (hasFestival
                ? const Color(0xFFFEE2E2)
                : (isSunday ? const Color(0xFFFEE2E2) : Colors.white)));
    Color borderColor = isCurrentMonth
        ? (isToday ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0))
        : const Color(0xFFE2E8F0);

    if (highlightPalette != null && isCurrentMonth) {
      background = highlightPalette.accent;
      borderColor = highlightPalette.accent.withValues(alpha: 0.95);
      baseAccent = Colors.white;
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isCurrentMonth ? 1 : 0.45,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1.1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '${date.day}',
                  style: GoogleFonts.notoSansKannada(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isCurrentMonth ? baseAccent : const Color(0xFF94A3B8),
                  ),
                ),
              ),
              const Spacer(),
              if (!hasAnnotation && hasFestival)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Color(0xFFB91C1C), shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthlyHighlights extends StatelessWidget {
  const _MonthlyHighlights({required this.month, List<PanchangaDay>? days}) : _days = days;

  final DateTime month;
  final List<PanchangaDay>? _days;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<PanchangaDay> days = _days ?? PanchangaDataUtils.daysForMonth(month);

    // Get comprehensive important dates
    final Map<String, List<_ImportantDate>> importantDates = _getImportantDatesForMonth(month, days);

    // Create a combined list of all important dates and sort chronologically
    final List<_ImportantDate> allImportantDates = <_ImportantDate>[];
    for (final List<_ImportantDate> categoryDates in importantDates.values) {
      allImportantDates.addAll(categoryDates);
    }

    // Sort all dates chronologically by day of month
    allImportantDates.sort((a, b) => a.date.day.compareTo(b.date.day));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E7FF), width: 1.2),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x140F172A), blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.celebration_rounded, size: 18, color: Color(0xFF0F4AA3)),
              const SizedBox(width: 8),
              Text(
                'ಪ್ರಮುಖ ಸಂಭ್ರಮಗಳು',
                style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF0F4AA3)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            constraints: BoxConstraints(maxHeight: 90),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: allImportantDates.isNotEmpty
                  ? allImportantDates.map(
                      (date) => _HighlightCard(
                        title: _truncateText(date.name, 16),
                        subtitle: DateFormat('d MMM', 'kn_IN').format(date.date),
                        accent: date.color,
                        category: _getCategoryIcon(date.category),
                      ),
                    ).toList()
                  : <Widget>[
                      _HighlightCard(
                        title: _truncateText('ಈ ತಿಂಗಳಿನಲ್ಲಿ ಎನು ವಿಶೇಷ ಸಂಭ್ರಮಗಳಿಲ್ಲ', 16),
                        subtitle: 'ಪಂಚಾಂಗ ವಿಷಯವನ್ನು ಅಪ್ಡೇಟ್ ಮಾಡಿ',
                        accent: theme.colorScheme.secondary,
                        category: '📋',
                      ),
                    ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<_ImportantDate>> _getImportantDatesForMonth(DateTime month, List<PanchangaDay> days) {
    final Map<String, List<_ImportantDate>> importantDates = <String, List<_ImportantDate>>{
      'national': <_ImportantDate>[],
      'karnataka': <_ImportantDate>[],
      'hindu': <_ImportantDate>[],
      'other_religious': <_ImportantDate>[],
      'moon_phases': <_ImportantDate>[],
      'government': <_ImportantDate>[],
    };

    // National Festivals of India
    final List<_ImportantDate> nationalFestivals = <_ImportantDate>[
      // January
      if (month.month == 1) ...<_ImportantDate>[
        _ImportantDate(DateTime(month.year, 1, 1), 'ಹೊಸ ವರ್ಷ', const Color(0xFFDC2626), 'national'),
        _ImportantDate(DateTime(month.year, 1, 26), 'ಗಣರಾಜ್ಯೋತ್ಸವ', const Color(0xFFEA580C), 'national'),
      ],
      // March
      if (month.month == 3) ...<_ImportantDate>[
        _ImportantDate(DateTime(month.year, 3, 8), 'ಅಂತರರಾಷ್ಟ್ರೀಯ ಮಹಿಳಾ ದಿನ', const Color(0xFF7C3AED), 'national'),
      ],
      // April
      if (month.month == 4) ...<_ImportantDate>[
        _ImportantDate(DateTime(month.year, 4, 14), 'ಡಾ. ಬಿ.ಆರ್. ಅಂಬೇಡ್ಕರ್ ಜಯಂತಿ', const Color(0xFF059669), 'national'),
      ],
      // May
      if (month.month == 5) ...<_ImportantDate>[
        _ImportantDate(DateTime(month.year, 5, 1), 'ಕಾರ್ಮಿಕರ ದಿನ', const Color(0xFFDC2626), 'national'),
      ],
      // August
      if (month.month == 8) ...<_ImportantDate>[
        _ImportantDate(DateTime(month.year, 8, 15), 'ಸ್ವಾತಂತ್ರ್ಯ ದಿನ', const Color(0xFFEA580C), 'national'),
      ],
      // October
      if (month.month == 10) ...<_ImportantDate>[
        _ImportantDate(DateTime(month.year, 10, 2), 'ಗಾಂಧಿ ಜಯಂತಿ', const Color(0xFF7C3AED), 'national'),
      ],
      // November
      if (month.month == 11) ...<_ImportantDate>[
        _ImportantDate(DateTime(month.year, 11, 14), 'ಬಾಲಕರ ದಿನ', const Color(0xFF059669), 'national'),
      ],
      // December
      if (month.month == 12) ...<_ImportantDate>[
        _ImportantDate(DateTime(month.year, 12, 25), 'ಕ್ರಿಸ್‌ಮಸ್', const Color(0xFFDC2626), 'national'),
      ],
    ];

    // Karnataka State Festivals
    final List<_ImportantDate> karnatakaFestivals = <_ImportantDate>[
      // January
      if (month.month == 1) ...<_ImportantDate>[
        _ImportantDate(DateTime(month.year, 1, 15), 'ಮಕರ ಸಂಕ್ರಾಂತಿ', const Color(0xFFEA580C), 'karnataka'),
      ],
      // March
      if (month.month == 3) ...<_ImportantDate>[
        _ImportantDate(DateTime(month.year, 3, 23), 'ಶಹೀದರ ದಿನ', const Color(0xFF7C3AED), 'karnataka'),
      ],
      // April
      if (month.month == 4) ...<_ImportantDate>[
        _ImportantDate(DateTime(month.year, 4, 1), 'ಕರ್ನಾಟಕ ರಾಜ್ಯೋತ್ಸವ', const Color(0xFFEA580C), 'karnataka'),
      ],
      // November
      if (month.month == 11) ...<_ImportantDate>[
        _ImportantDate(DateTime(month.year, 11, 1), 'ಕನ್ನಡ ರಾಜ್ಯೋತ್ಸವ', const Color(0xFFDC2626), 'karnataka'),
      ],
    ];

    // Hindu Festivals (based on lunar calendar - simplified)
    final List<_ImportantDate> hinduFestivals = <_ImportantDate>[
      // Check for common Hindu festivals in the panchanga data
      ...days.where((day) => day.festivals?.any((festival) =>
        festival.contains('ದೀಪಾವಳಿ') ||
        festival.contains('ದಸರಾ') ||
        festival.contains('ಹೋಳಿ') ||
        festival.contains('ಉಗಾದಿ') ||
        festival.contains('ವಿನಾಯಕ') ||
        festival.contains('ಗಣೇಶ') ||
        festival.contains('ನವರಾತ್ರಿ') ||
        festival.contains('ಕೃಷ್ಣ') ||
        festival.contains('ರಾಮ') ||
        festival.contains('ಶಿವರಾತ್ರಿ') ||
        festival.contains('ಹನುಮ') ||
        festival.contains('ದುರ್ಗಾ') ||
        festival.contains('ಮಹಾಶಿವರಾತ್ರಿ') ||
        festival.contains('ವಿಶ್ವಕರ್ಮ ಜಯಂತಿ') ||
        festival.contains('ಸರಸ್ವತಿ ಪೂಜೆ') ||
        festival.contains('ಲಕ್ಷ್ಮೀ ಪೂಜೆ') ||
        festival.contains('ಸಂಕಷ್ಟಹರ ಚತುರ್ಥಿ') ||
        festival.contains('ಅಂಗಾರಕ ಚತುರ್ಥಿ') ||
        festival.contains('ಶ್ರೀಕೃಷ್ಣ ಜನ್ಮಾಷ್ಟಮಿ') ||
        festival.contains('ಶ್ರೀರಾಮ ನವಮಿ')
      ) ?? false).map((day) => _ImportantDate(
        day.date,
        day.festivals!.first,
        const Color(0xFFEA580C),
        'hindu'
      )),
    ];

    // Other Religious Festivals
    final List<_ImportantDate> otherReligiousFestivals = <_ImportantDate>[
      // Muslim Festivals (approximate dates)
      if (month.month == 1) _ImportantDate(DateTime(month.year, 1, 1), 'ಹಿಜ್ರಿ ಹೊಸ ವರ್ಷ', const Color(0xFF059669), 'other_religious'),
      // Christian Festivals
      if (month.month == 12) _ImportantDate(DateTime(month.year, 12, 25), 'ಕ್ರಿಸ್‌ಮಸ್', const Color(0xFFDC2626), 'other_religious'),
      // Buddhist Festivals
      if (month.month == 5) _ImportantDate(DateTime(month.year, 5, 15), 'ಬುದ್ಧ ಪೂರ್ಣಿಮಾ', const Color(0xFFF59E0B), 'other_religious'),
    ];

    // Moon Phases
    final PanchangaDay? amavasyaDay = _matchTithi(days, 'amavasya');
    final PanchangaDay? purnimaDay = _matchTithi(days, 'purnima');

    final List<_ImportantDate> moonPhases = <_ImportantDate>[];
    if (amavasyaDay != null) {
      moonPhases.add(_ImportantDate(amavasyaDay.date, 'ಅಮಾವಾಸ್ಯೆ', const Color(0xFF6366F1), 'moon_phases'));
    }
    if (purnimaDay != null) {
      moonPhases.add(_ImportantDate(purnimaDay.date, 'ಪೂರ್ಣಿಮೆ', const Color(0xFF22C55E), 'moon_phases'));
    }

    // Government & Important Days (excluding duplicates)
    final List<_ImportantDate> governmentDays = <_ImportantDate>[
      // International Days (only if not already in other categories)
      if (month.month == 2) _ImportantDate(DateTime(month.year, 2, 14), 'ವ್ಯಾಲೆಂಟೈನ್ ದಿನ', const Color(0xFFEC4899), 'government'),
      if (month.month == 6) _ImportantDate(DateTime(month.year, 6, 21), 'ಅಂತರರಾಷ್ಟ್ರೀಯ ಯೋಗ ದಿನ', const Color(0xFF059669), 'government'),
      if (month.month == 9) _ImportantDate(DateTime(month.year, 9, 5), 'ಶಿಕ್ಷಕರ ದಿನ', const Color(0xFF3B82F6), 'government'),
      if (month.month == 10) _ImportantDate(DateTime(month.year, 10, 31), 'ಹ್ಯಾಲೋವೀನ್', const Color(0xFFF97316), 'government'),
    ];

    // Filter and assign dates, avoiding duplicates
    final Set<String> usedDates = <String>{}; // Track used dates as "month-day" strings

    // Helper function to check and add dates
    void addUniqueDates(String category, List<_ImportantDate> dates) {
      for (final _ImportantDate date in dates) {
        final String dateKey = '${date.date.month}-${date.date.day}';
        if (!usedDates.contains(dateKey)) {
          importantDates[category]!.add(date);
          usedDates.add(dateKey);
        }
      }
    }

    // Add dates in order of priority and chronological order
    addUniqueDates('national', nationalFestivals);
    addUniqueDates('karnataka', karnatakaFestivals);
    addUniqueDates('hindu', hinduFestivals);
    addUniqueDates('other_religious', otherReligiousFestivals);
    addUniqueDates('moon_phases', moonPhases);
    addUniqueDates('government', governmentDays);

    // Sort all dates chronologically within each category
    for (final String category in importantDates.keys) {
      importantDates[category]!.sort((a, b) => a.date.day.compareTo(b.date.day));
    }

    return importantDates;
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    // Try to truncate at word boundary if possible
    final int spaceIndex = text.lastIndexOf(' ', maxLength - 4);
    if (spaceIndex > maxLength - 8) {
      return '${text.substring(0, spaceIndex)}...';
    }
    return '${text.substring(0, maxLength - 3)}...';
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'national':
        return '🇮🇳';
      case 'karnataka':
        return '🏛️';
      case 'hindu':
        return '🕉️';
      case 'other_religious':
        return '🙏';
      case 'moon_phases':
        return '🌙';
      case 'government':
        return '📅';
      default:
        return '📋';
    }
  }

  PanchangaDay? _matchTithi(List<PanchangaDay> days, String keyword) {
    final String search = keyword.toLowerCase();
    for (final PanchangaDay day in days) {
      if (day.tithi.toLowerCase().contains(search)) {
        return day;
      }
    }
    return null;
  }
}

class _ImportantDate {
  const _ImportantDate(this.date, this.name, this.color, this.category);

  final DateTime date;
  final String name;
  final Color color;
  final String category;
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    this.category,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final String? category;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 85,
        maxWidth: 110,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: <Color>[accent.withValues(alpha: 0.08), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: accent.withValues(alpha: 0.24), width: 1.0),
        boxShadow: <BoxShadow>[
          BoxShadow(color: accent.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (category != null)
            Container(
              margin: const EdgeInsets.only(bottom: 2),
              child: Text(
                category!,
                style: TextStyle(
                  fontSize: 8,
                  color: accent.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSansKannada(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _darken(accent, 0.15),
              height: 1.1,
            ),
          ),
          if (subtitle.isNotEmpty) ...<Widget>[
            const SizedBox(height: 1),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSansKannada(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: accent.withValues(alpha: 0.7),
                height: 1.0,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _darken(Color color, double amount) {
    final double factor = 1 - amount;
    return Color.fromARGB(
      color.alpha,
      (color.red * factor).round().clamp(0, 255),
      (color.green * factor).round().clamp(0, 255),
      (color.blue * factor).round().clamp(0, 255),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: const Color(0xFFEA580C),
      unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.today_rounded), label: 'ದೈನಂದಿನ'),
        BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'ಮಾಸಿಕ ಕ್ಯಾಲೆಂಡರ್'),
        BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'ಧ್ಯಾನ / ಮಂತ್ರಗಳು'),
        BottomNavigationBarItem(icon: Icon(Icons.event_available_outlined), label: 'ಉತ್ಸವಗಳು'),
      ],
    );
  }
}

class _TempleBackdrop extends StatelessWidget {
  const _TempleBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const GradientBackground(),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  const Color(0xFFFEE8C8).withValues(alpha: 0.65),
                  const Color(0xFFFFF5E6).withValues(alpha: 0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/patterns/sanskrit_texture.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
