import 'package:flutter/material.dart';

/// Responsive utility class for handling different screen sizes
class Responsive {
  /// Breakpoint constants
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Check if current screen is tablet or larger
  static bool isTabletOrLarger(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileBreakpoint;
  }

  /// Get responsive value based on screen size
  static T responsive<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  /// Get responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(32);
    } else {
      return const EdgeInsets.all(48);
    }
  }

  /// Get responsive font size multiplier
  static double fontSizeMultiplier(BuildContext context) {
    if (isMobile(context)) {
      return 0.75;
    } else if (isTablet(context)) {
      return 0.9;
    } else {
      return 1.0;
    }
  }

  /// Get screen width
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get responsive particle count for performance
  static int getParticleCount(BuildContext context) {
    if (isMobile(context)) {
      return 20; // Very low for mobile performance
    } else if (isTablet(context)) {
      return 40; // Medium for tablets
    } else {
      return 60; // Full for desktop
    }
  }

  /// Get responsive blur intensity
  static double getBlurIntensity(BuildContext context) {
    if (isMobile(context)) {
      return 4.0; // Lower blur for mobile performance
    } else if (isTablet(context)) {
      return 6.0; // Medium blur for tablets
    } else {
      return 8.0; // Full blur for desktop
    }
  }
}

/// Extension on BuildContext for easier access to responsive utilities
extension ResponsiveContext on BuildContext {
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);
  bool get isTabletOrLarger => Responsive.isTabletOrLarger(this);
  bool get isPortrait => Responsive.isPortrait(this);
  bool get isLandscape => Responsive.isLandscape(this);
  double get screenWidth => Responsive.width(this);
  double get screenHeight => Responsive.height(this);
}
