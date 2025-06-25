import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class SegmentedCircularProgressPainter extends CustomPainter {
  final double progress;  // Progress from 0.0 to 1.0
  final Color color;
  final double strokeWidth;
  final int segments;  // Number of segments corresponding to the number of pages

  SegmentedCircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.segments,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.width / 2) - strokeWidth / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth.w  // Adjust stroke width using .w
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Calculate the total angle for each segment and the gap
    final double totalAngle = 2 * math.pi;
    final double segmentAngle = totalAngle / segments;
    final double startAngle = -math.pi / 2;  // Start at the top of the circle

    // Calculate how many segments to fill based on progress
    final double filledSegments = progress * segments;

    for (int i = -1; i < filledSegments.toInt(); i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + (i * segmentAngle),
        segmentAngle * 0.8,  // Fill 80% of each segment, leaving a gap
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(SegmentedCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.segments != segments;
  }
}