import 'package:flutter/material.dart';
import 'painters/light_beam_painter.dart';

/// Widget wrapper for light beam animation
///
/// Follows Single Responsibility Principle - only handles light beam rendering
class LightBeamWidget extends StatelessWidget {
  final AnimationController lightBeamController;

  const LightBeamWidget({
    super.key,
    required this.lightBeamController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LightBeamPainter(animation: lightBeamController),
      isComplex: true,
      willChange: true,
    );
  }
}
