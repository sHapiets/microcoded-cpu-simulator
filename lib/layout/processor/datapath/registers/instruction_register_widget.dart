import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/datapath/registers/instruction_register.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_painter.dart';

class InstructionRegisterWidget extends StatefulWidget {
  const InstructionRegisterWidget({super.key});

  @override
  State<InstructionRegisterWidget> createState() =>
      _InstructionRegisterWidgetState();
}

class _InstructionRegisterWidgetState extends State<InstructionRegisterWidget> {
  final processorStateManager = ProcessorStateManager.singleton;
  final instructionRegister = InstructionRegister.singleton;

  final double widgetHeight = 50.0;
  final double widgetWidth = 180.0;

  final Size paintSize = Size(180, 35);
  final double rotation45 = 90 * 3.14 / 180;

  late final Widget instrRegDataText;

  @override
  void initState() {
    instrRegDataText = ValueListenableBuilder(
      valueListenable: processorStateManager.instrRegState,
      builder: (context, value, child) {
        final text = "0x${value.asUnsignedHexString(8)}";

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
            style: const TextStyle(fontSize: 15, fontFamily: "Roboto-Mono"),
          ),
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                painter: ComponentPainter(
                  componentShape: ComponentShape.register,
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Transform.translate(
                offset: Offset(0, -30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.adjust_rounded),
                    Text(
                      "instruction register",
                      style: TextStyle(fontSize: 15, fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: Offset(0, 0),
                child: instrRegDataText,
              ),
            ),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Transform.translate(
                offset: Offset(-50, 0),
                child: ValueListenableBuilder(
                  valueListenable: processorStateManager.instrRegLoadState,
                  builder: (context, value, child) {
                    return Icon(
                      (value)
                          ? Icons.toggle_on_rounded
                          : Icons.toggle_off_outlined,
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
