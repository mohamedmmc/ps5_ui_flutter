import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ps5_ui_flutter/constants/app_colors.dart';
import 'package:ps5_ui_flutter/constants/app_text_styles.dart';
import 'intro_controller.dart';
import '../../widgets/light_beam_widget.dart';
import '../../widgets/particle_system_widget.dart';
import '../../widgets/pulsing_play_button.dart';
import '../../constants/intro_visual_constants.dart';
import '../../constants/intro_animation_constants.dart';
import '../../constants/app_routes.dart';

class IntroScreen extends StatelessWidget {
  static const String routeName = AppRoutes.introName;
  static const String routePath = AppRoutes.intro;

  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IntroController());

    return _IntroScreenView(controller: controller);
  }
}

class _IntroScreenView extends StatelessWidget {
  final IntroController controller;

  const _IntroScreenView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).go(AppRoutes.userSelect),
      child: Container(
        color: IntroVisualConstants.backgroundColor,
        child: Stack(
          children: [
            // Nouvelle couche: Effet de lumière depuis le haut
            Positioned.fill(
              child: LightBeamWidget(
                lightBeamController: controller.lightBeamController,
              ),
            ),

            // Layer 2: Golden diffuse glow
            Positioned(
              top: -MediaQuery.of(context).size.height * 0.2,
              left: -MediaQuery.of(context).size.width * 0.1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.golden.withValues(alpha: 0.15),
                      AppColors.transparent,
                    ],
                    stops: const [0.0, 0.6],
                  ),
                ),
              ),
            ),

            // Layer 3.5: Floating Particles
            Positioned.fill(
              child: ParticleSystemWidget(
                particleController: controller.particleController,
                particles: controller.particles,
              ),
            ),

            // Layer 4: UI Content
            FadeTransition(
              opacity: controller.fadeController,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Instruction text
                    Spacer(),
                    Text(
                      'Press the PS button on your controller.',
                      style: AppTextStyles.introInstruction,
                    ),
                    Spacer(),
                    // PS Button with pulsing animation
                    PulsingPlayButton(
                      pulseAnimation: controller.pulseController,
                      cycleDuration: controller.pulseController.duration ?? IntroAnimationConstants.pulseDuration,
                      size: 200,
                      logoSize: 128,
                      color: AppColors.white,
                    ),
                    Spacer(),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
