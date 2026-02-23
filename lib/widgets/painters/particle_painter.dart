import 'package:flutter/material.dart';
import 'package:ps5_ui_flutter/models/particle.dart';
import 'dart:math' as math;
import '../../constants/intro_visual_constants.dart';
import '../../constants/intro_layout_constants.dart';
import '../../utils/particle_generator.dart';
import '../../constants/app_colors.dart';

/// Custom painter for rendering particle effects
///
/// Follows Single Responsibility Principle - only handles particle painting
/// Delegates particle repositioning to ParticleGenerator
class ParticlePainter extends CustomPainter {
  final math.Random _random = math.Random();

  final List<Particle> particles;
  final Animation<double> animation;
  final ParticleGenerator particleGenerator;

  final Paint _sharpPaint = Paint()..style = PaintingStyle.fill;
  final Paint _blurryPaint = Paint();
  final Paint _corePaint = Paint()
    ..color = AppColors.white
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

  final Map<int, MaskFilter> _blurCache = <int, MaskFilter>{};

  ParticlePainter({
    required this.particles,
    required this.animation,
    ParticleGenerator? particleGenerator,
  })  : particleGenerator = particleGenerator ?? ParticleGenerator(),
        super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final animationValue = animation.value;
    for (var particle in particles) {
      _updateParticlePosition(particle);
      _paintParticle(canvas, size, particle, animationValue);
    }
  }

  /// Updates particle position and repositions if out of bounds
  void _updateParticlePosition(Particle particle) {
    // Move particle
    particle.x += particle.velocityX * IntroLayoutConstants.particleMovementIncrement;
    particle.y += particle.velocityY * IntroLayoutConstants.particleMovementIncrement;

    // Check bounds and reposition if necessary
    if (_isParticleOutOfBounds(particle)) {
      if (_random.nextDouble() < IntroVisualConstants.particleRepositionProbability) {
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
  void _paintParticle(Canvas canvas, Size size, Particle particle, double animationValue) {
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
    canvas.drawCircle(
      Offset(dx, dy),
      size,
      _sharpPaint..color = particle.color.withValues(alpha: opacity),
    );
  }

  /// Paints a blurry particle with optional bright core
  void _paintBlurryParticle(Canvas canvas, double dx, double dy, double size, double opacity, Particle particle, double sparkle) {
    final sigmaKey = (size * IntroVisualConstants.sparkleBlurMultiplier * 10).round(); // 0.1 sigma steps
    final blurSigma = sigmaKey / 10.0;
    final blurFilter = _blurCache.putIfAbsent(sigmaKey, () => MaskFilter.blur(BlurStyle.normal, blurSigma));

    // Draw blurry particle body
    canvas.drawCircle(
      Offset(dx, dy),
      size,
      _blurryPaint
        ..color = particle.color.withValues(alpha: opacity)
        ..maskFilter = blurFilter,
    );

    // Draw bright core when sparkling
    if (sparkle > IntroVisualConstants.sparkleThreshold) {
      canvas.drawCircle(
        Offset(dx, dy),
        size * IntroVisualConstants.sparkleCoreSize,
        _corePaint..color = AppColors.white.withValues(alpha: (sparkle - IntroVisualConstants.sparkleThreshold) * IntroVisualConstants.sparkleCoreIntensity),
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.particles != particles || oldDelegate.animation != animation;
  }
}
