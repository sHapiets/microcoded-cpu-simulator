import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/datapath/registers/register_file.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_painter.dart';

class RegisterFileWidget extends StatefulWidget {
  const RegisterFileWidget({super.key});

  @override
  State<RegisterFileWidget> createState() => _RegisterFileWidgetState();
}

class _RegisterFileWidgetState extends State<RegisterFileWidget> {
  final registerFile = RegisterFile.singleton;
  final processorStateManager = ProcessorStateManager.singleton;

  final double widgetHeight = 320.0;
  final double widgetWidth = 240.0;

  final Size paintSize = Size(180, 270);

  void updateWidget() => setState(() {});

  late final Widget registerTable;

  @override
  void initState() {
    final initRegFile = registerFile.registers;
    processorStateManager.initializeRegFileState(initRegFile);

    registerTable = ListView(
      children: processorStateManager.regFileState.entries.map((register) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 18.0,
          children: [
            Center(
              child: Text(
                register.key.name,
                style: TextStyle(fontSize: 15, fontFamily: "Nunito"),
              ),
            ),
            Center(
              child: ValueListenableBuilder(
                valueListenable: register.value,
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
                        child: SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      text,
                      key: ValueKey(text),
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: "Roboto-Mono",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
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
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: Offset(20, 20),
                child: CustomPaint(
                  size: paintSize,
                  painter: ComponentPainter(
                    componentShape: ComponentShape.registerFile,
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: Offset(10, 10),
                child: CustomPaint(
                  size: paintSize,
                  painter: ComponentPainter(
                    componentShape: ComponentShape.registerFile,
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: CustomPaint(
                size: paintSize,
                painter: ComponentPainter(
                  componentShape: ComponentShape.registerFile,
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Transform.translate(
                offset: Offset(40, 30),
                child: Row(
                  children: [
                    Icon(Icons.list),
                    Text(
                      "register file",
                      style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.topCenter,
              child: Transform.translate(
                offset: Offset(0, 50),
                child: SizedBox(
                  width: paintSize.width,
                  child: Divider(
                    thickness: 3,
                    color: const Color.fromARGB(194, 46, 111, 128),
                  ),
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.topCenter,
              child: Transform.translate(
                offset: Offset(0, 70),
                child: SizedBox(height: 210, child: registerTable),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
