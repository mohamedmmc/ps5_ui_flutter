import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Intro Screen
  static const TextStyle introInstruction = TextStyle(
    color: AppColors.white,
    fontSize: 30,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.5,
    decoration: TextDecoration.none,
    shadows: [
      Shadow(
        offset: Offset(0, 2),
        blurRadius: 10,
        color: AppColors.black54,
      ),
    ],
  );

  // User Select Screen
  static const TextStyle time = TextStyle(
    color: AppColors.white80,
    fontSize: 32,
    fontWeight: FontWeight.w300,
    decoration: TextDecoration.none,
  );

  static const TextStyle welcomeTitle = TextStyle(
    color: AppColors.white,
    fontSize: 36,
    fontWeight: FontWeight.w300,
    decoration: TextDecoration.none,
  );

  static const TextStyle welcomeSubtitle = TextStyle(
    color: AppColors.white50,
    fontSize: 18,
    decoration: TextDecoration.none,
  );

  static const TextStyle userName = TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );

  static const TextStyle plusBadge = TextStyle(
    color: AppColors.black,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );

  static const TextStyle userOptions = TextStyle(
    color: AppColors.white60,
    fontSize: 12,
    decoration: TextDecoration.none,
  );

  static const TextStyle addUserButton = TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
  );

  // Dashboard - Top Bar
  static TextStyle dashboardTime({required bool isMobile}) {
    return TextStyle(
      color: AppColors.white,
      fontSize: isMobile ? 16 : 24,
      fontWeight: FontWeight.w300,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  static TextStyle dashboardTabLabel({
    required bool isActive,
    required bool isHovered,
    required bool isMobile,
  }) {
    final color = isActive ? AppColors.white : (isHovered ? AppColors.white80 : AppColors.white50);

    return TextStyle(
      color: color,
      fontSize: isMobile ? 20 : 28,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.5,
      shadows: isActive
          ? const [
              Shadow(
                color: AppColors.white,
                blurRadius: 10,
              ),
            ]
          : const [],
    );
  }

  // User Select
  static TextStyle userInitials({required bool isMobile}) {
    return TextStyle(
      color: AppColors.white,
      fontSize: isMobile ? 32 : 42,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
    );
  }

  // Dashboard - Hero
  static TextStyle heroTitle({required bool isMobile}) {
    return TextStyle(
      color: AppColors.white,
      fontSize: isMobile ? 32 : 48,
      fontWeight: FontWeight.bold,
      shadows: const [
        Shadow(
          offset: Offset(0, 2),
          blurRadius: 10,
          color: Colors.black87,
        ),
      ],
    );
  }

  static TextStyle heroDescription({required bool isMobile}) {
    return TextStyle(
      color: AppColors.white90,
      fontSize: isMobile ? 14 : 20,
      fontWeight: FontWeight.normal,
      height: 1.5,
      shadows: const [
        Shadow(
          offset: Offset(0, 1),
          blurRadius: 5,
          color: AppColors.black54,
        ),
      ],
    );
  }

  static TextStyle heroPrimaryButton({required bool isMobile}) {
    return TextStyle(
      fontSize: isMobile ? 14 : 18,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle heroLogoText({required bool isMobile}) {
    return TextStyle(
      color: AppColors.white,
      fontSize: isMobile ? 40 : 60,
      fontWeight: FontWeight.w900,
      letterSpacing: -1,
      shadows: const [
        Shadow(
          offset: Offset(0, 4),
          blurRadius: 20,
          color: Colors.black87,
        ),
      ],
    );
  }

  // Dashboard - News
  static TextStyle newsLabel({required bool isHovered}) {
    return TextStyle(
      color: isHovered ? AppColors.white80 : AppColors.white60,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    );
  }

  static TextStyle get newsDate {
    return TextStyle(
      color: AppColors.white.withValues(alpha: 0.4),
      fontSize: 10,
    );
  }

  static TextStyle newsTitle({required bool isHovered}) {
    return TextStyle(
      color: isHovered ? AppColors.blueLight : AppColors.white,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  static const TextStyle newsDescription = TextStyle(
    color: AppColors.white60,
    fontSize: 12,
  );

  // Dashboard - Progress
  static const TextStyle progressLabel = TextStyle(
    color: AppColors.white60,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle progressValue = TextStyle(
    color: AppColors.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle earnedValue = TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle trophyCount(Color color) {
    return TextStyle(
      color: color,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
  }

  // Dashboard - Featured Media
  static const TextStyle featuredHeader = TextStyle(
    color: AppColors.white80,
    fontSize: 18,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle featuredWatch = TextStyle(
    color: AppColors.black,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}
