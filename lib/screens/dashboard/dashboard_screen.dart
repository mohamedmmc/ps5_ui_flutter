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

class DashboardScreen extends StatelessWidget {
  static const String routeName = AppRoutes.dashboardName;
  static const String routePath = AppRoutes.dashboard;

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return _DashboardScreenView(controller: controller);
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
            child: Obx(() => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 700),
                  child: Stack(
                    key: ValueKey(controller.selectedItem.background),
                    children: [
                      // Background Image
                      CachedNetworkImage(
                        imageUrl: controller.selectedItem.background,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.black,
                        ),
                      ),

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
                )),
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
                    ),

                    // Game Row
                    GameRow(
                      games: controller.currentList,
                      selectedGameId: controller.currentId,
                      onSelectGame: controller.handleSelect,
                    ),

                    // Hero Section
                    HeroSection(
                      key: ValueKey(controller.selectedItem.id),
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
