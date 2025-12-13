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
}
