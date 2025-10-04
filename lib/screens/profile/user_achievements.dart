import 'package:flutter/material.dart';
import 'package:ybt_match/widgets/achievement_card.dart';

class UserAchievements extends StatelessWidget {
  final int matchesJoined;
  final int matchesWon;
  final int matchesLost;

  const UserAchievements({
    super.key,
    required this.matchesJoined,
    required this.matchesWon,
    required this.matchesLost,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AchievementCard(
          title: 'Joined',
          value: matchesJoined.toString(),
          icon: Icons.event,
        ),
        AchievementCard(
          title: 'Won',
          value: matchesWon.toString(),
          icon: Icons.emoji_events,
        ),
        AchievementCard(
          title: 'Lost',
          value: matchesLost.toString(),
          icon: Icons.thumb_down,
        ),
      ],
    );
  }
}
