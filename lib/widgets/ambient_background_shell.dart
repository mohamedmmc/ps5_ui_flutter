import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/intro_animation_constants.dart';
import '../constants/intro_visual_constants.dart';
import '../models/particle.dart';
import '../utils/particle_generator.dart';
import 'light_beam_widget.dart';
import 'particle_system_widget.dart';

class AmbientBackgroundShell extends StatefulWidget {
  final Widget child;
  final Duration switchDuration;
  final Curve switchCurve;
  final Offset switchSlideBeginOffset;

  const AmbientBackgroundShell({
    super.key,
    required this.child,
    this.switchDuration = const Duration(milliseconds: 650),
    this.switchCurve = Curves.easeInOutCubic,
    this.switchSlideBeginOffset = const Offset(0, 0.02),
  });

  @override
  State<AmbientBackgroundShell> createState() => _AmbientBackgroundShellState();
}

class _AmbientBackgroundShellState extends State<AmbientBackgroundShell> with TickerProviderStateMixin {
  late final AnimationController _lightBeamController;
  late final AnimationController _particleController;
  late final List<Particle> _particles;

  final ParticleGenerator _particleGenerator = ParticleGenerator();

  @override
  void initState() {
    super.initState();
    _lightBeamController = AnimationController(
      vsync: this,
      duration: IntroAnimationConstants.lightBeamDuration,
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: IntroAnimationConstants.particleDuration,
    )..repeat();

    _particles = _particleGenerator.generateParticles(IntroVisualConstants.particleCount);
  }

  @override
  void dispose() {
    _lightBeamController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return ColoredBox(
      color: IntroVisualConstants.backgroundColor,
      child: Stack(
        children: [
          Positioned.fill(
            child: LightBeamWidget(
              lightBeamController: _lightBeamController,
            ),
          ),
          Positioned(
            top: -screenSize.height * 0.2,
            left: -screenSize.width * 0.1,
            child: Container(
              width: screenSize.width,
              height: screenSize.width,
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
          Positioned.fill(
            child: ParticleSystemWidget(
              particleController: _particleController,
              particles: _particles,
            ),
          ),
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: widget.switchDuration,
              reverseDuration: widget.switchDuration,
              switchInCurve: widget.switchCurve,
              switchOutCurve: widget.switchCurve,
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
                final isCurrentChild = child.key == widget.child.key;

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: widget.switchSlideBeginOffset,
                      end: Offset.zero,
                    ).animate(animation),
                    child: IgnorePointer(
                      ignoring: !isCurrentChild,
                      child: child,
                    ),
                  ),
                );
              },
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

