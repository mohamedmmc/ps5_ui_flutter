import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/intro_visual_constants.dart';

/// Provides random particle colors from predefined palette
///
/// Follows Single Responsibility Principle - only handles color selection
class ParticleColorProvider {
  final math.Random _random;

  /// Creates a color provider with an optional custom random number generator
  ///
  /// If [random] is not provided, creates a new [math.Random] instance
  ParticleColorProvider([math.Random? random]) : _random = random ?? math.Random();

  /// Returns a random color from the particle color palette
  ///
  /// Colors are defined in [IntroVisualConstants.particleColors]
  Color getRandomColor() {
    return IntroVisualConstants.particleColors[_random.nextInt(IntroVisualConstants.particleColors.length)];
  }
}
