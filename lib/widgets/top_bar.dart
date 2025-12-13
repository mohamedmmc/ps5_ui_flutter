import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/game.dart';
import 'dart:async';

class TopBar extends StatefulWidget {
  final ContentType activeTab;
  final Function(ContentType) onTabChange;

  const TopBar({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  String currentTime = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    setState(() {
      currentTime = '$hour:$minute';
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 32,
      left: 32,
      right: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tabs
          Row(
            children: [
              _TabButton(
                label: 'Games',
                isActive: widget.activeTab == ContentType.game,
                onTap: () => widget.onTabChange(ContentType.game),
              ),
              const SizedBox(width: 32),
              _TabButton(
                label: 'Media',
                isActive: widget.activeTab == ContentType.media,
                onTap: () => widget.onTabChange(ContentType.media),
              ),
            ],
          ),

          // Right Side - Icons and Time
          Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.search),
                iconSize: 28,
                color: Colors.white.withValues(alpha: 0.8),
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(LucideIcons.settings),
                iconSize: 28,
                color: Colors.white.withValues(alpha: 0.8),
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(width: 16),

              // User Avatar
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF3B82F6), Color(0xFF9333EA)],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // Time
              Text(
                currentTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: widget.isActive ? Colors.white : (_isHovered ? Colors.white.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.5)),
            fontSize: 28,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.5,
            shadows: widget.isActive
                ? [
                    const Shadow(
                      color: Colors.white,
                      blurRadius: 10,
                    ),
                  ]
                : [],
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: widget.isActive ? 1.1 : 1.0,
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
