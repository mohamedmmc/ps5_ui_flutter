import 'package:flutter/material.dart';
import 'package:ps5_ui_flutter/models/particle.dart';
import 'dart:math' as math;
import '../../constants/intro_visual_constants.dart';
import '../../constants/intro_layout_constants.dart';
import '../../utils/particle_generator.dart';

/// Custom painter for rendering particle effects
///
/// Follows Single Responsibility Principle - only handles particle painting
/// Delegates particle repositioning to ParticleGenerator
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final ParticleGenerator particleGenerator;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
    ParticleGenerator? particleGenerator,
  }) : particleGenerator = particleGenerator ?? ParticleGenerator();

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      _updateParticlePosition(particle);
      _paintParticle(canvas, size, particle);
    }
  }

  /// Updates particle position and repositions if out of bounds
  void _updateParticlePosition(Particle particle) {
    // Move particle
    particle.x += particle.velocityX * IntroLayoutConstants.particleMovementIncrement;
    particle.y += particle.velocityY * IntroLayoutConstants.particleMovementIncrement;

    // Check bounds and reposition if necessary
    if (_isParticleOutOfBounds(particle)) {
      if (math.Random().nextDouble() < IntroVisualConstants.particleRepositionProbability) {
        particleGenerator.repositionParticle(particle);
      }
    }
  }

  /// Checks if particle is outside defined boundaries
  bool _isParticleOutOfBounds(Particle particle) {
    return particle.x < IntroLayoutConstants.particleBoundaryMinX ||
        particle.x > IntroLayoutConstants.particleBoundaryMaxX ||
        particle.y < IntroLayoutConstants.particleBoundaryMinY ||
        particle.y > IntroLayoutConstants.particleBoundaryMaxY;
  }

  /// Paints a single particle with sparkle animation
  void _paintParticle(Canvas canvas, Size size, Particle particle) {
    final dx = particle.x * size.width;
    final dy = particle.y * size.height;

    // Calculate sparkle effect
    final sparkle = (math.sin(animationValue * 2 * math.pi * particle.sparkleSpeed + particle.sparklePhase) + 1) / 2;

    // Apply sparkle to opacity and size
    final sparkleOpacity = particle.opacity * (IntroVisualConstants.sparkleOpacityMin + sparkle * IntroVisualConstants.sparkleOpacityRange);
    final sparkleSize = particle.size * (IntroVisualConstants.sparkleSizeMin + sparkle * IntroVisualConstants.sparkleSizeRange);

    // Render based on particle type
    if (particle.isSharp) {
      _paintSharpParticle(canvas, dx, dy, sparkleSize, sparkleOpacity, particle);
    } else {
      _paintBlurryParticle(canvas, dx, dy, sparkleSize, sparkleOpacity, particle, sparkle);
    }
  }

  /// Paints a sharp particle without blur
  void _paintSharpParticle(Canvas canvas, double dx, double dy, double size, double opacity, Particle particle) {
    final sharpPaint = Paint()
      ..color = particle.color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(dx, dy),
      size,
      sharpPaint,
    );
  }

  /// Paints a blurry particle with optional bright core
  void _paintBlurryParticle(Canvas canvas, double dx, double dy, double size, double opacity, Particle particle, double sparkle) {
    // Draw blurry particle body
    final blurryPaint = Paint()
      ..color = particle.color.withValues(alpha: opacity)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size * IntroVisualConstants.sparkleBlurMultiplier);

    canvas.drawCircle(
      Offset(dx, dy),
      size,
      blurryPaint,
    );

    // Draw bright core when sparkling
    if (sparkle > IntroVisualConstants.sparkleThreshold) {
      final corePaint = Paint()
        ..color = const Color(0xFFFFFFFF).withValues(alpha: (sparkle - IntroVisualConstants.sparkleThreshold) * IntroVisualConstants.sparkleCoreIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

      canvas.drawCircle(
        Offset(dx, dy),
        size * IntroVisualConstants.sparkleCoreSize,
        corePaint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    // Only repaint if animation value changed significantly (performance optimization)
    return (oldDelegate.animationValue - animationValue).abs() > 0.001 ||
           oldDelegate.particles != particles;
  }
}
