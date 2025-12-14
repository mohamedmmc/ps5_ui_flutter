import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/game.dart';
import '../../data/games_data.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/game_row.dart';
import '../../widgets/hero_section.dart';
import 'dashboard_controller.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_colors.dart';
import '../../utils/responsive.dart';

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

  @override
  Widget build(BuildContext context) {
    return _DashboardScreenView(controller: _controller);
  }
}

class _DashboardScreenView extends StatelessWidget {
  final DashboardController controller;

  const _DashboardScreenView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Dynamic Background
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
                  // Simplified transition for better performance (removed ScaleTransition)
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
                  key: ValueKey(controller.selectedItem.background),
                  fit: StackFit.expand,
                  children: [
                    _DashboardBackground(game: controller.selectedItem),

                    // Opacity overlay
                    Container(
                      color: AppColors.black.withValues(alpha: 0.2),
                    ),

                    // Gradient overlays for readability
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.black.withValues(alpha: 0.6),
                            AppColors.black.withValues(alpha: 0.2),
                            AppColors.transparent,
                          ],
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.black,
                            AppColors.black.withValues(alpha: 0.1),
                            AppColors.transparent,
                          ],
                          stops: const [0.0, 0.2, 0.5],
                        ),
                      ),
                    ),

                    // Top gradient for top bar visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.black.withValues(alpha: 0.8),
                            AppColors.transparent,
                          ],
                          stops: const [0.0, 0.3],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Decorative glow
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 500,
              height: 500,
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

          // Main UI
          FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: controller.fadeController,
                curve: Curves.easeOut,
              ),
            ),
            child: Obx(() => Stack(
                  children: [
                    // Top Bar
                    TopBar(
                      activeTab: controller.activeTab.value,
                      onTabChange: controller.handleTabChange,
                      currentTime: controller.currentTime,
                    ),

                    // Game Row
                    GameRow(
                      games: controller.currentList,
                      selectedGameId: controller.currentId,
                      onSelectGame: controller.handleSelect,
                    ),

                    // Hero Section
                    HeroSection(
                      game: controller.selectedItem,
                      featuredMedia: controller.activeTab.value == ContentType.media ? featuredMedia : null,
                    ),
                  ],
                )),
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
      return CachedNetworkImage(
        imageUrl: game.background,
        fit: BoxFit.cover,
        memCacheWidth: 1920, // Optimize memory usage
        memCacheHeight: 1080,
        maxWidthDiskCache: 1920,
        maxHeightDiskCache: 1080,
        placeholder: (context, url) => Container(
          color: AppColors.black,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide * 0.95;

        return Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppColors.black),
            Container(
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
                    ), // Responsive blur for better mobile performance
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
                offset: Offset(constraints.maxWidth * 0.08, constraints.maxHeight * 0.02),
                child: Opacity(
                  opacity: 0.24,
                  child: SizedBox(
                    width: size * 0.62,
                    height: size * 0.62,
                    child: _DashboardIcon(path: game.background),
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
        memCacheWidth: 400, // Optimize icon cache
        memCacheHeight: 400,
        placeholder: (context, url) => const SizedBox.shrink(),
        errorWidget: (context, url, error) => const SizedBox.shrink(),
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
