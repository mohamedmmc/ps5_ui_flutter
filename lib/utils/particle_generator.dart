import 'dart:math' as math;
import 'package:ps5_ui_flutter/models/particle.dart';

import '../constants/intro_visual_constants.dart';
import 'bezier_calculator.dart';
import 'particle_color_provider.dart';

/// Generates and repositions particles along a Bezier curve
///
/// Follows Single Responsibility Principle - only handles particle creation and positioning
class ParticleGenerator {
  final math.Random _random;
  final ParticleColorProvider _colorProvider;

  /// Creates a particle generator with optional dependencies
  ///
  /// Allows dependency injection for testing
  ParticleGenerator({
    math.Random? random,
    ParticleColorProvider? colorProvider,
  })  : _random = random ?? math.Random(),
        _colorProvider = colorProvider ?? ParticleColorProvider();

  /// Generates a list of particles along a Bezier curve
  ///
  /// [count] specifies the number of particles to generate
  /// Returns a list of randomly positioned and configured particles
  List<Particle> generateParticles(int count) {
    final particles = <Particle>[];

    for (int i = 0; i < count; i++) {
      particles.add(_createParticle());
    }

    return particles;
  }

  /// Creates a single particle with random properties
  ///
  /// Positions the particle along the Bezier curve with perpendicular offset
  /// for thickness, and assigns random visual and movement properties
  Particle _createParticle() {
    // Random position along curve (0.0 to 1.0)
    final t = _random.nextDouble();

    // Calculate position on Bezier curve
    final curveX = BezierCalculator.cubicBezierX(t);
    final curveY = BezierCalculator.cubicBezierY(t);

    // Calculate perpendicular offset for line thickness
    final offset = (_random.nextDouble() - 0.5) * IntroVisualConstants.particleThickness;

    // Calculate normal vector to curve
    final angle = math.atan2(
      IntroVisualConstants.bezierEndY - IntroVisualConstants.bezierStartY,
      IntroVisualConstants.bezierEndX - IntroVisualConstants.bezierStartX,
    );
    final normalX = -math.sin(angle);
    final normalY = math.cos(angle);

    // Random movement properties
    final speed = _random.nextDouble() * (IntroVisualConstants.particleMaxSpeed - IntroVisualConstants.particleMinSpeed) + IntroVisualConstants.particleMinSpeed;
    final moveAngle = _random.nextDouble() * 2 * math.pi;

    return Particle(
      x: curveX + normalX * offset,
      y: curveY + normalY * offset,
      size: _random.nextDouble() * (IntroVisualConstants.particleMaxSize - IntroVisualConstants.particleMinSize) + IntroVisualConstants.particleMinSize,
      speed: speed,
      velocityX: math.cos(moveAngle) * speed * IntroVisualConstants.particleVelocityMultiplier,
      velocityY: math.sin(moveAngle) * speed * IntroVisualConstants.particleVelocityMultiplier,
      opacity: _random.nextDouble() * (IntroVisualConstants.particleMaxOpacity - IntroVisualConstants.particleMinOpacity) + IntroVisualConstants.particleMinOpacity,
      color: _colorProvider.getRandomColor(),
      sparklePhase: _random.nextDouble() * 2 * math.pi,
      sparkleSpeed: _random.nextDouble() * (IntroVisualConstants.sparkleMaxSpeed - IntroVisualConstants.sparkleMinSpeed) + IntroVisualConstants.sparkleMinSpeed,
      isSharp: _random.nextBool(),
    );
  }

  /// Repositions a particle back onto the Bezier curve
  ///
  /// Used when a particle moves out of bounds and needs to be recycled
  /// Maintains the existing particle object but updates its position
  void repositionParticle(Particle particle) {
    final t = _random.nextDouble();

    final curveX = BezierCalculator.cubicBezierX(t);
    final curveY = BezierCalculator.cubicBezierY(t);

    final offset = (_random.nextDouble() - 0.5) * IntroVisualConstants.particleThickness;

    final angle = math.atan2(
      IntroVisualConstants.bezierEndY - IntroVisualConstants.bezierStartY,
      IntroVisualConstants.bezierEndX - IntroVisualConstants.bezierStartX,
    );
    final normalX = -math.sin(angle);
    final normalY = math.cos(angle);

    particle.x = curveX + normalX * offset;
    particle.y = curveY + normalY * offset;
  }
}
