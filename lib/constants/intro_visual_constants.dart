import 'package:flutter/material.dart';

/// Visual configuration constants for the intro screen
///
/// Contains colors, sizes, counts, opacities, and visual effect parameters
class IntroVisualConstants {
  IntroVisualConstants._();

  // Background Color
  static const Color backgroundColor = Color.fromARGB(240, 10, 17, 41);

  // Particle System
  static const int particleCount = 60; // Optimized from 200 for better performance
  static const double particleThickness = 0.35;
  static const double particleMinSize = 1.0;
  static const double particleMaxSize = 11.0;
  static const double particleMinSpeed = 0.05;
  static const double particleMaxSpeed = 0.20;
  static const double particleMinOpacity = 0.2;
  static const double particleMaxOpacity = 0.8;
  static const double particleVelocityMultiplier = 0.3;
  static const double particleRepositionProbability = 0.7;

  // Particle Sparkle
  static const double sparkleMinSpeed = 1.0;
  static const double sparkleMaxSpeed = 11.0;
  static const double sparkleOpacityMin = 0.3;
  static const double sparkleOpacityRange = 0.7;
  static const double sparkleSizeMin = 0.8;
  static const double sparkleSizeRange = 0.4;
  static const double sparkleBlurMultiplier = 0.6;
  static const double sparkleThreshold = 0.5;
  static const double sparkleCoreSize = 0.3;
  static const double sparkleCoreIntensity = 1.2;

  // Particle Colors
  static const List<Color> particleColors = [
    Color(0xFFFFD764), // Golden
    Color(0xFFFFA834), // Orange
    Color(0xFFFFE8B4), // Light gold
    Color(0xFFD4A574), // Brown-gold
    Color(0xFFFFFFFF), // White
  ];

  // Light Beam - Source Position
  static const double lightSourceXFactor = 0.1;
  static const double lightSourceYFactor = -0.1;
  static const double lightBeamSourceRadius = 100.0;

  // Light Beam - Rays
  static const int lightBeamRayCount = 8;
  static const double lightBeamRaySpread = 0.8;
  static const double lightBeamRayOffset = -0.2;
  static const double lightBeamRayWidth = 0.6;
  static const double lightBeamRayHeight = 0.7;
  static const double rayBaseOpacity = 0.03;
  static const double rayOpacityVariation = 0.02;
  static const double rayBaseStrokeWidth = 60.0;
  static const double rayStrokeWidthVariation = 20.0;
  static const double rayBlurRadius = 30.0;

  // Light Beam - Source Gradient
  static const double sourceGlowFullOpacity = 1.0;
  static const double sourceGlowHighOpacity = 0.9;
  static const double sourceGlowMediumOpacity = 0.6;
  static const double sourceGlowLowOpacity = 0.2;
  static const Color sourceGlowPrimaryColor = Color(0xFFFFFFFF);
  static const Color sourceGlowSecondaryColor = Color(0xFFF5F5F5);
  static const Color sourceGlowTertiaryColor = Color(0xFFFFD764);

  // Light Beam - Expansion
  static const double lightBeamExpansionWidth = 0.8;
  static const double lightBeamOpacityDecay = 0.7;

  // Light Beam - Background Glow
  static const double backgroundGlowRadius = 1.5;
  static const double backgroundGlowPrimaryOpacity = 0.1;
  static const double backgroundGlowSecondaryOpacity = 0.05;
  static const Color backgroundGlowPrimaryColor = Color(0xFFFFD764);
  static const Color backgroundGlowSecondaryColor = Color.fromARGB(255, 255, 255, 255);

  // Bezier Curve Control Points
  static const double bezierStartX = 0.0;
  static const double bezierControlX1 = 0.3;
  static const double bezierControlX2 = 0.7;
  static const double bezierEndX = 1.0;

  static const double bezierStartY = 1.0;
  static const double bezierControlY1 = 0.8;
  static const double bezierControlY2 = 0.6;
  static const double bezierEndY = 0.5;
}
