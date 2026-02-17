import 'package:microcoded_cpu_coe197/core/controller/instruction_controller.dart';
import 'package:microcoded_cpu_coe197/core/controller/microcode_controller.dart';
import 'package:microcoded_cpu_coe197/core/controller/signal_controller.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/alu.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/a.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/b.dart';
import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/memory/memory.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/immediate_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/registers/instruction_register.dart';
import 'package:microcoded_cpu_coe197/core/datapath/registers/register_file.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/runtime_state_manager.dart';

class RuntimeController {
  RuntimeController._();
  static final singleton = RuntimeController._();

  final instructionController = InstructionController.singleton;
  final microcodeController = MicrocodeController.singleton;
  final signalController = SignalController.singleton;

  final a = A.singleton;
  final b = B.singleton;
  final alu = ALU.singleton;
  final registerFile = RegisterFile.singleton;
  final instructionRegister = InstructionRegister.singleton;
  final immediateMultiplexer = ImmediateMultiplexer.singleton;
  final memory = Memory.singleton;
  final bus = Bus.singleton;

  final runtimeStateManager = RuntimeStateManager.singleton;

  void updateState() {
    final nextMicrocodeLine = microcodeController.microcodePC.unsignedInt;
    final nextBranchType = microcodeController.branchType;
    runtimeStateManager.updateMicrocodeState(
      runtimeCycles,
      nextMicrocodeLine,
      nextBranchType,
    );

    final newInstruction = instructionController.instruction;
    runtimeStateManager.updateInstructionState(newInstruction);
  }

  int runtimeCycles = 0;

  void runCycle() {
    runtimeCycles++;
    instructionController.readComponents();
    bus.resetAllBuffers();
    signalController.updateComponents();
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
    immediateMultiplexer.readBus();

    microcodeController.update();
    updateState();
    /* 
    debugPrint(
      "instr: ${instructionController.instruction.instrWord.asBitString(32)}",
    );
    debugPrint("ldIR: ${instructionRegister.loadEnable}"); */
    //debugPrint("${memory.memoryAddress.asBitString(32)}");
  }
}
