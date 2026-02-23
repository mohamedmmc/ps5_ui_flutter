import 'package:flutter/material.dart';
import 'package:ps5_ui_flutter/models/particle.dart';
import 'painters/particle_painter.dart';

/// Widget wrapper for particle system animation
///
/// Follows Single Responsibility Principle - only handles particle rendering
class ParticleSystemWidget extends StatelessWidget {
  final AnimationController particleController;
  final List<Particle> particles;

  const ParticleSystemWidget({
    super.key,
    required this.particleController,
    required this.particles,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(
        particles: particles,
        animation: particleController,
      ),
      isComplex: true,
      willChange: true,
    );
  }
}
