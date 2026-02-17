import 'package:flutter/material.dart';

class MicrocodeUI extends StatefulWidget {
  const MicrocodeUI({super.key});

  @override
  State<MicrocodeUI> createState() => _MicrocodeUIState();
}

class _MicrocodeUIState extends State<MicrocodeUI> {
  final uiHeight = 500.0;
  final uiWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: uiWidth,
      height: uiHeight,
      decoration: BoxDecoration(
        color: const Color.fromARGB(183, 6, 45, 104),
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
    );
  }
}
