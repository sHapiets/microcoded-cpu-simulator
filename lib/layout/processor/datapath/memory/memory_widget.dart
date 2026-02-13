import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/datapath/memory/memory.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_painter.dart';

class MemoryWidget extends StatefulWidget {
  const MemoryWidget({super.key});

  @override
  State<MemoryWidget> createState() => _MemoryWidgetState();
}

class _MemoryWidgetState extends State<MemoryWidget> {
  final memory = Memory.singleton;

  final double widgetHeight = 300.0;
  final double widgetWidth = 200;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: widgetWidth,
        height: widgetHeight,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(widgetWidth, widgetHeight),
              painter: ComponentPainter(componentShape: ComponentShape.memory),
            ),
          ],
        ),
      ),
    );
  }
}
