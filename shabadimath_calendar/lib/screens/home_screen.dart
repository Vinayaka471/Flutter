import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/panchanga_day.dart';
import '../models/reminder.dart';
import '../providers/app_state.dart';
import '../providers/reminder_provider.dart';
import '../utils/data_utils.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';
import 'mantra_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
  static const MethodChannel _panchangaChannel = MethodChannel('com.dailycalendar.kannada/panchanga');

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

  @override
  void initState() {
    super.initState();
    final AppState state = Provider.of<AppState>(context, listen: false);
    final DateTime selectedDay = state.selectedDay;
    _months = PanchangaDataUtils.monthsForYear(selectedDay.year);
    _dailyMonth = DateTime(selectedDay.year, selectedDay.month, 1);
    _monthlyMonth = DateTime(selectedDay.year, selectedDay.month, 1);
    _tabController = TabController(length: _months.length, vsync: this, initialIndex: _monthlyMonth.month - 1);
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

  Future<void> _launchNativePanchanga() async {
    final DateTime month = _monthlyMonth;
    try {
      await _panchangaChannel.invokeMethod<void>('showPanchanga', <String, int>{
        'month': month.month,
        'year': month.year,
      });
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ಪಂಚಾಂಗ ತೆರೆಯಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ: ${error.message ?? 'ಅಜ್ಞಾತ ದೋಷ'}')),
      );
    }
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
      _loadCalendar(_calendarDate.subtract(const Duration(days: 1)));
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
      _loadCalendar(DateUtils.dateOnly(DateTime.now()));
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
      _loadCalendar(_calendarDate.add(const Duration(days: 1)));
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
    return DateFormat('hh:mm:ss a').format(dateTime);
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
      monthCells: monthCells,
      calendarDate: _calendarDate,
      formattedDate: _formattedKannadaDate(_calendarDate),
      formattedTime: _formattedTime(_headerDateTime),
      calendarImageUrl: _calendarImageUrl(_calendarDate),
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
    );

    final Widget monthlyContent = _MonthlyContent(
      month: _monthlyMonth,
      onShowPanchanga: _launchNativePanchanga,
    );
    final Widget mantraContent = const _MantraTabContent();
    final Widget festivalsContent = _FestivalsContent(
      year: headerMonth.year,
      onDayTap: (DateTime date) => _openDaySheet(context, date, state),
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          const _TempleBackdrop(),
          SafeArea(
            child: Column(
              children: <Widget>[
                _HeaderStrip(year: headerMonth.year),
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
          ),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _navIndex,
        onTap: (int index) async {
          if (index == _navIndex) {
            return;
          }
          switch (index) {
            case 0:
              setState(() {
                _section = _HomeSection.daily;
                _navIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              break;
            case 1:
              setState(() {
                _section = _HomeSection.monthly;
                _navIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              break;
            case 2:
              setState(() {
                _section = _HomeSection.mantra;
                _navIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              break;
            case 3:
              setState(() {
                _section = _HomeSection.festivals;
                _navIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              break;
            default:
              setState(() {
                _section = _HomeSection.daily;
                _navIndex = index;
              });
          }
        },
      ),
    );
  }

  void _openDaySheet(BuildContext context, DateTime date, AppState state) {
    final ThemeData theme = Theme.of(context);
    final PanchangaDay? details = PanchangaDataUtils.dayFor(date);
    final LinkedHashSet<String> events = LinkedHashSet<String>.from(PanchangaDataUtils.festivalsFor(date));
    final String dayNameKannada = DateFormat('EEEE', 'kn_IN').format(date);
    final String monthNameKannada = DateFormat('MMMM', 'kn_IN').format(date);
    final String formattedDateLabel = '$dayNameKannada, ${date.day} $monthNameKannada ${date.year}';

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    formattedDateLabel,
                    style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 18),
                  _detailRow(theme, 'ತಿಥಿ', details?.tithi ?? '—'),
                  _detailRow(theme, 'ಪಕ್ಷ', details?.paksha ?? '—'),
                  _detailRow(theme, 'ನಕ್ಷತ್ರ', details?.nakshatra ?? '—'),
                  _detailRow(theme, 'ಯೋಗ', details?.yoga ?? '—'),
                  _detailRow(theme, 'ಕರಣ', details?.karana ?? '—'),
                  if (events.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 18),
                    Text(
                      'ಉತ್ಸವಗಳು',
                      style: GoogleFonts.notoSansKannada(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...events.map(
                      (String festival) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('• $festival', style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text('ದಿನದ ಶಬ್ದ', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(state.dailyShabad.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(state.dailyShabad.gurmukhi, style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)),
                ],
              ),
            ),
          ),
        );
      },
    );
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
                color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarNavIcon extends StatelessWidget {
  const _CalendarNavIcon({required this.icon, required this.onTap, required this.background});

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
          boxShadow: <BoxShadow>[
            BoxShadow(color: background.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _HeaderStrip extends StatelessWidget {
  const _HeaderStrip({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF0F4AA3), Color(0xFF1E88E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x400F4AA3), blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'ಸನಾತನ ಪಂಚಾಂಗ',
                style: GoogleFonts.notoSansKannada(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                'Sanātana Panchanga • $year',
                style: GoogleFonts.notoSansKannada(fontSize: 14.5, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.82)),
              ),
            ],
          ),
          const Icon(Icons.temple_hindu, color: Colors.white, size: 32),
        ],
      ),
    );
  }
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
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _MonthlyContent extends StatelessWidget {
  const _MonthlyContent({required this.month, required this.onShowPanchanga});

  final DateTime month;
  final VoidCallback onShowPanchanga;

  @override
  Widget build(BuildContext context) {
    final String? monthImage = PanchangaDataUtils.monthImageAsset(month);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (monthImage != null) ...<Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x140F172A), blurRadius: 14, offset: Offset(0, 8)),
                  ],
                ),
                child: Image.asset(
                  monthImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 320,
                    color: const Color(0xFFE2E8F0),
                    alignment: Alignment.center,
                    child: Text(
                      'ಚಿತ್ರ ಲಭ್ಯವಿಲ್ಲ',
                      style: GoogleFonts.notoSansKannada(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF64748B)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onShowPanchanga,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F4AA3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w700),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 4,
              ),
              icon: const Icon(Icons.menu_book_rounded, size: 20),
              label: const Text('ಪಂಚಾಂಗ'),
            ),
          ),
          const SizedBox(height: 20),
          _MonthlyHighlights(month: month),
          const SizedBox(height: 60),
        ],
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

class _CalendarBoard extends StatelessWidget {
  const _CalendarBoard({
    required this.month,
    required this.today,
    required this.cells,
    required this.onDayTap,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final DateTime month;
  final DateTime today;
  final List<DateTime?> cells;
  final ValueChanged<DateTime> onDayTap;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

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

                return _CalendarCell(
                  date: date,
                  info: info,
                  festivals: festivals,
                  isCurrentMonth: isCurrentMonth,
                  isToday: isToday,
                  isSunday: isSunday,
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
    required this.onTap,
  });

  final DateTime date;
  final PanchangaDay? info;
  final List<String> festivals;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSunday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasFestival = festivals.isNotEmpty;
    final Color baseAccent = isToday
        ? const Color(0xFF16A34A)
        : (hasFestival ? const Color(0xFFB91C1C) : (isSunday ? const Color(0xFFDC2626) : const Color(0xFF0F172A)));
    final Color background = !isCurrentMonth
        ? const Color(0xFFF1F5F9)
        : (isToday
            ? const Color(0xFFD1FAE5)
            : (hasFestival
                ? const Color(0xFFFEE2E2)
                : (isSunday ? const Color(0xFFFEE2E2) : Colors.white)));
    final Color borderColor = isCurrentMonth
        ? (isToday ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0))
        : const Color(0xFFE2E8F0);

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
              if (hasFestival)
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
  const _MonthlyHighlights({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<PanchangaDay> days = PanchangaDataUtils.daysForMonth(month);
    final List<PanchangaDay> festivalDays = days.where((PanchangaDay day) => (day.festivals?.isNotEmpty ?? false)).take(3).toList();

    final PanchangaDay? amavasyaDay = _matchTithi(days, 'amavasya');
    final PanchangaDay? purnimaDay = _matchTithi(days, 'purnima');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E7FF), width: 1.2),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x140F172A), blurRadius: 18, offset: Offset(0, 10)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ಪ್ರಮುಖ ಸಂಭ್ರಮಗಳು',
            style: GoogleFonts.notoSansKannada(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F4AA3)),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: <Widget>[
              if (festivalDays.isNotEmpty)
                ...festivalDays.map(
                  (PanchangaDay day) => _HighlightCard(
                    title: day.festivals!.first,
                    subtitle: DateFormat('d MMMM', 'kn_IN').format(day.date),
                    accent: const Color(0xFFEA580C),
                  ),
                ),
              if (amavasyaDay != null)
                _HighlightCard(
                  title: amavasyaDay.tithi,
                  subtitle: DateFormat('d MMMM', 'kn_IN').format(amavasyaDay.date),
                  accent: const Color(0xFF6366F1),
                ),
              if (purnimaDay != null)
                _HighlightCard(
                  title: purnimaDay.tithi,
                  subtitle: DateFormat('d MMMM', 'kn_IN').format(purnimaDay.date),
                  accent: const Color(0xFF22C55E),
                ),
              if (festivalDays.isEmpty && amavasyaDay == null && purnimaDay == null)
                _HighlightCard(
                  title: 'ಈ ತಿಂಗಳಲ್ಲಿิเศษ ಹಬ್ಬಗಳಿಲ್ಲ',
                  subtitle: 'ಪಂಚಾಂಗ ವಿಷಯವನ್ನು ಅಪ್ಡೇಟ್ ಮಾಡಿ',
                  accent: theme.colorScheme.secondary,
                ),
            ],
          ),
        ],
      ),
    );
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

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.title, required this.subtitle, required this.accent});

  final String title;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: <Color>[accent.withValues(alpha: 0.12), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: accent.withValues(alpha: 0.32), width: 1.1),
        boxShadow: <BoxShadow>[
          BoxShadow(color: accent.withValues(alpha: 0.18), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSansKannada(fontSize: 14, fontWeight: FontWeight.w800, color: _darken(accent, 0.15)),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.notoSansKannada(fontSize: 12, fontWeight: FontWeight.w600, color: accent.withValues(alpha: 0.8)),
          ),
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
