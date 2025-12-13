import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ps5_ui_flutter/constants/app_colors.dart';
import 'package:ps5_ui_flutter/constants/app_text_styles.dart';
import 'intro_controller.dart';
import '../../widgets/pulsing_play_button.dart';
import '../../constants/intro_animation_constants.dart';
import '../../constants/app_routes.dart';

class IntroScreen extends StatefulWidget {
  static const String routeName = AppRoutes.introName;
  static const String routePath = AppRoutes.intro;

  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late final IntroController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(IntroController());
  }

  @override
  void dispose() {
    Get.delete<IntroController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _IntroScreenView(controller: _controller);
  }
}

class _IntroScreenView extends StatelessWidget {
  final IntroController controller;

  const _IntroScreenView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => GoRouter.of(context).go(AppRoutes.userSelect),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'Press the PS button on your controller.',
              style: AppTextStyles.introInstruction,
            ),
            const Spacer(),
            PulsingPlayButton(
              pulseAnimation: controller.pulseController,
              cycleDuration: controller.pulseController.duration ?? IntroAnimationConstants.pulseDuration,
              size: 200,
              logoSize: 128,
              color: AppColors.white,
            ),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
