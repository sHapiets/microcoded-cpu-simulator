import 'package:microcoded_cpu_coe197/core/controller/instruction_controller.dart';
import 'package:microcoded_cpu_coe197/core/controller/signal_controller.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/alu.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/a.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/b.dart';
import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/memory/memory.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/immediate_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/registers/instruction_register.dart';
import 'package:microcoded_cpu_coe197/core/datapath/registers/register_file.dart';

class TempController {
  TempController._();
  static final singleton = TempController._();

  final instructionController = InstructionController.singleton;

  final a = A.singleton;
  final b = B.singleton;
  final alu = ALU.singleton;
  final registerFile = RegisterFile.singleton;
  final instructionRegister = InstructionRegister.singleton;
  final immediateMultiplexer = ImmediateMultiplexer.singleton;
  final memory = Memory.singleton;
  final bus = Bus.singleton;

  void runInstructions(int counter) {
    instructionController.readComponents();
    bus.resetAllBuffers();
    SignalController.singleton.updateComponents();
    instructionController.updateComponents();

    alu.updateBus();
    a.updateBus();
    b.updateBus();
    registerFile.updateBus();
    memory.updateBus();
    instructionRegister.updateBus();
    immediateMultiplexer.updateBus();

    alu.readBus();
    a.readBus();
    b.readBus();
    registerFile.readBus();
    memory.readBus();
    instructionRegister.readBus();
    immediateMultiplexer.readBus(); /* 
    debugPrint(
      "instr: ${instructionController.instruction.instrWord.asBitString(32)}",
    );
    debugPrint("ldIR: ${instructionRegister.loadEnable}"); */
    //debugPrint("${memory.memoryAddress.asBitString(32)}");
  }
}
