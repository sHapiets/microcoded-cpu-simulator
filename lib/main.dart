import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/controller/microcode_controller.dart';
import 'package:microcoded_cpu_coe197/core/controller/runtime_controller.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/alu.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/a.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/b.dart';
import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/memory/memory.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/registers/register_file.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/instruction.dart';
import 'package:microcoded_cpu_coe197/layout/processor/instruction_display.dart';
import 'package:microcoded_cpu_coe197/layout/main_page.dart';
import 'package:microcoded_cpu_coe197/layout/processor/memory_widget.dart';

void main() {
  runApp(const GlobalApp());
}

class GlobalApp extends StatefulWidget {
  const GlobalApp({super.key});

  @override
  State<GlobalApp> createState() => _GlobalAppState();
}

class _GlobalAppState extends State<GlobalApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microcoded CPU Simulator',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      home: MainPage(),
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
  final alu = ALU.singleton;
  final registerFile = RegisterFile.singleton;
  final regSelMultiplexer = RegSelMultiplexer.singleton;
  final microcodeController = MicrocodeController.singleton;
  final bus = Bus.singleton;

  @override
  void initState() {
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

  void _incrementCounter() {
    setState(() {
      RuntimeController.singleton.runCycle();
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
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
                      instrWord: Data.fromUnsignedBitString(
                        value,
                        DataType.word,
                      ),
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
                  child: Column(
                    children: [
                      Text(
                        "MircocodePC: ${MicrocodeController.singleton.microcodePC.asUnsignedInt()}",
                      ),
                      Text(
                        "Branch Type: ${MicrocodeController.singleton.branchType.name}",
                      ),
                    ],
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
                        Center(
                          child: Text("${register.value.asUnsignedInt()}"),
                        ),
                        Center(child: Text("${register.value.asSignedInt()}")),
                        Center(
                          child: Text(register.value.asUnsignedBitString(5)),
                        ),
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
                        Center(child: Text('UNSIGNED:')),
                        Center(child: Text('A: ${a.data.asUnsignedInt()}')),
                        Center(child: Text('B: ${b.data.asUnsignedInt()}')),
                      ],
                    ),
                    TableRow(
                      children: [
                        Center(child: Text('SIGNED:')),
                        Center(child: Text('A: ${a.data.asSignedInt()}')),
                        Center(child: Text('B: ${b.data.asSignedInt()}')),
                      ],
                    ),
                    TableRow(
                      children: [
                        Center(child: Text('TYPE:')),
                        Center(child: Text('A: ${a.data.dataType.name}')),
                        Center(child: Text('B: ${b.data.dataType.name}')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
