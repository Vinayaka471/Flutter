import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/calendar_event.dart';
import '../models/shabad.dart';
import '../providers/app_state.dart';
import '../widgets/glass_card.dart';
import '../widgets/shabad_card.dart';

class ShabadDetailsScreen extends StatelessWidget {
  const ShabadDetailsScreen({super.key, this.event});

  final CalendarEvent? event;

  @override
  Widget build(BuildContext context) {
    final AppState state = Provider.of<AppState>(context);
    final Shabad shabad = _resolveShabad(state);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Daily Shabad'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.18),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (event != null)
                    GlassCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            event!.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            event!.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  if (event != null) const SizedBox(height: 20),
                  ShabadCard(
                    shabad: shabad,
                    onShare: () => _shareShabad(shabad),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Shabad _resolveShabad(AppState state) {
    if (event?.shabadId != null) {
      final Shabad? related = state.shabadById(event!.shabadId!);
      if (related != null) {
        return related;
      }
    }
    return state.dailyShabad;
  }

  void _shareShabad(Shabad shabad) {
    final StringBuffer buffer = StringBuffer()
      ..writeln(shabad.title)
      ..writeln(shabad.gurmukhi)
      ..writeln()
      ..writeln(shabad.transliteration)
      ..writeln()
      ..writeln(shabad.translation);
    Share.share(buffer.toString(), subject: shabad.title);
  }
}
