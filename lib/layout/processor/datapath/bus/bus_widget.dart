import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_painter.dart';

class BusWidget extends StatefulWidget {
  const BusWidget({super.key});

  @override
  State<BusWidget> createState() => _BusWidgetState();
}

class _BusWidgetState extends State<BusWidget> {
  final bus = Bus.singleton;
  final processorStateManager = ProcessorStateManager.singleton;

  final double widgetHeight = 50.0;
  final double widgetWidth = 1280.0;

  final Size paintSize = Size(1280, 35);
  final double rotation45 = 90 * 3.14 / 180;

  void updateWidget() => setState(() {});

  late final Widget busDataText;

  @override
  void initState() {
    busDataText = ValueListenableBuilder(
      valueListenable: processorStateManager.busDataState,
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
                painter: ComponentPainter(componentShape: ComponentShape.bus),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.bottomLeft,
              child: Transform.translate(
                offset: Offset(0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.settings_ethernet),
                    Text(
                      "bus",
                      style: TextStyle(fontSize: 15, fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: Transform.translate(
                offset: Offset(0, 0),
                child: busDataText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
