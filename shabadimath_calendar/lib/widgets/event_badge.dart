import 'package:flutter/material.dart';

import '../models/calendar_event.dart';

class EventBadge extends StatelessWidget {
  const EventBadge({
    super.key,
    required this.event,
  });

  final CalendarEvent event;

  Color _badgeColor(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final Color secondary = Theme.of(context).colorScheme.secondary;
    switch (event.type) {
      case EventType.gurpurab:
        return secondary;
      case EventType.hukamnama:
        return primary;
      case EventType.general:
      default:
        return Theme.of(context).colorScheme.tertiary ?? primary;
    }
  }

  IconData _icon() {
    if (event.icon != null) {
      return event.icon!;
    }
    switch (event.type) {
      case EventType.gurpurab:
        return Icons.auto_awesome;
      case EventType.hukamnama:
        return Icons.menu_book;
      case EventType.general:
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color color = _badgeColor(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: (isDark ? 0.24 : 0.18)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(_icon(), size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            event.title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
