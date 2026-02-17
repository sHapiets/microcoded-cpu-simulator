import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_painter.dart';

class BuffersWidget extends StatefulWidget {
  const BuffersWidget({super.key});

  @override
  State<BuffersWidget> createState() => _BuffersWidgetState();
}

class _BuffersWidgetState extends State<BuffersWidget> {
  final bus = Bus.singleton;
  final processorStateManager = ProcessorStateManager.singleton;

  final double widgetHeight = 50.0;
  final double widgetWidth = 1280.0;

  final Size paintSize = Size(50, 50);

  void updateWidget() => setState(() {});

  final bufferPosition = {
    Buffer.immEn: Offset(-440, 0),
    Buffer.regEn: Offset(-140, 0),
    Buffer.aluEn: Offset(420, 0),
    Buffer.memEn: Offset(620, 0),
  };
  final enableOffset = Offset(-40, 0);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: widgetWidth,
        height: widgetHeight,
        child: Stack(
          children: [
            /// IMMEN BUFFER
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: bufferPosition[Buffer.memEn]!,
                child: CustomPaint(
                  size: paintSize,
                  painter: ComponentPainter(
                    componentShape: ComponentShape.buffer,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: bufferPosition[Buffer.memEn]! + enableOffset,
                child: ValueListenableBuilder(
                  valueListenable:
                      processorStateManager.bufferState[Buffer.memEn]!,
                  builder: (context, value, child) {
                    return Icon(
                      (value) ? Icons.toggle_on : Icons.toggle_off_outlined,
                      size: 35,
                      color: (value) ? Colors.green : Colors.black,
                    );
                  },
                ),
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: bufferPosition[Buffer.aluEn]!,
                child: CustomPaint(
                  size: paintSize,
                  painter: ComponentPainter(
                    componentShape: ComponentShape.buffer,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: bufferPosition[Buffer.aluEn]! + enableOffset,
                child: ValueListenableBuilder(
                  valueListenable:
                      processorStateManager.bufferState[Buffer.aluEn]!,
                  builder: (context, value, child) {
                    return Icon(
                      (value) ? Icons.toggle_on : Icons.toggle_off_outlined,
                      size: 35,
                      color: (value) ? Colors.green : Colors.black,
                    );
                  },
                ),
              ),
            ),

            /// REGEN BUFFER
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: bufferPosition[Buffer.regEn]!,
                child: CustomPaint(
                  size: paintSize,
                  painter: ComponentPainter(
                    componentShape: ComponentShape.buffer,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: bufferPosition[Buffer.regEn]! + enableOffset,
                child: ValueListenableBuilder(
                  valueListenable:
                      processorStateManager.bufferState[Buffer.regEn]!,
                  builder: (context, value, child) {
                    return Icon(
                      (value) ? Icons.toggle_on : Icons.toggle_off_outlined,
                      size: 35,
                      color: (value) ? Colors.green : Colors.black,
                    );
                  },
                ),
              ),
            ),

            /// IMMEN BUFFER
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: bufferPosition[Buffer.immEn]!,
                child: CustomPaint(
                  size: paintSize,
                  painter: ComponentPainter(
                    componentShape: ComponentShape.buffer,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: bufferPosition[Buffer.immEn]! + enableOffset,
                child: ValueListenableBuilder(
                  valueListenable:
                      processorStateManager.bufferState[Buffer.immEn]!,
                  builder: (context, value, child) {
                    return Icon(
                      (value) ? Icons.toggle_on : Icons.toggle_off_outlined,
                      size: 35,
                      color: (value) ? Colors.green : Colors.black,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
