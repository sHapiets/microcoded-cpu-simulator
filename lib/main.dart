import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/controller/microcode_controller.dart';
import 'package:microcoded_cpu_coe197/core/controller/temp_controller.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/a.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/b.dart';
import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/memory/memory.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/registers/register_file.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/instruction.dart';
import 'package:microcoded_cpu_coe197/layout/instruction_display.dart';
import 'package:microcoded_cpu_coe197/layout/memory_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microcoded CPU Simulator',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const TestDisplay(title: ''),
    );
  }
}

class TestDisplay extends StatefulWidget {
  const TestDisplay({super.key, required this.title});
  final String title;

  @override
  State<TestDisplay> createState() => _TestDisplayState();
}

class _TestDisplayState extends State<TestDisplay> {
  int counter = 0;
  final a = A.singleton;
  final b = B.singleton;
  final registerFile = RegisterFile.singleton;
  final regSelMultiplexer = RegSelMultiplexer.singleton;
  final microcodeController = MicrocodeController.singleton;
  final bus = Bus.singleton;

  @override
  void initState() {
    Memory.singleton.presetInstructionLoad();
    microcodeController.initializePreset();
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      TempController.singleton.runInstructions(counter);
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: AlignmentGeometry.bottomLeft,
            child: InstructionDisplay(),
          ),
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: MemoryWidget(),
          ),

          Align(
            alignment: AlignmentGeometry.center,
            child: Transform.translate(
              offset: Offset(0, 50),
              child: Table(
                defaultColumnWidth: FixedColumnWidth(100),
                children: [
                  TableRow(
                    children: bus.buffers.entries.map((buffer) {
                      return Text("${buffer.key.name}: ${buffer.value}");
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: AlignmentGeometry.topCenter,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration.collapsed(
                hintText: "put RISCV binary instruction word here",
              ),
              onSubmitted: (value) {
                final decodedInstruction = Instruction(
                  instrWord: Data.fromBitString(value).asWord(),
                  instructionType: InstructionType.typeRISCV,
                );
                debugPrint(
                  "${decodedInstruction.instructionType.name}\n"
                  "rd: ${decodedInstruction.instrRegSelMapping[RegSel.rd]}\n"
                  "rs1: ${decodedInstruction.instrRegSelMapping[RegSel.rs1]}\n"
                  "rs2: ${decodedInstruction.instrRegSelMapping[RegSel.rs2]}\n",
                );
              },
            ),
          ),
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: Transform.translate(
              offset: Offset(0, 50),
              child: Text(
                "Next MircocodePC: ${MicrocodeController.singleton.microcodePC.intData}",
              ),
            ),
          ),

          Align(
            alignment: AlignmentGeometry.centerLeft,
            child: Table(
              defaultColumnWidth: FixedColumnWidth(50),
              border: TableBorder.all(),
              children: registerFile.registers.entries.map((register) {
                return TableRow(
                  children: [
                    Center(child: Text(register.key.name)),
                    Center(child: Text("${register.value.intData}")),
                    Center(child: Text(register.value.asBitString(5))),
                  ],
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.center,
            child: Table(
              defaultColumnWidth: FixedColumnWidth(100),
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    Center(child: Text('A: ${a.data.intData}')),
                    Center(child: Text('B: ${b.data.intData}')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
