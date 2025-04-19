// widgets/custom_thumb_shape.dart
import 'package:flutter/material.dart';

class CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(12, 12);
  }

  @override
  void paint(
    PaintingContext context, 
    Offset center, 
    {required Animation<double> activationAnimation, 
    required Animation<double> enableAnimation, 
    required bool isDiscrete, 
    required TextPainter labelPainter, 
    required RenderBox parentBox, 
    required SliderThemeData sliderTheme, 
    required TextDirection textDirection, 
    required double value, 
    required double textScaleFactor, 
    required Size sizeWithOverflow}
  ) {
    final Canvas canvas = context.canvas;
    
    final Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
      
    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, 10, fillPaint);
    canvas.drawCircle(center, 10, borderPaint);
  }
}