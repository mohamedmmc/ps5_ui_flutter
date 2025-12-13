import 'package:flutter/material.dart';
import 'package:ps5_ui_flutter/constants/intro_layout_constants.dart';
import 'dart:math' as math;
import '../../constants/intro_visual_constants.dart';

/// Custom painter for rendering light beam effects
///
/// Follows Single Responsibility Principle - only handles light beam painting
class LightBeamPainter extends CustomPainter {
  final double animationValue;

  LightBeamPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final wave = 0.5 - 0.5 * math.cos(animationValue * 2 * math.pi);
    final flicker = 0.92 + 0.08 * math.sin(animationValue * 2 * math.pi * 3.0);
    final intensity = (0.55 + 0.55 * wave) * flicker;

    _paintProjectorBeam(canvas, size, wave, intensity);
    _paintBackgroundGlow(canvas, size, intensity);
  }

  void _paintProjectorBeam(Canvas canvas, Size size, double wave, double intensity) {
    final centerX = size.width * IntroVisualConstants.lightSourceXFactor;
    final startY = -100.0;
    final endY = size.height * 2;

    final topHalfWidth = size.width * _lerp(0.035, 0.075, wave);
    final bottomHalfWidth = size.width * _lerp(1.6, 1.05, wave);

    final glowPath = _buildBeamPath(
      centerX: centerX,
      startY: startY,
      endY: endY,
      topHalfWidth: topHalfWidth,
      bottomHalfWidth: bottomHalfWidth,
    );

    final corePath = _buildBeamPath(
      centerX: centerX,
      startY: startY,
      endY: endY,
      topHalfWidth: topHalfWidth * 0.62,
      bottomHalfWidth: bottomHalfWidth * 0.55,
    );

    final shaderBounds = Rect.fromLTRB(
      centerX - bottomHalfWidth * 1.2,
      startY,
      centerX + bottomHalfWidth * 1.2,
      endY,
    );

    _paintOuterRays(
      canvas: canvas,
      size: size,
      shaderBounds: shaderBounds,
      centerX: centerX,
      startY: startY,
      endY: endY,
      bottomHalfWidth: bottomHalfWidth,
      wave: wave,
      intensity: intensity,
    );

    canvas.save();
    canvas.clipPath(glowPath);
    _paintInnerRays(
      canvas: canvas,
      size: size,
      shaderBounds: shaderBounds,
      centerX: centerX,
      startY: startY,
      endY: endY,
      wave: wave,
      intensity: intensity,
    );
    canvas.restore();

    final glowGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color.fromARGB(0, 255, 255, 255),
        const Color(0xFFFFFFFF).withValues(alpha: 0.08 * intensity),
        const Color.fromARGB(255, 255, 255, 255).withValues(alpha: 0.06 * intensity),
        Colors.transparent,
      ],
      stops: const [0.0, 0.14, 0.55, 1.0],
    );

    final coreGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color.fromARGB(0, 255, 255, 255),
        const Color(0xFFFFFFFF).withValues(alpha: 0.18 * intensity),
        const Color(0xFFFFE8B4).withValues(alpha: 0.14 * intensity),
        const Color.fromARGB(255, 237, 237, 237).withValues(alpha: 0.08 * intensity),
        Colors.transparent,
      ],
      stops: const [0.0, 0.10, 0.22, 0.60, 1.0],
    );

    final glowPaint = Paint()
      ..blendMode = BlendMode.plus
      ..shader = glowGradient.createShader(shaderBounds)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);

    final corePaint = Paint()
      ..blendMode = BlendMode.plus
      ..shader = coreGradient.createShader(shaderBounds)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    canvas.drawPath(glowPath, glowPaint);
    canvas.drawPath(corePath, corePaint);
  }

  void _paintOuterRays({
    required Canvas canvas,
    required Size size,
    required Rect shaderBounds,
    required double centerX,
    required double startY,
    required double endY,
    required double bottomHalfWidth,
    required double wave,
    required double intensity,
  }) {
    const rayCount = 8;
    final height = endY - startY;
    final beamHalfAngle = math.atan2(bottomHalfWidth, height);
    final outerBounds = Rect.fromLTRB(
      shaderBounds.left - bottomHalfWidth * 1.6,
      shaderBounds.top,
      shaderBounds.right + bottomHalfWidth * 1.6,
      shaderBounds.bottom,
    );

    for (int i = 0; i < rayCount; i++) {
      final sign = i.isEven ? -1.0 : 1.0;
      final idx = rayCount == 1 ? 0.5 : i / (rayCount - 1);

      final phase = i * 1.11;
      final speed = 0.10 + i * 0.06;

      final spread = _lerp(1.08, 2.10, idx);
      final sway = 0.028 * math.sin((animationValue * 2 * math.pi * (0.18 + i * 0.05)) + phase);
      final angle = sign * beamHalfAngle * spread + sway;

      final t = (animationValue * speed + phase) % 1.0;
      final bandWidth = _lerp(0.10, 0.20, 1.0 - (idx - 0.5).abs() * 2.0);
      final stop1 = (t - bandWidth).clamp(0.0, 1.0);
      final stop2 = t.clamp(0.0, 1.0);
      final stop3 = (t + bandWidth).clamp(0.0, 1.0);

      final flicker = 0.65 + 0.35 * math.sin((animationValue * 2 * math.pi * (0.55 + i * 0.17)) + phase);
      final alpha = (0.012 + 0.020 * wave) * intensity * flicker;

      final rayEndY = _lerp(endY * 0.78, endY, 0.35 + 0.65 * math.sin(phase).abs());
      final rayHeight = rayEndY - startY;
      final endX = centerX + math.tan(angle) * rayHeight;

      final rayPath = Path()
        ..moveTo(centerX, startY - size.height * 0.06)
        ..lineTo(endX, rayEndY);

      final rayGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.transparent,
          const Color(0xFFFFFFFF).withValues(alpha: alpha),
          const Color(0xFFFFD764).withValues(alpha: alpha * 0.75),
          Colors.transparent,
        ],
        stops: [0.0, stop1, stop2, stop3, 1.0],
      ).createShader(outerBounds);

      final paint = Paint()
        ..blendMode = BlendMode.plus
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = size.width * _lerp(0.030, 0.055, 1.0 - (idx - 0.5).abs() * 2.0)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 34 + i * 4.0)
        ..shader = rayGradient;

      canvas.drawPath(rayPath, paint);
    }
  }

  void _paintInnerRays({
    required Canvas canvas,
    required Size size,
    required Rect shaderBounds,
    required double centerX,
    required double startY,
    required double endY,
    required double wave,
    required double intensity,
  }) {
    const rayCount = 6;
    final height = endY - startY;

    for (int i = 0; i < rayCount; i++) {
      final idx = rayCount == 1 ? 0.5 : i / (rayCount - 1);
      final phase = i * 0.73;
      final speed = 0.20 + i * 0.13;

      final sway = 0.020 * math.sin((animationValue * 2 * math.pi * (0.22 + i * 0.06)) + phase);
      final angle = _lerp(-0.11, 0.11, idx) + sway;

      final t = (animationValue * speed + phase) % 1.0;
      final bandWidth = _lerp(0.08, 0.16, 1.0 - (idx - 0.5).abs() * 2.0);
      final stop1 = (t - bandWidth).clamp(0.0, 1.0);
      final stop2 = t.clamp(0.0, 1.0);
      final stop3 = (t + bandWidth).clamp(0.0, 1.0);

      final alphaBase = (0.035 + 0.05 * wave) * intensity;
      final alpha = alphaBase * (0.55 + 0.45 * math.sin((animationValue * 2 * math.pi * (0.9 + i * 0.25)) + phase));

      final endX = centerX + math.tan(angle) * height;
      final rayPath = Path()
        ..moveTo(centerX, startY - size.height * 0.04)
        ..lineTo(endX, endY);

      final rayGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.transparent,
          const Color(0xFFFFFFFF).withValues(alpha: alpha * 0.9),
          const Color(0xFFFFE8B4).withValues(alpha: alpha * 0.7),
          Colors.transparent,
        ],
        stops: [0.0, stop1, stop2, stop3, 1.0],
      ).createShader(shaderBounds);

      final softPaint = Paint()
        ..blendMode = BlendMode.plus
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = size.width * _lerp(0.020, 0.030, 1.0 - (idx - 0.5).abs() * 2.0)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 18 + i * 3.0)
        ..shader = rayGradient;

      final corePaint = Paint()
        ..blendMode = BlendMode.plus
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = size.width * _lerp(0.010, 0.016, 1.0 - (idx - 0.5).abs() * 2.0)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6 + i * 1.5)
        ..shader = rayGradient;

      canvas.drawPath(rayPath, softPaint);
      canvas.drawPath(rayPath, corePaint);
    }
  }

  Path _buildBeamPath({
    required double centerX,
    required double startY,
    required double endY,
    required double topHalfWidth,
    required double bottomHalfWidth,
  }) {
    final topLeft = Offset(centerX - topHalfWidth, startY);
    final topRight = Offset(centerX + topHalfWidth, startY);
    final bottomLeft = Offset(centerX - bottomHalfWidth, endY);
    final bottomRight = Offset(centerX + bottomHalfWidth, endY);

    final midT = 0.58;
    final midY = _lerp(startY, endY, midT);
    final midHalfWidth = _lerp(topHalfWidth, bottomHalfWidth, midT);
    final leftMid = Offset(centerX - midHalfWidth * 1.06, midY);
    final rightMid = Offset(centerX + midHalfWidth * 1.06, midY);

    return Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..quadraticBezierTo(rightMid.dx, rightMid.dy, bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..quadraticBezierTo(leftMid.dx, leftMid.dy, topLeft.dx, topLeft.dy)
      ..close();
  }

  // / Paints diffuse background glow
  void _paintBackgroundGlow(Canvas canvas, Size size, double intensity) {
    final backgroundGradient = RadialGradient(
      center: Alignment.topLeft,
      radius: IntroVisualConstants.backgroundGlowRadius,
      colors: [
        IntroVisualConstants.backgroundGlowPrimaryColor.withValues(alpha: IntroVisualConstants.backgroundGlowPrimaryOpacity * intensity),
        IntroVisualConstants.backgroundGlowSecondaryColor.withValues(alpha: IntroVisualConstants.backgroundGlowSecondaryOpacity * intensity),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final backgroundPaint = Paint()
      ..blendMode = BlendMode.plus
      ..shader = backgroundGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height * IntroLayoutConstants.lightBeamBackgroundHeight),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * IntroLayoutConstants.lightBeamBackgroundHeight),
      backgroundPaint,
    );
  }

  @override
  bool shouldRepaint(LightBeamPainter oldDelegate) => oldDelegate.animationValue != animationValue;

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}
