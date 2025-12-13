import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/intro_animation_constants.dart';

/// Controller for intro screen animations
///
/// Follows Single Responsibility Principle - only manages animation state
class IntroController extends GetxController with GetSingleTickerProviderStateMixin {
  late final AnimationController pulseController;

  @override
  void onInit() {
    super.onInit();
    pulseController = AnimationController(
      vsync: this,
      duration: IntroAnimationConstants.pulseDuration,
    )..repeat();
  }

  @override
  void onClose() {
    pulseController.dispose();
    super.onClose();
  }
}
