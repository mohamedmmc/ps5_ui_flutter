import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ps5_ui_flutter/models/particle.dart';
import '../../constants/intro_animation_constants.dart';
import '../../constants/intro_visual_constants.dart';
import '../../utils/particle_generator.dart';

/// Controller for intro screen animations
///
/// Follows Single Responsibility Principle - only manages animation state
/// Delegates particle generation to ParticleGenerator utility
class IntroController extends GetxController with GetTickerProviderStateMixin {
  late final AnimationController pulseController;
  late final AnimationController lightBeamController;
  late final AnimationController rotationController;
  late final AnimationController fadeController;
  late final AnimationController particleController;

  late final List<Particle> particles;
  late final ParticleGenerator _particleGenerator;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimationControllers();
    _initializeParticles();
  }

  /// Initializes all animation controllers with predefined durations
  void _initializeAnimationControllers() {
    pulseController = AnimationController(
      vsync: this,
      duration: IntroAnimationConstants.pulseDuration,
    )..repeat();

    lightBeamController = AnimationController(
      vsync: this,
      duration: IntroAnimationConstants.lightBeamDuration,
    )..repeat();

    rotationController = AnimationController(
      vsync: this,
      duration: IntroAnimationConstants.rotationDuration,
    )..repeat();

    fadeController = AnimationController(
      vsync: this,
      duration: IntroAnimationConstants.fadeDuration,
    );

    particleController = AnimationController(
      vsync: this,
      duration: IntroAnimationConstants.particleDuration,
    )..repeat();

    fadeController.forward();
  }

  /// Initializes particle system using ParticleGenerator
  void _initializeParticles() {
    _particleGenerator = ParticleGenerator();
    particles = _particleGenerator.generateParticles(
      IntroVisualConstants.particleCount,
    );
  }

  @override
  void onClose() {
    pulseController.dispose();
    rotationController.dispose();
    fadeController.dispose();
    particleController.dispose();
    lightBeamController.dispose();
    super.onClose();
  }
}
