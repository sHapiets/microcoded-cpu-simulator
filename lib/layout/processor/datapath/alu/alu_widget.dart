import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/alu.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_painter.dart';

class ALUWidget extends StatefulWidget {
  const ALUWidget({super.key});

  @override
  State<ALUWidget> createState() => _ALUWidgetState();
}

class _ALUWidgetState extends State<ALUWidget> {
  final alu = ALU.singleton;

  final double widgetHeight = 200.0;
  final double widgetWidth = 100.0;

  final Size paintSize = Size(80, 160);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: widgetWidth,
        height: widgetHeight,
        child: Stack(
          children: [
            Center(
              child: CustomPaint(
                size: paintSize,
                painter: ComponentPainter(componentShape: ComponentShape.alu),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
