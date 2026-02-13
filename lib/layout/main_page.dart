import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/layout/processor/processor_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(alignment: AlignmentGeometry.center, child: ProcessorWidget()),
        ],
      ),
    );
  }
}
