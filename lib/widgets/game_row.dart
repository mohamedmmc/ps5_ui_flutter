import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../models/game.dart';
import '../utils/responsive.dart';

class GameRow extends StatelessWidget {
  final List<Game> games;
  final String selectedGameId;
  final Function(String) onSelectGame;
  final Object? switchKey;

  const GameRow({
    super.key,
    required this.games,
    required this.selectedGameId,
    required this.onSelectGame,
    this.switchKey,
  });

  Widget _renderIcon(Game game, bool isSelected, bool isMobile) {
    // Handle special string identifiers
    if (game.icon == 'library_icon') {
      return ColoredBox(
        color: AppColors.darkGray,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Icon(
              LucideIcons.layoutGrid,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      );
    }
    if (game.icon == 'tv_icon') {
      return ColoredBox(
        color: AppColors.darkGray,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: const Center(
            child: Icon(
              LucideIcons.monitor,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      );
    }
    if (game.icon == 'music_icon') {
      return ColoredBox(
        color: AppColors.red,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: const Center(
            child: Icon(
              LucideIcons.music,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      );
    }

    final padding = isMobile ? const EdgeInsets.all(10) : EdgeInsets.zero;
    final fit = isMobile ? BoxFit.contain : BoxFit.cover;

    // Handle network images (URLs)
    if (game.icon.startsWith('http')) {
      return Padding(
        padding: padding,
        child: CachedNetworkImage(
          imageUrl: game.icon,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
          memCacheWidth: 300, // Optimize game icon cache
          memCacheHeight: 240,
          maxWidthDiskCache: 300,
          maxHeightDiskCache: 240,
          placeholder: (context, url) => ColoredBox(
            color: Colors.white.withValues(alpha: 0.1),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => ColoredBox(
            color: AppColors.darkGray,
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.white54,
            ),
          ),
        ),
      );
    }

    // Handle local asset images
    return Padding(
      padding: padding,
      child: Image.asset(
        game.icon,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => ColoredBox(
          color: AppColors.darkGray,
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }

  Color _parseColor(String? colorString) {
    if (colorString == null) return Colors.transparent;

    try {
      String hexColor = colorString.replaceFirst('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final topPosition = isMobile ? 80.0 : 120.0;
    final leftPadding = isMobile ? 16.0 : 32.0;
    final cardHeight = isMobile ? 100.0 : 150.0;

    return Positioned(
      top: topPosition,
      left: leftPadding,
      right: 0,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        reverseDuration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeInCubic,
        switchOutCurve: Curves.easeOutCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInCubic,
              reverseCurve: Curves.easeOutCubic,
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.02, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInCubic,
                  reverseCurve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(switchKey ?? 'default'),
          child: SizedBox(
            height: cardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: games.length + 1, // +1 for the add button
              itemBuilder: (context, index) {
                if (index == games.length) {
                  // Add button
                  return Padding(
                    padding: EdgeInsets.only(right: isMobile ? 12 : 20),
                    child: _AddButton(isMobile: isMobile),
                  );
                }

                final game = games[index];
                final isSelected = selectedGameId == game.id;

                return Padding(
                  padding: EdgeInsets.only(right: isMobile ? 12 : 20),
                  child: _GameCard(
                    game: game,
                    isSelected: isSelected,
                    onTap: () => onSelectGame(game.id),
                    renderIcon: _renderIcon,
                    parseColor: _parseColor,
                    isMobile: isMobile,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatefulWidget {
  final Game game;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget Function(Game, bool, bool) renderIcon;
  final Color Function(String?) parseColor;
  final bool isMobile;

  const _GameCard({
    required this.game,
    required this.isSelected,
    required this.onTap,
    required this.renderIcon,
    required this.parseColor,
    this.isMobile = false,
  });

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> {
  bool _isHovered = false;
  late final Color _bgColor;

  @override
  void initState() {
    super.initState();
    // Memoize color parsing for better performance
    _bgColor = widget.parseColor(widget.game.iconBgColor);
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = widget.isMobile ? 100.0 : 150.0;
    final cardHeight = widget.isMobile ? 80.0 : 120.0;
    final isActive = widget.isSelected || _isHovered;
    final scale = widget.isSelected ? 1.12 : (_isHovered ? 1.06 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOutCubic,
          scale: scale,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            opacity: widget.isSelected ? 1.0 : (_isHovered ? 0.92 : 0.72),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _bgColor, // Using memoized color for better performance
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: widget.renderIcon(
                        widget.game,
                        widget.isSelected,
                        widget.isMobile,
                      ),
                    ),
                    if (isActive)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(
                                alpha: widget.isSelected ? 0.9 : 0.35),
                            width: widget.isSelected ? 3 : 2,
                          ),
                          boxShadow: widget.isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    blurRadius: 18,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatefulWidget {
  final bool isMobile;

  const _AddButton({this.isMobile = false});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final buttonWidth = widget.isMobile ? 100.0 : 150.0;
    final buttonHeight = widget.isMobile ? 60.0 : 90.0;
    final iconSize = widget.isMobile ? 24.0 : 32.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: buttonWidth,
          height: buttonHeight,
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Icon(
              LucideIcons.plus,
              color: Colors.white.withValues(alpha: 0.5),
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
