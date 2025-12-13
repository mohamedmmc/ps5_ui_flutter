/// Animation configuration constants for the intro screen
///
/// Contains durations, multipliers, and animation behavior settings
class IntroAnimationConstants {
  IntroAnimationConstants._();

  // Animation Durations
  static const Duration pulseDuration = Duration(milliseconds: 7500);
  static const Duration lightBeamDuration = Duration(minutes: 1);
  static const Duration rotationDuration = Duration(seconds: 15);
  static const Duration fadeDuration = Duration(milliseconds: 2000);
  static const Duration particleDuration = Duration(seconds: 10);

  // Animation Ranges
  static const double pulseSinMultiplier = 0.15; // Creates 0.85 to 1.15 range
  static const double pulseBaseValue = 1.0;
}
