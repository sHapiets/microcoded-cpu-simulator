import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/datapath/memory/memory.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_painter.dart';

class MemoryAddressWidget extends StatefulWidget {
  const MemoryAddressWidget({super.key});

  @override
  State<MemoryAddressWidget> createState() => _MemoryAddressWidgetState();
}

class _MemoryAddressWidgetState extends State<MemoryAddressWidget> {
  final memory = Memory.singleton;
  final processorStateManager = ProcessorStateManager.singleton;

  final double widgetHeight = 50.0;
  final double widgetWidth = 180.0;

  final Size paintSize = Size(180, 35);
  final double rotation45 = 90 * 3.14 / 180;

  void updateWidget() => setState(() {});

  late final Widget memAddressText;

  @override
  void initState() {
    memAddressText = ValueListenableBuilder(
      valueListenable: processorStateManager.memAddState,
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
                      "memory address",
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
                child: memAddressText,
              ),
            ),

            /// LOADENABLEBOOL ICON
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Transform.translate(
                offset: Offset(-50, 0),
                child: ValueListenableBuilder(
                  valueListenable: processorStateManager.memAddLoadState,
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
