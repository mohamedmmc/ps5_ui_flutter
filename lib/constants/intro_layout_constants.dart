/// Layout and positioning constants for the intro screen
///
/// Contains boundary limits, movement increments, and layer configurations
class IntroLayoutConstants {
  IntroLayoutConstants._();

  // Particle Boundary Limits
  static const double particleBoundaryMinX = -0.2;
  static const double particleBoundaryMaxX = 1.2;
  static const double particleBoundaryMinY = 0.2;
  static const double particleBoundaryMaxY = 1.2;

  // Particle Movement
  static const double particleMovementIncrement = 0.001;

  // Light Beam Layers
  static const int lightBeamExpansionLayers = 4;
  static const double lightBeamExpansionDistance = 0.7;
  static const double lightBeamBackgroundHeight = 0.8;

  // Light Beam Blur
  static const double sourceBlurRadius = 30.0;
  static const double expansionBaseBlurRadius = 40.0;
  static const double expansionBlurIncrement = 10.0;
}
