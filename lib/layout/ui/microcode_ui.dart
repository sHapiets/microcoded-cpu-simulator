import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/controller/microcode_controller.dart';

class MicrocodeUI extends StatefulWidget {
  const MicrocodeUI({super.key});

  @override
  State<MicrocodeUI> createState() => _MicrocodeUIState();
}

class _MicrocodeUIState extends State<MicrocodeUI> {
  final uiHeight = 500.0;
  final uiWidth = 800.0;

  final microcodeController = MicrocodeController.singleton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: uiWidth,
      height: uiHeight,
      decoration: BoxDecoration(
        color: const Color.fromARGB(183, 255, 255, 255),
        border: Border.all(
          color: const Color.fromARGB(40, 0, 0, 0),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(17, 0, 0, 0),
            offset: Offset(10, 10),
          ),
        ],
      ),
      child: ListView(
        children: microcodeController.microcodeROM.map((microcode) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 3,
            children: microcode.entries.map((signal) {
              return Text(signal.value.asUnsignedHexString(2));
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
