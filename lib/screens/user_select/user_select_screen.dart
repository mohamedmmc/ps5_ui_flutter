import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'user_select_controller.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

class UserSelectScreen extends StatelessWidget {
  static const String routeName = AppRoutes.userSelectName;
  static const String routePath = AppRoutes.userSelect;

  const UserSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserSelectController());

    return _UserSelectScreenView(controller: controller);
  }
}

class _UserSelectScreenView extends StatelessWidget {
  final UserSelectController controller;

  const _UserSelectScreenView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Bar - Time
            Align(
              alignment: Alignment.centerRight,
              child: Obx(() => Text(
                    controller.currentTime.value,
                    style: AppTextStyles.time,
                  )),
            ),

            // Main Content
            FadeTransition(
              opacity: controller.fadeAnimation,
              child: SlideTransition(
                position: controller.slideAnimation,
                child: const Column(
                  children: [
                    // Welcome Text
                    Column(
                      children: [
                        Text(
                          'Welcome Back to PlayStation',
                          style: AppTextStyles.welcomeTitle,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Who's using this controller?",
                          style: AppTextStyles.welcomeSubtitle,
                        ),
                      ],
                    ),

                    SizedBox(height: 48),

                    // User List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Add User Button
                        _AddUserButton(),

                        SizedBox(width: 48),

                        // Current User Profile
                        _UserProfile(),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    LucideIcons.power,
                    color: AppColors.white50,
                  ),
                  iconSize: 24,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddUserButton extends StatefulWidget {
  const _AddUserButton();

  @override
  State<_AddUserButton> createState() => _AddUserButtonState();
}

class _AddUserButtonState extends State<_AddUserButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isHovered ? 1.0 : 0.5,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkGray,
                  border: Border.all(
                    color: _isHovered ? AppColors.white : AppColors.transparent,
                    width: 2,
                  ),
                ),
                transform: _isHovered ? Matrix4.identity().scaled(1.05) : Matrix4.identity(),
                child: const Icon(
                  LucideIcons.plus,
                  color: AppColors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add User',
                style: AppTextStyles.addUserButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserProfile extends StatefulWidget {
  const _UserProfile();

  @override
  State<_UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<_UserProfile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => GoRouter.of(context).go(AppRoutes.dashboard),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 128,
              height: 128,
              transform: _isHovered ? Matrix4.identity().scaled(1.05) : Matrix4.identity(),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isHovered ? AppColors.white : AppColors.transparent,
                  width: 4,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.white.withValues(alpha: 0.3),
                          blurRadius: 30,
                        ),
                      ]
                    : [],
              ),
              child: ClipOval(
                child: Stack(
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: const BoxDecoration(
                        color: AppColors.darkGray,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 64,
                        color: AppColors.white54,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: _isHovered ? AppColors.transparent : AppColors.black.withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'New User',
                  style: AppTextStyles.userName,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.plusBadge,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    'PLUS',
                    style: AppTextStyles.plusBadge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 16,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 1,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Options',
                  style: AppTextStyles.userOptions,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
