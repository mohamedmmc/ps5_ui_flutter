import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/game.dart';

class HeroSection extends StatelessWidget {
  final Game game;
  final List<FeaturedMedia>? featuredMedia;

  const HeroSection({
    super.key,
    required this.game,
    this.featuredMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.0),
              Colors.black.withValues(alpha: 0.4),
              Colors.black.withValues(alpha: 0.9),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 48, right: 48, bottom: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Game Logo/Title
              if (game.logo != null)
                _GameLogo(logo: game.logo!)
              else
                Text(
                  game.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 10,
                        color: Colors.black87,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Description
              Container(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Text(
                  game.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    height: 1.5,
                    shadows: const [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 5,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.95),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      game.type == ContentType.game ? 'Play Game' : 'Open App',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _CircleButton(
                    icon: LucideIcons.messageSquare,
                    onTap: () {},
                  ),
                  const SizedBox(width: 16),
                  _CircleButton(
                    icon: Icons.more_horiz,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Stats and News Section
              if (game.progress != null || game.news != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // News Card
                    if (game.news != null) ...[
                      _NewsCard(news: game.news!),
                      const SizedBox(width: 32),
                    ],

                    // Progress Stats
                    if (game.progress != null) _ProgressCard(game: game),
                  ],
                ),

              // Featured Media Section
              if (game.type == ContentType.media && featuredMedia != null) ...[
                const SizedBox(height: 32),
                _FeaturedMediaSection(featuredMedia: featuredMedia!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GameLogo extends StatelessWidget {
  final String logo;

  const _GameLogo({required this.logo});

  bool get _isImageUrl => logo.startsWith('http') || logo.startsWith('data:') || logo.endsWith('.png');

  @override
  Widget build(BuildContext context) {
    if (_isImageUrl) {
      return SizedBox(
        height: 160,
        child: logo.startsWith('http')
            ? CachedNetworkImage(
                imageUrl: logo,
                height: 160,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              )
            : Image.asset(
                logo,
                height: 160,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
      );
    } else {
      return Text(
        logo,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 60,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
          shadows: [
            Shadow(
              offset: Offset(0, 4),
              blurRadius: 20,
              color: Colors.black87,
            ),
          ],
        ),
      );
    }
  }
}

class _CircleButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<_CircleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatefulWidget {
  final NewsItem news;

  const _NewsCard({required this.news});

  @override
  State<_NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<_NewsCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _isHovered ? 1.05 : 1.0,
        child: Container(
          width: 300,
          height: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF27272A).withValues(alpha: 0.8),
                const Color(0xFF18181B).withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'OFFICIAL NEWS',
                    style: TextStyle(
                      color: _isHovered ? Colors.white.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    widget.news.date,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.news.title,
                    style: TextStyle(
                      color: _isHovered ? const Color(0xFF60A5FA) : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.news.description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

class _ProgressCard extends StatelessWidget {
  final Game game;

  const _ProgressCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      constraints: const BoxConstraints(minWidth: 320),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROGRESS',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${game.progress}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (game.earned != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'EARNED',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      game.earned!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (game.trophies != null) ...[
            const SizedBox(height: 12),
            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _TrophyCount(
                  count: game.trophies!.platinum,
                  color: const Color(0xFFE5E7EB),
                ),
                const SizedBox(width: 16),
                _TrophyCount(
                  count: game.trophies!.gold,
                  color: const Color(0xFFFBBF24),
                ),
                const SizedBox(width: 16),
                _TrophyCount(
                  count: game.trophies!.silver,
                  color: const Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 16),
                _TrophyCount(
                  count: game.trophies!.bronze,
                  color: const Color(0xFFB45309),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TrophyCount extends StatelessWidget {
  final int count;
  final Color color;

  const _TrophyCount({
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          LucideIcons.trophy,
          color: color,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _FeaturedMediaSection extends StatelessWidget {
  final List<FeaturedMedia> featuredMedia;

  const _FeaturedMediaSection({required this.featuredMedia});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 157,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredMedia.length,
            itemBuilder: (context, index) {
              final media = featuredMedia[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _FeaturedMediaCard(media: media),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FeaturedMediaCard extends StatefulWidget {
  final FeaturedMedia media;

  const _FeaturedMediaCard({required this.media});

  @override
  State<_FeaturedMediaCard> createState() => _FeaturedMediaCardState();
}

class _FeaturedMediaCardState extends State<_FeaturedMediaCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _isHovered ? 1.05 : 1.0,
        child: Container(
          width: 280,
          height: 157,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.media.imageUrl,
                  width: 280,
                  height: 157,
                  fit: BoxFit.cover,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: _isHovered ? Colors.transparent : Colors.black.withValues(alpha: 0.2),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.media.serviceLogo,
                      height: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (_isHovered)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text(
                        'WATCH',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
