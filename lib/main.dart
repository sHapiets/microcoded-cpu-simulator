import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/controller/microcode_controller.dart';
import 'package:microcoded_cpu_coe197/controller/temp_controller.dart';
import 'package:microcoded_cpu_coe197/datapath/alu/operands/a.dart';
import 'package:microcoded_cpu_coe197/datapath/alu/operands/b.dart';
import 'package:microcoded_cpu_coe197/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/datapath/registers/register_file.dart';
import 'package:microcoded_cpu_coe197/foundation/data.dart';
import 'package:microcoded_cpu_coe197/foundation/instruction.dart';
import 'package:microcoded_cpu_coe197/foundation/word.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'uCoded CPU Simulator',
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

  @override
  void initState() {
    microcodeController.initializePresetROM();
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
            alignment: AlignmentGeometry.topCenter,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration.collapsed(
                hintText: "put RISCV binary instruction word here",
              ),
              onSubmitted: (value) {
                final decodedInstruction = Instruction(
                  instrWord: Data.fromBitString(value).asWord(),
                );
                debugPrint(
                  "${decodedInstruction.instructionType.name}\n"
                  "rd: ${decodedInstruction.instrRegSelMapping![RegSel.rd]}\n"
                  "rs1: ${decodedInstruction.instrRegSelMapping![RegSel.rs1]}\n"
                  "rs2: ${decodedInstruction.instrRegSelMapping![RegSel.rs2]}\n",
                );
              },
            ),
          ),
          Align(
            alignment: AlignmentGeometry.topCenter,
            child: Transform.translate(
              offset: Offset(0, 50),
              child: Text("heloo"),
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

          Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Text(
                  'A: ${a.data.intData}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'B: ${b.data.intData}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'RegSel: ${regSelMultiplexer.regSel}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Reg[rd]: ${registerFile.registers[regSelMultiplexer.addressMapping[RegSel.rd]]!.intData}',
                  style: Theme.of(context).textTheme.headlineMedium,
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
