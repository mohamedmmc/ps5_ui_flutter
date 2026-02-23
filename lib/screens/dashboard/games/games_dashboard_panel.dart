import 'package:flutter/material.dart';

import '../../../models/game.dart';
import '../../../widgets/game_row.dart';
import '../../../widgets/hero_section.dart';

class GamesDashboardPanel extends StatelessWidget {
  final List<Game> games;
  final String selectedGameId;
  final Game selectedGame;
  final ValueChanged<String> onSelectGame;
  final VoidCallback onLaunchGame;

  const GamesDashboardPanel({
    super.key,
    required this.games,
    required this.selectedGameId,
    required this.selectedGame,
    required this.onSelectGame,
    required this.onLaunchGame,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameRow(
          games: games,
          selectedGameId: selectedGameId,
          onSelectGame: onSelectGame,
          switchKey: ContentType.game,
        ),
        HeroSection(
          game: selectedGame,
          onPrimaryAction: onLaunchGame,
          primaryActionLabel: 'Launch Game',
        ),
      ],
    );
  }
}
