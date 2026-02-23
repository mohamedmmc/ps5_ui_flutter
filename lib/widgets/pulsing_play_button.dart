import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ps5_ui_flutter/constants/app_colors.dart';

class PulsingPlayButton extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final Duration cycleDuration;
  final double size;
  final int pulseCount;
  final List<Duration> pulseDelays;
  final Duration pulseExpansionDuration;
  final String logoAssetPath;
  final double logoSize;
  final bool tintLogo;
  final Color color;

  const PulsingPlayButton({
    super.key,
    required this.pulseAnimation,
    required this.cycleDuration,
    this.size = 256,
    this.pulseCount = 3,
    this.pulseDelays = const [
      Duration(milliseconds: 1120),
      Duration(milliseconds: 1300),
      Duration(milliseconds: 2000),
      // Duration(milliseconds: 1100),
    ],
    this.pulseExpansionDuration = const Duration(seconds: 4),
    this.logoAssetPath = 'assets/images/website/pslogo.png',
    this.logoSize = 128,
    this.tintLogo = true,
    this.color = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          final tMs = pulseAnimation.value * cycleDuration.inMilliseconds;
          final effectiveCount = math.min(pulseCount, pulseDelays.length);
          final strokeWidths = <double>[12, 6, 3.5, 3];

          final rings = <Widget>[];
          for (int i = 0; i < effectiveCount; i++) {
            final progress = _pulseProgress(
              tMs: tMs,
              startMs: pulseDelays[i].inMilliseconds.toDouble(),
              durationMs: pulseExpansionDuration.inMilliseconds.toDouble(),
            );
            if (progress == null) continue;
            rings.add(
              _PulseRing(
                size: size,
                color: color,
                progress: progress,
                baseStrokeWidth: strokeWidths[i.clamp(0, strokeWidths.length - 1)],
                intensity: i == 0 ? 1.0 : 0.75,
              ),
            );
          }
          rings.add(child!);

          return Stack(
            alignment: Alignment.center,
            children: rings,
          );
        },
        child: SizedBox(
          width: logoSize,
          height: logoSize,
          child: Center(
            child: Image.asset(
              logoAssetPath,
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
              color: tintLogo ? color.withValues(alpha: 0.95) : null,
              colorBlendMode: tintLogo ? BlendMode.srcIn : null,
            ),
          ),
        ),
      ),
    );
  }

  double? _pulseProgress({
    required double tMs,
    required double startMs,
    required double durationMs,
  }) {
    final local = tMs - startMs;
    if (local < 0 || local > durationMs) return null;
    return (local / durationMs).clamp(0.0, 1.0);
  }
}

class _PulseRing extends StatelessWidget {
  final double size;
  final Color color;
  final double progress;
  final double baseStrokeWidth;
  final double intensity;

  const _PulseRing({
    required this.size,
    required this.color,
    required this.progress,
    required this.baseStrokeWidth,
    required this.intensity,
  });

  @override
  Widget build(BuildContext context) {
    final t = progress.clamp(0.0, 1.0);
    final eased = Curves.easeOutCubic.transform(t);
    final scale = _lerp(0.65, 1.75, eased);
    final opacity = math.pow(1.0 - eased, 2.2).toDouble().clamp(0.0, 1.0);
    final strokeWidth = _lerp(baseStrokeWidth, 1.2, eased);

    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: (0.75 * intensity) * opacity),
              width: strokeWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: (0.28 * intensity) * opacity),
                blurRadius: 34,
                spreadRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}
