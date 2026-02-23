import 'package:flutter/material.dart';

import '../../../models/game.dart';
import '../../../widgets/game_row.dart';
import '../../../widgets/hero_section.dart';

class MediaDashboardPanel extends StatelessWidget {
  final List<Game> mediaApps;
  final String selectedMediaId;
  final Game selectedMedia;
  final List<FeaturedMedia> featuredMedia;
  final ValueChanged<String> onSelectMedia;
  final VoidCallback onOpenMedia;

  const MediaDashboardPanel({
    super.key,
    required this.mediaApps,
    required this.selectedMediaId,
    required this.selectedMedia,
    required this.featuredMedia,
    required this.onSelectMedia,
    required this.onOpenMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameRow(
          games: mediaApps,
          selectedGameId: selectedMediaId,
          onSelectGame: onSelectMedia,
          switchKey: ContentType.media,
        ),
        HeroSection(
          game: selectedMedia,
          featuredMedia: featuredMedia,
          onPrimaryAction: onOpenMedia,
          primaryActionLabel: 'Open App',
        ),
      ],
    );
  }
}
