import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/controller/microcode_controller.dart';
import 'package:microcoded_cpu_coe197/core/datapath/memory/memory.dart';
import 'package:microcoded_cpu_coe197/layout/processor/processor_widget.dart';
import 'package:microcoded_cpu_coe197/layout/ui/microcode_ui.dart';
import 'package:microcoded_cpu_coe197/layout/ui/runtime_ui.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final memory = Memory.singleton;
  final microcodeController = MicrocodeController.singleton;

  @override
  void initState() {
    memory.presetInstructionLoad();
    microcodeController.initializePreset();
    /* 
    Data data = Data.halfWord(-128);
    debugPrint("type: ${data.dataType.name}");
    debugPrint("signed: ${data.asSignedInt()}");
    debugPrint("unsigned: ${data.asUnsignedInt()}");
 */
    /* 
    a.data = Data.halfWord(-1);
    b.data = Data.halfWord(1);
    alu.operation = ALUOperation.sltu;
    alu.operate();
    debugPrint("type: ${alu.result.dataType.name}");
    debugPrint("signed: ${alu.result.asSignedInt()}");
    debugPrint("unsigned: ${alu.result.asUnsignedInt()}");
 */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Stack(
          children: [
            Align(
              alignment: AlignmentGeometry.center,
              child: ProcessorWidget(),
            ),
            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: RuntimeUI(),
            ),
          ],
        ),
      ),
    );
  }
}
