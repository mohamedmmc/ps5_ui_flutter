import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/game.dart';

class GameRow extends StatelessWidget {
  final List<Game> games;
  final String selectedGameId;
  final Function(String) onSelectGame;

  const GameRow({
    super.key,
    required this.games,
    required this.selectedGameId,
    required this.onSelectGame,
  });

  Widget _renderIcon(Game game, bool isSelected) {
    // Handle special string identifiers
    if (game.icon == 'library_icon') {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF27272A),
        child: const Center(
          child: Icon(
            LucideIcons.layoutGrid,
            color: Colors.white,
            size: 32,
          ),
        ),
      );
    }
    if (game.icon == 'tv_icon') {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF27272A),
        child: const Center(
          child: Icon(
            LucideIcons.monitor,
            color: Colors.white,
            size: 32,
          ),
        ),
      );
    }
    if (game.icon == 'music_icon') {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFEF4444),
        child: const Center(
          child: Icon(
            LucideIcons.music,
            color: Colors.white,
            size: 32,
          ),
        ),
      );
    }

    // Handle network images (URLs)
    if (game.icon.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: game.icon,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Container(
          color: Colors.white.withValues(alpha: 0.1),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: const Color(0xFF27272A),
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.white54,
          ),
        ),
      );
    }

    // Handle local asset images
    return Image.asset(
      game.icon,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xFF27272A),
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.white54,
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
    return Positioned(
      top: 120,
      left: 32,
      right: 0,
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: games.length + 1, // +1 for the add button
          itemBuilder: (context, index) {
            if (index == games.length) {
              // Add button
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: _AddButton(),
              );
            }

            final game = games[index];
            final isSelected = selectedGameId == game.id;

            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: _GameCard(
                game: game,
                isSelected: isSelected,
                onTap: () => onSelectGame(game.id),
                renderIcon: _renderIcon,
                parseColor: _parseColor,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GameCard extends StatefulWidget {
  final Game game;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget Function(Game, bool) renderIcon;
  final Color Function(String?) parseColor;

  const _GameCard({
    required this.game,
    required this.isSelected,
    required this.onTap,
    required this.renderIcon,
    required this.parseColor,
  });

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _yAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _sizeAnimation = Tween<double>(
      begin: 90,
      end: 120,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _yAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.isSelected) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_GameCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _yAnimation.value),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: _isHovered ? 1.3 : 1.0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: 1, // widget.isSelected || _isHovered ? _opacityAnimation.value : 0.7,
                  child: Container(
                    width: 150,
                    height: _sizeAnimation.value,
                    decoration: BoxDecoration(
                      color: widget.parseColor(widget.game.iconBgColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        // Icon content
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: widget.renderIcon(widget.game, widget.isSelected),
                        ),

                        // Selection border
                        if (widget.isSelected)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
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

class _AddButton extends StatefulWidget {
  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Icon(
              LucideIcons.plus,
              color: Colors.white.withValues(alpha: 0.5),
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
