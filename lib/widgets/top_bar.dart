import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/game.dart';
import '../utils/responsive.dart';

class TopBar extends StatelessWidget {
  final ContentType activeTab;
  final ValueChanged<ContentType> onTabChange;
  final RxString currentTime;
  final VoidCallback onSettingsTap;
  final VoidCallback onProfileTap;
  final VoidCallback? onSearchTap;
  final String profileName;

  const TopBar({
    super.key,
    required this.activeTab,
    required this.onTabChange,
    required this.currentTime,
    required this.onSettingsTap,
    required this.onProfileTap,
    this.onSearchTap,
    this.profileName = 'Mohamed Melek',
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
          Row(
            children: [
              if (!isMobile) ...[
                IconButton(
                  icon: const Icon(LucideIcons.search),
                  iconSize: 26,
                  color: Colors.white.withValues(alpha: 0.85),
                  onPressed: onSearchTap,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(LucideIcons.bell),
                  iconSize: 25,
                  color: Colors.white.withValues(alpha: 0.8),
                  onPressed: onSearchTap,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              IconButton(
                icon: const Icon(LucideIcons.settings),
                iconSize: 28,
                color: Colors.white.withValues(alpha: 0.8),
                onPressed: onSettingsTap,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.all(8),
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      profileName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'Level 42 Fullstack Builder',
                      style: TextStyle(
                        color: AppColors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
              ],
              _ProfileAvatar(onTap: onProfileTap),
              const SizedBox(width: 14),
              Obx(
                () => Text(
                  currentTime.value,
                  style: AppTextStyles.dashboardTime(isMobile: isMobile),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final VoidCallback onTap;

  const _ProfileAvatar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: DecoratedBox(
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
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: 12,
              height: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.onlineGreen,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
              ),
            ),
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
          style: AppTextStyles.dashboardTabLabel(
            isActive: widget.isActive,
            isHovered: _isHovered,
            isMobile: widget.isMobile,
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
