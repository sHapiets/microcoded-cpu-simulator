import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/alu.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/alu_operations.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_painter.dart';

class ALUWidget extends StatefulWidget {
  const ALUWidget({super.key});

  @override
  State<ALUWidget> createState() => _ALUWidgetState();
}

class _ALUWidgetState extends State<ALUWidget> {
  final alu = ALU.singleton;
  final processorStateManager = ProcessorStateManager.singleton;

  final double widgetHeight = 200.0;
  final double widgetWidth = 100.0;

  final Size paintSize = Size(80, 160);
  final double rotation45 = 90 * 3.14 / 180;

  late final Widget aluOpText;

  String aluOpString(ALUOperation operation) {
    switch (operation) {
      case ALUOperation.copyA:
        return "A";
      case ALUOperation.copyB:
        return "B";
      case ALUOperation.inc1toA:
        return "A + 1";
      case ALUOperation.dec1toA:
        return "A - 1";
      case ALUOperation.inc4toA:
        return "A + 4";
      case ALUOperation.dec4toA:
        return "A - 4";
      case ALUOperation.add:
        return "A + B";
      case ALUOperation.sub:
        return "A - B";
      case ALUOperation.slt:
        return "A SLT B";
      case ALUOperation.sltu:
        return "A SLTU B";
      case ALUOperation.sra:
        return "A >>> B";
      case ALUOperation.srl:
        return "A >> B";
      case ALUOperation.sll:
        return "A << B";
      case ALUOperation.bitXOR:
        return "A ^ B";
      case ALUOperation.bitOR:
        return "A | B";
      case ALUOperation.bitAND:
        return "A & B";
    }
  }

  @override
  void initState() {
    aluOpText = ValueListenableBuilder(
      valueListenable: processorStateManager.aluOpState,
      builder: (context, value, child) {
        final text = aluOpString(value);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            final offsetAnimation =
                Tween<Offset>(
                  begin: const Offset(0.25, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOutBack,
                  ),
                );

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offsetAnimation, child: child),
            );
          },
          child: Text(
            text,
            key: ValueKey(text),
            style: TextStyle(fontSize: 12, fontFamily: "Nunito"),
          ),
        );
      },
    );
    super.initState();
  }

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

            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Transform.translate(
                offset: Offset(20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.settings),
                    Text(
                      "ALU",
                      style: TextStyle(fontSize: 15, fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: Offset(5, 0),
                child: aluOpText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
