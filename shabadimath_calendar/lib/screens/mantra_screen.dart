import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/data_utils.dart';
import '../widgets/glass_card.dart';

class MantraScreen extends StatelessWidget {
  const MantraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ಧ್ಯಾನ / ಮಂತ್ರಗಳು',
          style: GoogleFonts.notoSansKannada(fontWeight: FontWeight.w700),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFFFFF7E6),
              Color(0xFFFFF1D0),
            ],
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
                        style: GoogleFonts.notoSansKannada(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
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
      ),
    );
  }
}
