import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class PlayStationSettingsMenu extends StatefulWidget {
  final ValueChanged<String> onJokeSelected;

  const PlayStationSettingsMenu({
    super.key,
    required this.onJokeSelected,
  });

  @override
  State<PlayStationSettingsMenu> createState() =>
      _PlayStationSettingsMenuState();
}

class _PlayStationSettingsMenuState extends State<PlayStationSettingsMenu> {
  int _activeIndex = 0;

  static const List<_SettingsEntry> _entries = [
    _SettingsEntry(
      icon: Icons.menu_book_rounded,
      title: "User's Guide, Health and Safety, and Other Information",
      joke:
          'Congrats, you opened the guide. Step 1: pretend this was always obvious.',
    ),
    _SettingsEntry(
      icon: Icons.accessibility_new_rounded,
      title: 'Accessibility',
      joke: 'Accessibility unlocked. Your keyboard can now hear your sighs.',
    ),
    _SettingsEntry(
      icon: Icons.language_rounded,
      title: 'Network',
      joke: 'Network is stable. Your Wi-Fi still blames Mercury retrograde.',
    ),
    _SettingsEntry(
      icon: Icons.person_outline_rounded,
      title: 'Users and Accounts',
      joke:
          'You found accounts. Nice. Still only one of you doing all the work though.',
    ),
    _SettingsEntry(
      icon: Icons.family_restroom_rounded,
      title: 'Family and Parental Controls',
      joke:
          'Parental controls enabled. I just emailed your mom about your screen time.',
    ),
    _SettingsEntry(
      icon: Icons.widgets_outlined,
      title: 'System',
      joke: 'System check complete: 12 tabs open, 11 existential.',
    ),
    _SettingsEntry(
      icon: Icons.sd_storage_rounded,
      title: 'Storage',
      joke:
          'You really thought a website would have storage? That is adorable.',
    ),
    _SettingsEntry(
      icon: Icons.volume_up_rounded,
      title: 'Sound',
      joke: 'Volume maxed. Neighbors are now part of your QA team.',
    ),
    _SettingsEntry(
      icon: Icons.tv_rounded,
      title: 'Screen and Video',
      joke: 'HDR activated. Bugs now render in cinematic quality.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 900;

    return Material(
      color: AppColors.black.withValues(alpha: 0.65),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isNarrow ? 16 : 24, vertical: isNarrow ? 16 : 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xCC242933),
                      const Color(0xDD11151F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isNarrow ? 16 : 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isNarrow ? 34 : 42,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _entries.length,
                          separatorBuilder: (_, __) => Divider(
                            color: Colors.white.withValues(alpha: 0.08),
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            final entry = _entries[index];
                            final isSelected = index == _activeIndex;

                            return MouseRegion(
                              onEnter: (_) =>
                                  setState(() => _activeIndex = index),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  widget.onJokeSelected(entry.joke);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isNarrow ? 10 : 14,
                                    vertical: isNarrow ? 14 : 16,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white.withValues(alpha: 0.65)
                                          : Colors.transparent,
                                      width: isSelected ? 1.2 : 0,
                                    ),
                                    color: isSelected
                                        ? Colors.white.withValues(alpha: 0.06)
                                        : Colors.transparent,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        entry.icon,
                                        color:
                                            Colors.white.withValues(alpha: 0.9),
                                        size: isNarrow ? 22 : 24,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          entry.title,
                                          style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.92),
                                            fontSize: isNarrow ? 20 : 24,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsEntry {
  final IconData icon;
  final String title;
  final String joke;

  const _SettingsEntry({
    required this.icon,
    required this.title,
    required this.joke,
  });
}
