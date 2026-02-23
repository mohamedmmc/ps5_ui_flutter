import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/game.dart';
import '../utils/responsive.dart';

class HeroSection extends StatelessWidget {
  final Game game;
  final List<FeaturedMedia>? featuredMedia;
  final VoidCallback? onPrimaryAction;
  final String? primaryActionLabel;

  const HeroSection({
    super.key,
    required this.game,
    this.featuredMedia,
    this.onPrimaryAction,
    this.primaryActionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final horizontalPadding = isMobile ? 16.0 : 48.0;
    final bottomPadding = isMobile ? 24.0 : 48.0;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: DecoratedBox(
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
        child: SizedBox(
          height: MediaQuery.of(context).size.height * (isMobile ? 0.7 : 0.6),
          child: Padding(
            padding: EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: bottomPadding,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 520),
              reverseDuration: const Duration(milliseconds: 420),
              switchInCurve: Curves.easeInCubic,
              switchOutCurve: Curves.easeOutCubic,
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              transitionBuilder: (child, animation) {
                // Simplified transition for better performance (removed Scale and Slide)
                return FadeTransition(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInCubic,
                    reverseCurve: Curves.easeOutCubic,
                  ),
                  child: child,
                );
              },
              child: KeyedSubtree(
                key: ValueKey(game.id),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: _HeroContent(
                            game: game,
                            featuredMedia: featuredMedia,
                            onPrimaryAction: onPrimaryAction,
                            primaryActionLabel: primaryActionLabel,
                          ),
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
}

class _HeroContent extends StatelessWidget {
  final Game game;
  final List<FeaturedMedia>? featuredMedia;
  final VoidCallback? onPrimaryAction;
  final String? primaryActionLabel;

  const _HeroContent({
    required this.game,
    required this.featuredMedia,
    required this.onPrimaryAction,
    required this.primaryActionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final circleSize = isMobile ? 44.0 : 48.0;
    final circleIconSize = isMobile ? 18.0 : 20.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (game.logo != null)
          _GameLogo(logo: game.logo!, isMobile: isMobile)
        else
          Text(
            game.title,
            style: AppTextStyles.heroTitle(isMobile: isMobile),
          ),
        SizedBox(height: isMobile ? 12 : 16),
        ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: isMobile ? double.infinity : 700),
          child: Text(
            game.description,
            style: AppTextStyles.heroDescription(isMobile: isMobile),
            maxLines: isMobile ? 2 : 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: isMobile ? 16 : 24),
        if (isMobile)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton(
                onPressed: onPrimaryAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.95),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  primaryActionLabel ??
                      (game.type == ContentType.game
                          ? 'Play Game'
                          : 'Open App'),
                  style: AppTextStyles.heroPrimaryButton(isMobile: true),
                ),
              ),
              _CircleButton(
                icon: LucideIcons.messageSquare,
                size: circleSize,
                iconSize: circleIconSize,
                onTap: () {},
              ),
              _CircleButton(
                icon: Icons.more_horiz,
                size: circleSize,
                iconSize: circleIconSize,
                onTap: () {},
              ),
            ],
          )
        else
          Row(
            children: [
              ElevatedButton(
                onPressed: onPrimaryAction,
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
                  primaryActionLabel ??
                      (game.type == ContentType.game
                          ? 'Play Game'
                          : 'Open App'),
                  style: AppTextStyles.heroPrimaryButton(isMobile: false),
                ),
              ),
              const SizedBox(width: 16),
              _CircleButton(
                icon: LucideIcons.messageSquare,
                size: circleSize,
                iconSize: circleIconSize,
                onTap: () {},
              ),
              const SizedBox(width: 16),
              _CircleButton(
                icon: Icons.more_horiz,
                size: circleSize,
                iconSize: circleIconSize,
                onTap: () {},
              ),
            ],
          ),
        const SizedBox(height: 32),
        if (game.progress != null || game.news != null)
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth;
              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (game.news != null)
                      _NewsCard(
                          news: game.news!, width: cardWidth, isMobile: true),
                    if (game.news != null && game.progress != null)
                      const SizedBox(height: 12),
                    if (game.progress != null)
                      _ProgressCard(
                          game: game, width: cardWidth, isMobile: true),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (game.news != null) ...[
                    _NewsCard(news: game.news!, width: 300, isMobile: false),
                    const SizedBox(width: 32),
                  ],
                  if (game.progress != null)
                    _ProgressCard(game: game, isMobile: false),
                ],
              );
            },
          ),
        if (game.type == ContentType.media && featuredMedia != null) ...[
          const SizedBox(height: 32),
          _FeaturedMediaSection(featuredMedia: featuredMedia!),
        ],
      ],
    );
  }
}

class _GameLogo extends StatelessWidget {
  final String logo;
  final bool isMobile;

  const _GameLogo({required this.logo, this.isMobile = false});

  bool get _isImageUrl =>
      logo.startsWith('http') ||
      logo.startsWith('data:') ||
      logo.endsWith('.png');

  @override
  Widget build(BuildContext context) {
    final logoHeight = isMobile ? 100.0 : 160.0;

    if (_isImageUrl) {
      return SizedBox(
        height: logoHeight,
        child: logo.startsWith('http')
            ? CachedNetworkImage(
                imageUrl: logo,
                height: logoHeight,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
                memCacheHeight: (logoHeight * 2)
                    .toInt(), // Optimize logo cache (2x for hi-dpi)
                maxHeightDiskCache: (logoHeight * 2).toInt(),
              )
            : Image.asset(
                logo,
                height: logoHeight,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
      );
    } else {
      return Text(
        logo,
        style: AppTextStyles.heroLogoText(isMobile: isMobile),
      );
    }
  }
}

class _CircleButton extends StatefulWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    this.size = 48,
    this.iconSize = 20,
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
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: widget.iconSize,
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatefulWidget {
  final NewsItem news;
  final double width;
  final bool isMobile;

  const _NewsCard({
    required this.news,
    required this.width,
    required this.isMobile,
  });

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
        child: SizedBox(
          width: widget.width,
          height: widget.isMobile ? 150 : 160,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkGray.withValues(alpha: 0.8),
                  AppColors.darkerGray.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'OFFICIAL NEWS',
                        style: AppTextStyles.newsLabel(isHovered: _isHovered),
                      ),
                      Text(
                        widget.news.date,
                        style: AppTextStyles.newsDate,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.news.title,
                        style: AppTextStyles.newsTitle(isHovered: _isHovered),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.news.description,
                        style: AppTextStyles.newsDescription,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final Game game;
  final double? width;
  final bool isMobile;

  const _ProgressCard({
    required this.game,
    this.width,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
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
                      style: AppTextStyles.progressLabel,
                    ),
                    Text(
                      '${game.progress}%',
                      style: AppTextStyles.progressValue,
                    ),
                  ],
                ),
                if (game.earned != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'EARNED',
                        style: AppTextStyles.progressLabel,
                      ),
                      Text(
                        game.earned!,
                        style: AppTextStyles.earnedValue,
                      ),
                    ],
                  ),
              ],
            ),
            if (game.trophies != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (isMobile)
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _TrophyCount(
                        count: game.trophies!.platinum,
                        color: AppColors.trophyPlatinum),
                    _TrophyCount(
                        count: game.trophies!.gold,
                        color: AppColors.trophyGold),
                    _TrophyCount(
                        count: game.trophies!.silver,
                        color: AppColors.trophySilver),
                    _TrophyCount(
                        count: game.trophies!.bronze,
                        color: AppColors.trophyBronze),
                  ],
                )
              else
                Row(
                  children: [
                    _TrophyCount(
                        count: game.trophies!.platinum,
                        color: AppColors.trophyPlatinum),
                    const SizedBox(width: 16),
                    _TrophyCount(
                        count: game.trophies!.gold,
                        color: AppColors.trophyGold),
                    const SizedBox(width: 16),
                    _TrophyCount(
                        count: game.trophies!.silver,
                        color: AppColors.trophySilver),
                    const SizedBox(width: 16),
                    _TrophyCount(
                        count: game.trophies!.bronze,
                        color: AppColors.trophyBronze),
                  ],
                ),
            ],
          ],
        ),
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: child);
    }
    if (isMobile) {
      return child;
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 320),
      child: child,
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
          style: AppTextStyles.trophyCount(color),
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
    final isMobile = Responsive.isMobile(context);
    final cardWidth = isMobile ? 220.0 : 280.0;
    final cardHeight = isMobile ? 124.0 : 157.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured',
          style: AppTextStyles.featuredHeader,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredMedia.length,
            itemBuilder: (context, index) {
              final media = featuredMedia[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _FeaturedMediaCard(
                  media: media,
                  width: cardWidth,
                  height: cardHeight,
                ),
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
  final double width;
  final double height;

  const _FeaturedMediaCard({
    required this.media,
    required this.width,
    required this.height,
  });

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
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: DecoratedBox(
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
                    width: widget.width,
                    height: widget.height,
                    fit: BoxFit.cover,
                    memCacheWidth:
                        560, // Optimize featured media cache (2x for hi-dpi)
                    memCacheHeight: 314,
                    maxWidthDiskCache: 560,
                    maxHeightDiskCache: 314,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    color: _isHovered
                        ? Colors.transparent
                        : Colors.black.withValues(alpha: 0.2),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: CachedNetworkImage(
                          imageUrl: widget.media.serviceLogo,
                          height: 16,
                          color: Colors.white,
                          memCacheHeight: 32, // Optimize service logo cache
                          maxHeightDiskCache: 32,
                        ),
                      ),
                    ),
                  ),
                  if (_isHovered)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: const Text(
                            'WATCH',
                            style: AppTextStyles.featuredWatch,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
