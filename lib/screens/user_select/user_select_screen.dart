import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'user_select_controller.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/user_profile.dart';
import '../../utils/responsive.dart';

class UserSelectScreen extends StatefulWidget {
  static const String routeName = AppRoutes.userSelectName;
  static const String routePath = AppRoutes.userSelect;

  const UserSelectScreen({super.key});

  @override
  State<UserSelectScreen> createState() => _UserSelectScreenState();
}

class _UserSelectScreenState extends State<UserSelectScreen> {
  late final UserSelectController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(UserSelectController());
  }

  @override
  void dispose() {
    Get.delete<UserSelectController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _UserSelectScreenView(controller: _controller);
  }
}

class _UserSelectScreenView extends StatelessWidget {
  final UserSelectController controller;

  const _UserSelectScreenView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 16.0 : 48.0;
    final spacing = isMobile ? 24.0 : 48.0;

    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Obx(() => Text(
                    controller.currentTime.value,
                    style: AppTextStyles.time.copyWith(
                      fontSize: isMobile ? 16 : 24,
                    ),
                  )),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Welcome Back to PlayStation',
                        style: AppTextStyles.welcomeTitle.copyWith(
                          fontSize: isMobile ? 20 : 32,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isMobile ? 4 : 8),
                      Text(
                        "Who's using this controller?",
                        style: AppTextStyles.welcomeSubtitle.copyWith(
                          fontSize: isMobile ? 14 : 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),
                  // Carousel with Add User button integrated
                  const _UserProfilesCarousel(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    LucideIcons.power,
                    color: AppColors.white50,
                  ),
                  iconSize: isMobile ? 20 : 24,
                  onPressed: () => GoRouter.of(context).go(AppRoutes.intro),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfilesCarousel extends StatefulWidget {
  const _UserProfilesCarousel();

  @override
  State<_UserProfilesCarousel> createState() => _UserProfilesCarouselState();
}

class _UserProfilesCarouselState extends State<_UserProfilesCarousel> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _enterController;
  late final FocusNode _focusNode;

  int _activeIndex = 1; // Start at index 1 (MMC)
  int? _hoveredIndex;

  final List<UserProfile> _profiles = const [
    UserProfile(
      name: 'Add User',
      isAddButton: true,
    ),
    UserProfile(
      name: 'MMC',
      avatarAssetPath: 'assets/images/mmc2.jpg',
    ),
    UserProfile(name: 'Guest 1'),
    UserProfile(name: 'Guest 2'),
    UserProfile(name: 'Guest 3'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();

    _focusNode = FocusNode(debugLabel: 'UserSelectCarousel');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
        _scrollToIndex(_activeIndex, animate: false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _enterController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  double _stagger(int index) {
    final t = _enterController.value;
    final start = 0.05 * index;
    final raw = ((t - start) / (1.0 - start)).clamp(0.0, 1.0);
    return Curves.easeOutCubic.transform(raw);
  }

  void _scrollToIndex(int index, {bool animate = true}) {
    if (!_scrollController.hasClients) return;

    final isMobile = Responsive.isMobile(context);
    final cardWidth = isMobile ? 140.0 : 180.0;
    final spacing = isMobile ? 16.0 : 24.0;
    final itemWidth = cardWidth + spacing;

    // Calculate offset to center the selected item
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = (index * itemWidth) - (screenWidth / 2) + (cardWidth / 2);
    final maxScroll = _scrollController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxScroll);

    if (animate) {
      _scrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    } else {
      _scrollController.jumpTo(clampedOffset);
    }
  }

  void _moveCursor(int direction) {
    if (direction == 0) return;

    final nextIndex = (_activeIndex + direction).clamp(0, _profiles.length - 1).toInt();
    if (nextIndex == _activeIndex) return;

    setState(() => _activeIndex = nextIndex);
    _scrollToIndex(nextIndex);
  }

  void _setActiveIndex(int index) {
    final nextIndex = index.clamp(0, _profiles.length - 1).toInt();
    if (nextIndex == _activeIndex) return;

    setState(() => _activeIndex = nextIndex);
    _scrollToIndex(nextIndex);
  }

  void _activate(BuildContext context) {
    final activeProfile = _profiles[_activeIndex];
    // Don't navigate if it's the add button or not MMC
    if (activeProfile.isAddButton) return;
    if (activeProfile.name != 'MMC') return;
    GoRouter.of(context).go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Larger cards for desktop, smaller for mobile
    final cardWidth = isMobile ? 140.0 : 220.0;
    final cardHeight = isMobile ? 200.0 : 280.0;
    final spacing = isMobile ? 16.0 : 32.0;

    return SizedBox(
      width: screenWidth,
      height: cardHeight,
      child: Focus(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is! KeyDownEvent) return KeyEventResult.ignored;

          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _moveCursor(1);
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _moveCursor(-1);
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.select || event.logicalKey == LogicalKeyboardKey.space) {
            _activate(context);
            return KeyEventResult.handled;
          }

          return KeyEventResult.ignored;
        },
        child: AnimatedBuilder(
          animation: _enterController,
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
                scrollbars: false,
              ),
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                // padding: EdgeInsets.symmetric(horizontal: screenWidth / 2 - cardWidth / 2),
                itemCount: _profiles.length,
                itemBuilder: (context, index) {
                  final entry = _stagger(index);
                  final isActive = index == _activeIndex;
                  final isHovered = index == _hoveredIndex;

                  // Entry animation
                  final entryOffsetX = (1.0 - entry) * (100 + (index * 30));
                  final entryOpacity = 0.25 + (0.75 * entry);

                  // Calculate opacity based on distance from center
                  double distanceOpacity = 1.0;
                  if (_scrollController.hasClients) {
                    final scrollCenter = _scrollController.offset + (screenWidth / 2);
                    final itemCenter = (index * (cardWidth + spacing)) + (cardWidth / 2);
                    final distance = (scrollCenter - itemCenter).abs();
                    final maxDistance = screenWidth / 2;

                    if (distance > cardWidth / 2) {
                      final fadeDistance = distance - (cardWidth / 2);
                      distanceOpacity = (1.0 - (fadeDistance / maxDistance)).clamp(0.15, 1.0);
                    }
                  }

                  final effectiveOpacity = (isActive ? 1.0 : distanceOpacity) * entryOpacity;

                  return Padding(
                    padding: EdgeInsets.only(right: spacing),
                    child: Transform.translate(
                      offset: Offset(entryOffsetX, 0),
                      child: Opacity(
                        opacity: effectiveOpacity.clamp(0.0, 1.0),
                        child: _UserProfileCard(
                          profile: _profiles[index],
                          isActive: isActive,
                          isHovered: isHovered,
                          cardWidth: cardWidth,
                          cardHeight: cardHeight,
                          onHoverChanged: (hovered) {
                            setState(() => _hoveredIndex = hovered ? index : null);
                          },
                          onTap: () {
                            if (_activeIndex != index) {
                              _setActiveIndex(index);
                              return;
                            }
                            _activate(context);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  final UserProfile profile;
  final bool isActive;
  final bool isHovered;
  final VoidCallback onTap;
  final ValueChanged<bool> onHoverChanged;
  final double cardWidth;
  final double cardHeight;

  const _UserProfileCard({
    required this.profile,
    required this.isActive,
    required this.isHovered,
    required this.onTap,
    required this.onHoverChanged,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final scale = (isActive ? 1.12 : 1.0) * (isHovered ? 1.06 : 1.0);
    final borderColor = (isHovered || isActive) ? AppColors.white : AppColors.transparent;
    final shadowOpacity = isHovered || isActive ? 0.25 : 0.0;
    final avatarSize = isMobile ? 120.0 : 190.0;

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.white.withValues(alpha: shadowOpacity),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _UserAvatar(
                        name: profile.name,
                        avatarAssetPath: profile.avatarAssetPath,
                        isAddButton: profile.isAddButton,
                      ),
                      if (!profile.isAddButton)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          color: isHovered ? AppColors.transparent : AppColors.black.withValues(alpha: 0.25),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: isMobile ? 12 : 20),
            Text(
              profile.name,
              style: AppTextStyles.userName.copyWith(
                fontSize: isMobile ? 16 : 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String name;
  final String? avatarAssetPath;
  final bool isAddButton;

  const _UserAvatar({
    required this.name,
    required this.avatarAssetPath,
    this.isAddButton = false,
  });

  @override
  Widget build(BuildContext context) {
    // Render Add User button
    if (isAddButton) {
      final isMobile = Responsive.isMobile(context);
      final iconSize = isMobile ? 48.0 : 80.0;

      return ColoredBox(
        color: AppColors.darkGray,
        child: Center(
          child: Icon(
            LucideIcons.plus,
            color: AppColors.white,
            size: iconSize,
          ),
        ),
      );
    }

    if (avatarAssetPath != null) {
      return Image.asset(
        avatarAssetPath!,
        fit: BoxFit.cover,
      );
    }

    final isMobile = Responsive.isMobile(context);
    final initials = name.trim().isEmpty ? '?' : name.trim().split(RegExp(r'\\s+')).where((s) => s.isNotEmpty).take(2).map((s) => s.characters.first.toUpperCase()).join();

    final hue = (name.codeUnits.fold<int>(0, (sum, c) => sum + c) % 360).toDouble();
    final color = HSLColor.fromAHSL(1.0, hue, 0.35, 0.32).toColor();

    return ColoredBox(
      color: color,
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.userInitials(isMobile: isMobile),
        ),
      ),
    );
  }
}
