import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_painter.dart';

class RegSelMultiplexerWidget extends StatefulWidget {
  const RegSelMultiplexerWidget({super.key});

  @override
  State<RegSelMultiplexerWidget> createState() =>
      _RegSelMultiplexerWidgetState();
}

class _RegSelMultiplexerWidgetState extends State<RegSelMultiplexerWidget> {
  final processorStateManager = ProcessorStateManager.singleton;

  final double widgetHeight = 100;
  final double widgetWidth = 200;

  final Size paintSize = Size(160, 50);
  final double rotation45 = 90 * 3.14 / 180;

  late final Widget regSelText;

  @override
  void initState() {
    regSelText = ValueListenableBuilder(
      valueListenable: processorStateManager.regSelState,
      builder: (context, value, child) {
        final text = value.name;

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
            style: TextStyle(fontSize: 15, fontFamily: "Nunito"),
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
                painter: ComponentPainter(
                  componentShape: ComponentShape.multiplexer,
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: Offset(0, 0),
                child: regSelText,
              ),
            ),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Transform.translate(
                offset: Offset(10, -40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.keyboard_option_key_rounded),
                    Text(
                      "reg. select multiplexer",
                      style: TextStyle(fontSize: 15, fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
