import '../constants/intro_visual_constants.dart';

/// Helper class for Bezier curve calculations
///
/// Provides methods for calculating points on cubic Bezier curves
/// Follows Single Responsibility Principle - only handles mathematical calculations
class BezierCalculator {
  BezierCalculator._();

  /// Calculates a point on a cubic Bezier curve
  ///
  /// [t] is the interpolation parameter (0.0 to 1.0)
  /// [p0], [p1], [p2], [p3] are the four control points
  ///
  /// Returns the calculated position value
  static double cubicBezier(
    double t,
    double p0,
    double p1,
    double p2,
    double p3,
  ) {
    final u = 1 - t;
    return u * u * u * p0 + 3 * u * u * t * p1 + 3 * u * t * t * p2 + t * t * t * p3;
  }

  /// Calculates the X coordinate on the predefined Bezier curve
  ///
  /// Uses control points from [IntroVisualConstants]
  /// [t] is the interpolation parameter (0.0 to 1.0)
  static double cubicBezierX(double t) {
    return cubicBezier(
      t,
      IntroVisualConstants.bezierStartX,
      IntroVisualConstants.bezierControlX1,
      IntroVisualConstants.bezierControlX2,
      IntroVisualConstants.bezierEndX,
    );
  }

  /// Calculates the Y coordinate on the predefined Bezier curve
  ///
  /// Uses control points from [IntroVisualConstants]
  /// [t] is the interpolation parameter (0.0 to 1.0)
  static double cubicBezierY(double t) {
    return cubicBezier(
      t,
      IntroVisualConstants.bezierStartY,
      IntroVisualConstants.bezierControlY1,
      IntroVisualConstants.bezierControlY2,
      IntroVisualConstants.bezierEndY,
    );
  }
}
