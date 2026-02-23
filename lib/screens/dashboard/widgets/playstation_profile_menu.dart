import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class PlayStationProfileMenu extends StatefulWidget {
  final ValueChanged<String> onMessageSelected;

  const PlayStationProfileMenu({
    super.key,
    required this.onMessageSelected,
  });

  @override
  State<PlayStationProfileMenu> createState() => _PlayStationProfileMenuState();
}

class _PlayStationProfileMenuState extends State<PlayStationProfileMenu> {
  int _hoveredIndex = -1;

  static const List<_ProfileAction> _actions = [
    _ProfileAction(
      icon: Icons.badge_outlined,
      title: 'View Profile',
      subtitle: 'See your activity and portfolio trophies',
      message: 'Profile opened. Confidence level: dangerously employable.',
    ),
    _ProfileAction(
      icon: Icons.circle,
      title: 'Online Status',
      subtitle: 'Set yourself to online, away, or "debug mode"',
      message: 'Status changed to "Online". Social battery still loading.',
    ),
    _ProfileAction(
      icon: Icons.emoji_events_outlined,
      title: 'Trophies',
      subtitle: 'Track completed projects and milestones',
      message: 'Trophy sync complete: shipping on Friday counted as legendary.',
    ),
    _ProfileAction(
      icon: Icons.switch_account_outlined,
      title: 'Switch User',
      subtitle: 'Swap to another profile',
      message: 'Switch user clicked. Sadly, the bugs switched with you.',
    ),
    _ProfileAction(
      icon: Icons.logout_rounded,
      title: 'Log Out',
      subtitle: 'Leave this PS-style dashboard',
      message: 'You logged out emotionally. Technically you are still here.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final topOffset = MediaQuery.of(context).size.width < 900 ? 76.0 : 94.0;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: ColoredBox(color: Colors.black.withValues(alpha: 0.35)),
            ),
          ),
          Positioned(
            top: topOffset,
            right: 24,
            child: _ProfilePanel(
              hoveredIndex: _hoveredIndex,
              onHover: (index) => setState(() => _hoveredIndex = index),
              onSelect: (message) {
                Navigator.of(context).pop();
                widget.onMessageSelected(message);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePanel extends StatelessWidget {
  final int hoveredIndex;
  final ValueChanged<int> onHover;
  final ValueChanged<String> onSelect;

  const _ProfilePanel({
    required this.hoveredIndex,
    required this.onHover,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xEE11151F),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.16),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/mmc2.jpg'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mohamed Melek',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Level 42 Fullstack Builder',
                          style: TextStyle(
                            color: AppColors.white60,
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...List.generate(_PlayStationProfileMenuState._actions.length,
                  (index) {
                final action = _PlayStationProfileMenuState._actions[index];
                final isHovered = hoveredIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MouseRegion(
                    onEnter: (_) => onHover(index),
                    onExit: (_) => onHover(-1),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onSelect(action.message),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 11),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isHovered
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.transparent,
                          border: Border.all(
                            color: isHovered
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              action.icon,
                              size: 20,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    action.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    action.subtitle,
                                    style: const TextStyle(
                                      color: AppColors.white60,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
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
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final String message;

  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.message,
  });
}
