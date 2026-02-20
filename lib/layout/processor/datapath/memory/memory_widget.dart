import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/datapath/memory/memory.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_painter.dart';

class MemoryWidget extends StatefulWidget {
  const MemoryWidget({super.key});

  @override
  State<MemoryWidget> createState() => _MemoryWidgetState();
}

class _MemoryWidgetState extends State<MemoryWidget> {
  final memory = Memory.singleton;
  final processorStateManager = ProcessorStateManager.singleton;

  final double widgetHeight = 320.0;
  final double widgetWidth = 240.0;

  final Size paintSize = Size(200, 290);

  late ListView memoryTable;
  late List<Row> instrMemoryTableRows = [];
  late List<Row> dynamicMemoryTableRows = [];

  Widget memoryOnDisplayLabel = Text(
    "instruction space",
    style: TextStyle(fontSize: 14, fontFamily: "Nunito"),
  );
  late final Widget switchMemoryDisplayButton;
  bool instrMemoryOnDisplay = true;

  @override
  void initState() {
    for (int i = 0; i <= memory.instrWordAddressLimit; i++) {
      final memoryWord = processorStateManager.memoryState[i];

      instrMemoryTableRows.add(
        Row(
          spacing: 20.0,
          children: [
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: Text(
                "0x${(i * 4).toRadixString(16).padLeft(3, "0")}",
                style: TextStyle(fontSize: 15, fontFamily: "Roboto-Mono"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5.0,
              children: memoryWord.map((memoryByte) {
                return Center(
                  child: ValueListenableBuilder(
                    valueListenable: memoryByte,
                    builder: (context, value, child) {
                      final text = value.asUnsignedHexString(2);

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
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    for (
      int i = memory.dynamicWordAddressBegin;
      i <= memory.dynamicWordAddressLimit;
      i++
    ) {
      final memoryWord = processorStateManager.memoryState[i];

      dynamicMemoryTableRows.add(
        Row(
          spacing: 20.0,
          children: [
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: Text(
                "0x${(i * 4).toRadixString(16).padLeft(3, "0")}",
                style: TextStyle(fontSize: 15, fontFamily: "Roboto-Mono"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5.0,
              children: memoryWord.map((memoryByte) {
                return Center(
                  child: ValueListenableBuilder(
                    valueListenable: memoryByte,
                    builder: (context, value, child) {
                      final text = value.asUnsignedHexString(2);

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
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    memoryTable = ListView(children: instrMemoryTableRows);

    switchMemoryDisplayButton = IconButton(
      onPressed: () {
        setState(() {
          if (instrMemoryOnDisplay) {
            memoryTable = ListView(children: dynamicMemoryTableRows);
            instrMemoryOnDisplay = false;
            memoryOnDisplayLabel = Text(
              "dynamic space",
              style: TextStyle(fontSize: 14, fontFamily: "Nunito"),
            );
          } else {
            memoryTable = ListView(children: instrMemoryTableRows);
            instrMemoryOnDisplay = true;
            memoryOnDisplayLabel = Text(
              "instruction space",
              style: TextStyle(fontSize: 14, fontFamily: "Nunito"),
            );
          }
        });
      },
      icon: Icon(
        Icons.swap_horizontal_circle_sharp,
        color: const Color.fromARGB(194, 46, 111, 128),
      ),
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
              child: CustomPaint(
                size: paintSize,
                painter: ComponentPainter(
                  componentShape: ComponentShape.memory,
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Transform.translate(
                offset: Offset(35, 20),
                child: Row(
                  children: [
                    Icon(Icons.memory_rounded),
                    Text(
                      "memory",
                      style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.topCenter,
              child: Transform.translate(
                offset: Offset(0, 40),
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
              alignment: AlignmentGeometry.bottomCenter,
              child: Transform.translate(
                offset: Offset(0, -50),
                child: memoryOnDisplayLabel,
              ),
            ),

            Align(
              alignment: AlignmentGeometry.topCenter,
              child: Transform.translate(
                offset: Offset(0, 60),
                child: SizedBox(height: 180, width: 160, child: memoryTable),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: Transform.translate(
                offset: Offset(0, -20),
                child: switchMemoryDisplayButton,
              ),
            ),

            /// LOADENABLEBOOL ICON
            Align(
              alignment: AlignmentGeometry.topRight,
              child: Transform.translate(
                offset: Offset(-40, -25),
                child: ValueListenableBuilder(
                  valueListenable: processorStateManager.memoryWriteEnableState,
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
