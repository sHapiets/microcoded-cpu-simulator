import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/alu/alu_widget.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/memory/memory_widget.dart';

class ProcessorWidget extends StatefulWidget {
  const ProcessorWidget({super.key});

  @override
  State<ProcessorWidget> createState() => _ProcessorWidgetState();
}

class _ProcessorWidgetState extends State<ProcessorWidget> {
  final widgetHeight = 720.0;
  final widgetWidth = 1280.0;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: EdgeInsetsGeometry.all(20),
        height: widgetHeight,
        width: widgetWidth,
        color: const Color.fromARGB(0, 124, 203, 51),
        child: Stack(
          children: [
            Align(alignment: AlignmentGeometry.center, child: ALUWidget()),
            Align(alignment: AlignmentGeometry.topCenter, child: ALUWidget()),
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: MemoryWidget(),
            ),
            Align(alignment: AlignmentGeometry.bottomLeft, child: ALUWidget()),
          ],
        ),
      ),
    );
  }
}
