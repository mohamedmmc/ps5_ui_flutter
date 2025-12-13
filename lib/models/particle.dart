import 'package:flutter/material.dart';

/// Data model representing a single particle in the particle system
///
/// Contains position, velocity, visual properties, and sparkle animation state
class Particle {
  /// Current X position (normalized 0.0 to 1.0)
  double x;

  /// Current Y position (normalized 0.0 to 1.0)
  double y;

  /// Particle size in pixels
  final double size;

  /// Movement speed
  final double speed;

  /// Horizontal velocity component
  final double velocityX;

  /// Vertical velocity component
  final double velocityY;

  /// Base opacity (0.0 to 1.0)
  final double opacity;

  /// Particle color
  final Color color;

  /// Phase offset for sparkle animation (0 to 2π)
  final double sparklePhase;

  /// Sparkle animation speed multiplier
  final double sparkleSpeed;

  /// Whether particle renders sharp (true) or blurry (false)
  final bool isSharp;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.velocityX,
    required this.velocityY,
    required this.opacity,
    required this.color,
    required this.sparklePhase,
    required this.sparkleSpeed,
    required this.isSharp,
  });
}
