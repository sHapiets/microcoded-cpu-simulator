import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/datapath/memory/memory.dart';

class MemoryWidget extends StatefulWidget {
  const MemoryWidget({super.key});

  @override
  State<MemoryWidget> createState() => _MemoryWidgetState();
}

class _MemoryWidgetState extends State<MemoryWidget> {
  final memory = Memory.singleton;

  final widgetHeight = 150.0;
  final widgetWidth = 100.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widgetHeight,
      width: widgetWidth,
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Scrollbar(
              child: Table(
                children: memory.byteMemory.map((memoryWord) {
                  return TableRow(
                    children: [
                      Text(memoryWord[3].asByte().asHexString(2)),
                      Text(memoryWord[2].asByte().asHexString(2)),
                      Text(memoryWord[1].asByte().asHexString(2)),
                      Text(memoryWord[0].asByte().asHexString(2)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
