import 'dart:ui' show ImageFilter;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../data/games_data.dart';
import '../../models/game.dart';
import '../../utils/hero_tags.dart';
import '../../utils/responsive.dart';
import '../../widgets/top_bar.dart';
import 'dashboard_controller.dart';
import 'games/games_dashboard_panel.dart';
import 'media/media_dashboard_panel.dart';
import 'widgets/playstation_profile_menu.dart';
import 'widgets/playstation_settings_menu.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = AppRoutes.dashboardName;
  static const String routePath = AppRoutes.dashboard;

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(DashboardController());
  }

  @override
  void dispose() {
    Get.delete<DashboardController>();
    super.dispose();
  }

  void _showOverlayMessage(String message) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xEE101520),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _openSettingsMenu() async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Settings Menu',
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, _, __) {
        return PlayStationSettingsMenu(
          onJokeSelected: _showOverlayMessage,
        );
      },
      transitionBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _openProfileMenu() async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Profile Menu',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, _, __) {
        return PlayStationProfileMenu(
          onMessageSelected: _showOverlayMessage,
        );
      },
      transitionBuilder: (context, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  void _launchSelectedGame() {
    if (_controller.activeTab.value != ContentType.game) return;

    context.pushNamed(
      AppRoutes.gameDetailsName,
      pathParameters: {'gameId': _controller.selectedItem.id},
    );
  }

  void _openSelectedMedia() {
    final app = _controller.selectedItem;
    _showOverlayMessage('${app.title} launched. Popcorn sold separately.');
  }

  void _handleSearch() {
    _showOverlayMessage(
        'Search is in stealth mode. It is hiding from feature creep.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                reverseDuration: const Duration(milliseconds: 650),
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                      reverseCurve: Curves.easeInOutCubic,
                    ),
                    child: child,
                  );
                },
                child: Stack(
                  key: ValueKey(_controller.selectedItem.background),
                  fit: StackFit.expand,
                  children: [
                    _DashboardBackground(game: _controller.selectedItem),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 500,
              height: 500,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.blue.withValues(alpha: 0.1),
                      AppColors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller.fadeController,
                curve: Curves.easeOut,
              ),
            ),
            child: Obx(
              () => Stack(
                children: [
                  TopBar(
                    activeTab: _controller.activeTab.value,
                    onTabChange: _controller.handleTabChange,
                    currentTime: _controller.currentTime,
                    onSettingsTap: _openSettingsMenu,
                    onProfileTap: _openProfileMenu,
                    onSearchTap: _handleSearch,
                  ),
                  if (_controller.activeTab.value == ContentType.game)
                    GamesDashboardPanel(
                      games: games,
                      selectedGameId: _controller.selectedGameId.value,
                      selectedGame: _controller.selectedItem,
                      onSelectGame: _controller.handleSelect,
                      onLaunchGame: _launchSelectedGame,
                    )
                  else
                    MediaDashboardPanel(
                      mediaApps: mediaApps,
                      selectedMediaId: _controller.selectedMediaId.value,
                      selectedMedia: _controller.selectedItem,
                      featuredMedia: featuredMedia,
                      onSelectMedia: _controller.handleSelect,
                      onOpenMedia: _openSelectedMedia,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardBackground extends StatelessWidget {
  final Game game;

  const _DashboardBackground({required this.game});

  bool get _isAssetBackground => game.background.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (!_isAssetBackground) {
      return Hero(
        tag: gameBackgroundLaunchHeroTag(game.id),
        transitionOnUserGestures: true,
        child: CachedNetworkImage(
          imageUrl: game.background,
          fit: BoxFit.cover,
          memCacheWidth: 1920,
          memCacheHeight: 1080,
          maxWidthDiskCache: 1920,
          maxHeightDiskCache: 1080,
          placeholder: (context, _) => const ColoredBox(color: AppColors.black),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide * 0.95;

        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.black),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.centerRight,
                  radius: 1.25,
                  colors: [
                    AppColors.blue.withValues(alpha: 0.12),
                    AppColors.black.withValues(alpha: 0.0),
                    AppColors.black,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Transform.translate(
                offset: Offset(constraints.maxWidth * 0.12, 0),
                child: Opacity(
                  opacity: 0.18,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: Responsive.getBlurIntensity(context),
                      sigmaY: Responsive.getBlurIntensity(context),
                    ),
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: Image.asset(
                        game.background,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Transform.translate(
                offset: Offset(
                    constraints.maxWidth * 0.08, constraints.maxHeight * 0.02),
                child: Opacity(
                  opacity: 0.24,
                  child: SizedBox(
                    width: size * 0.62,
                    height: size * 0.62,
                    child: Hero(
                      tag: gameBackgroundLaunchHeroTag(game.id),
                      transitionOnUserGestures: true,
                      child: _DashboardIcon(path: game.background),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DashboardIcon extends StatelessWidget {
  final String path;

  const _DashboardIcon({required this.path});

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.contain,
        memCacheWidth: 400,
        memCacheHeight: 400,
        placeholder: (context, _) => const SizedBox.shrink(),
        errorWidget: (context, _, __) => const SizedBox.shrink(),
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, _, __) => const SizedBox.shrink(),
    );
  }
}
