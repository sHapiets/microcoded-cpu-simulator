import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/controller/instruction_controller.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';

class InstructionDisplay extends StatefulWidget {
  const InstructionDisplay({super.key});

  @override
  State<InstructionDisplay> createState() => _InstructionDisplayState();
}

class _InstructionDisplayState extends State<InstructionDisplay> {
  final instructionController = InstructionController.singleton;

  final widgetHeight = 100.0;
  final widgetWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widgetWidth,
      height: widgetHeight,
      decoration: BoxDecoration(color: Colors.white),

      child: Column(
        children: [
          Text(
            "Type: ${instructionController.instruction.instructionType.name}",
          ),
          Text("Instruction: ${instructionController.instruction.dispatchKey}"),
          Text(
            "rd: ${instructionController.instruction.instrRegSelMapping[RegSel.rd]!.name}",
          ),
          Text(
            "rs1: ${instructionController.instruction.instrRegSelMapping[RegSel.rs1]!.name}",
          ),
          Text(
            "rs2: ${instructionController.instruction.instrRegSelMapping[RegSel.rs2]!.name}",
          ),
        ],
      ),
    );
  }
}
