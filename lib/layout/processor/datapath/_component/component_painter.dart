import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_path.dart';

class ComponentPainter extends CustomPainter {
  ComponentPainter({required this.componentShape});

  final ComponentShape componentShape;

  @override
  void paint(Canvas canvas, Size size) {
    final aluShapePath = ComponentPath.paths(size, componentShape);
    final shadowPaint = Paint()
      ..color = const Color.fromARGB(50, 23, 60, 130)
      ..style = PaintingStyle.fill;
    final fillPaint = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill;
    final edgePaint = Paint()
      ..color = const Color.fromARGB(194, 46, 111, 128)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final fillPath = aluShapePath;
    final edgePath = aluShapePath;

    final rightShadowOffset = const Offset(10, 10);
    final rightShadowPath = aluShapePath.shift(rightShadowOffset);

    canvas.drawPath(rightShadowPath, shadowPaint);
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(edgePath, edgePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

enum ComponentShape { alu, memory }
