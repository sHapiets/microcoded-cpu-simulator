import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/controller/microcode_controller.dart';
import 'package:microcoded_cpu_coe197/core/foundation/instruction.dart';

class RuntimeStateManager {
  RuntimeStateManager._();
  static final singleton = RuntimeStateManager._();

  ValueNotifier<int> runtimeCycles = ValueNotifier(0);
  ValueNotifier<int> currentMicrocodeLine = ValueNotifier(0);
  ValueNotifier<int> nextMicrocodeLine = ValueNotifier(0);
  ValueNotifier<MicrocodeBranchType> branchType = ValueNotifier(
    MicrocodeBranchType.next,
  );
  ValueNotifier<Instruction> currentInstruction = ValueNotifier(
    Instruction.nopRISCV(),
  );

  void updateMicrocodeState(
    int runCyclesInt,
    int nextMicrocodeLineInt,
    MicrocodeBranchType newBranchType,
  ) {
    runtimeCycles.value = runCyclesInt;
    currentMicrocodeLine.value = nextMicrocodeLine.value;
    nextMicrocodeLine.value = nextMicrocodeLineInt;
    branchType.value = newBranchType;
  }

  void updateInstructionState(Instruction newInstruction) {
    currentInstruction.value = newInstruction;
  }
}
