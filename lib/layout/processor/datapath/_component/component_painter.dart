import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_paint.dart';

class ComponentPainter extends CustomPainter {
  ComponentPainter({required this.componentShape, this.rotationRadians = 0});

  final ComponentShape componentShape;
  final double rotationRadians;

  final radians45 = 45 * 3.14 / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final shapePath = ComponentPaint.paths(size, componentShape);
    final shadowPaint = Paint()
      ..color = const Color.fromARGB(50, 23, 60, 130)
      ..style = PaintingStyle.fill;
    final fillPaint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill;
    final edgePaint = Paint()
      ..color = const Color.fromARGB(194, 46, 111, 128)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final fillPath = shapePath;
    final edgePath = shapePath;

    final rightShadowOffset = Offset.fromDirection(
      -rotationRadians + radians45,
      10,
    );
    final rightShadowPath = shapePath.shift(rightShadowOffset);

    canvas.rotate(rotationRadians);

    canvas.drawPath(rightShadowPath, shadowPaint);
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(edgePath, edgePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

enum ComponentShape {
  alu,
  memory,
  registerFile,
  register,
  multiplexer,
  bus,
  buffer,
}
