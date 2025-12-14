import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/game.dart';
import '../utils/responsive.dart';

class TopBar extends StatelessWidget {
  final ContentType activeTab;
  final ValueChanged<ContentType> onTabChange;
  final RxString currentTime;

  const TopBar({
    super.key,
    required this.activeTab,
    required this.onTabChange,
    required this.currentTime,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 16.0 : 32.0;
    final spacing = isMobile ? 16.0 : 32.0;

    return Positioned(
      top: padding,
      left: padding,
      right: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tabs
          Row(
            children: [
              _TabButton(
                label: 'Games',
                isActive: activeTab == ContentType.game,
                onTap: () => onTabChange(ContentType.game),
                isMobile: isMobile,
              ),
              SizedBox(width: spacing),
              _TabButton(
                label: 'Media',
                isActive: activeTab == ContentType.media,
                onTap: () => onTabChange(ContentType.media),
                isMobile: isMobile,
              ),
            ],
          ),

          // Right Side - Icons and Time (hide search/settings on mobile)
          Row(
            children: [
              if (!isMobile) ...[
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
              ],

              // User Avatar
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/mmc2.jpg'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 2,
                      ),
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
              Obx(
                () => Text(
                  currentTime.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 16 : 24,
                    fontWeight: FontWeight.w300,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
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
  final bool isMobile;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isMobile = false,
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
            fontSize: widget.isMobile ? 20 : 28, // Responsive font size
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
