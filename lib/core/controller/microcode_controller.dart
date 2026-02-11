import 'package:microcoded_cpu_coe197/core/controller/instruction_controller.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/word.dart';
import 'package:flutter/services.dart' show rootBundle;

class MicrocodeController {
  MicrocodeController._();
  static final singleton = MicrocodeController._();

  Word microcodePC = Word.zero();
  Word jumpBranchAddress = Word.zero();
  List<Map<MicrocodeSignal, Data>> microcodeROM = [];
  Map<String, Word> dispatchMap = {};

  Map<MicrocodeSignal, Data> getSignals() {
    return microcodeROM[microcodePC.intData];
  }

  void setJumpBranchAddress(Word address) {
    jumpBranchAddress = address;
  }

  Future<void> updateMicrocodeROM(String romPath) async {
    final romString = await rootBundle.loadString(romPath);
    final List<String> uInstrStrings = romString.split('\n');

    for (String uInstrString in uInstrStrings) {
      List<String> uSignalStrings = uInstrString.split('!');
      Map<MicrocodeSignal, Data> uSignals = {};

      uSignals[MicrocodeSignal.ldIR] = Data.fromHexString(uSignalStrings[0]);
      uSignals[MicrocodeSignal.regSel] = Data.fromHexString(uSignalStrings[1]);
      uSignals[MicrocodeSignal.regWrite] = Data.fromHexString(
        uSignalStrings[2],
      );
      uSignals[MicrocodeSignal.regBuffer] = Data.fromHexString(
        uSignalStrings[3],
      );
      uSignals[MicrocodeSignal.aLoad] = Data.fromHexString(uSignalStrings[4]);
      uSignals[MicrocodeSignal.bLoad] = Data.fromHexString(uSignalStrings[5]);
      uSignals[MicrocodeSignal.aluOperation] = Data.fromHexString(
        uSignalStrings[6],
      );
      uSignals[MicrocodeSignal.aluBuffer] = Data.fromHexString(
        uSignalStrings[7],
      );
      uSignals[MicrocodeSignal.ldMA] = Data.fromHexString(uSignalStrings[8]);
      uSignals[MicrocodeSignal.memWr] = Data.fromHexString(uSignalStrings[9]);
      uSignals[MicrocodeSignal.memBuffer] = Data.fromHexString(
        uSignalStrings[10],
      );
      uSignals[MicrocodeSignal.immSel] = Data.fromHexString(uSignalStrings[11]);
      uSignals[MicrocodeSignal.immBuffer] = Data.fromHexString(
        uSignalStrings[12],
      );
      uSignals[MicrocodeSignal.uBr] = Data.fromHexString(uSignalStrings[13]);
      uSignals[MicrocodeSignal.jump] = Data.fromHexString(uSignalStrings[14]);

      microcodeROM.add(uSignals);
    }
  }

  Future<void> updateDispatchMap(String dispatchTablePath) async {
    final dispatchTableString = await rootBundle.loadString(dispatchTablePath);
    final List<String> dispatchMappingEntry = dispatchTableString.split("\n");

    for (String dispatchEntry in dispatchMappingEntry) {
      final instrTypeString = dispatchEntry.split(">>")[0];
      final microcodeAddressString = dispatchEntry.split(">>")[1];

      final microcodeAddress = Data.fromHexString(
        microcodeAddressString,
      ).asWord();
      /* 
      final instructionType = InstructionType.values.firstWhere(
        (type) => instrTypeString == type.name,
        orElse: () {
          throw FormatException(
            "[DISPATCH TABLE ERROR] --> The instruction: $instrTypeString is not defined. Check loaded dispatch table.",
          );
        },
      ); */
      /* 
      dispatchMap.update(
        instructionType.name,
        (_) => microcodeAddress,
        ifAbsent: () => microcodeAddress,
      ); */

      dispatchMap.update(
        instrTypeString,
        (_) => microcodeAddress,
        ifAbsent: () => microcodeAddress,
      );
    }
  }

  Future<void> initializePreset() async {
    await updateMicrocodeROM('lib/rom/riscv_preset/microcoded_rom.ucr');
    await updateDispatchMap('lib/rom/riscv_preset/dispatch_table.ucd');
  }

  void branch(MicrocodeBranchType branchType) {
    switch (branchType) {
      case MicrocodeBranchType.next:
        microcodePC = microcodePC + Word.one();

      case MicrocodeBranchType.spin:
        microcodePC = microcodePC + Word.one();

      case MicrocodeBranchType.dispatch:
        /* 
        final instructionType =
            InstructionController.singleton.instruction.instructionType; */
        final instructionController = InstructionController.singleton;
        final instructionType = instructionController.instruction.dispatchKey;
        final dispatchAddress = dispatchMap[instructionType];
        if (dispatchAddress == null) {
          throw FormatException(
            '[DISPATCH TABLE ERROR] --> Instruction Type: "$instructionType" exists, but is not mapped to an address in the dispatched table. Check loaded dispatch table, and source code implementation MicrocodeController.',
          );
        } else {
          microcodePC = dispatchAddress;
        }

      case MicrocodeBranchType.jump:
        microcodePC = jumpBranchAddress;
    }
  }

  void initialize() {}
}

enum MicrocodeSignal {
  ldIR,
  regSel,
  regWrite,
  regBuffer,
  aLoad,
  bLoad,
  aluOperation,
  aluBuffer,
  ldMA,
  memWr,
  memBuffer,
  immSel,
  immBuffer,
  uBr,
  jump,
}

enum MicrocodeBranchType {
  next,
  spin,
  dispatch,
  jump;

  const MicrocodeBranchType();
  static const Map<int, MicrocodeBranchType> fromIntDataMapping = {
    0: MicrocodeBranchType.next,
    1: MicrocodeBranchType.jump,
    4: MicrocodeBranchType.dispatch,
    5: MicrocodeBranchType.spin,
  };

  factory MicrocodeBranchType.fromData(Data data) {
    final branch = fromIntDataMapping[data.intData];

    if (branch == null) {
      throw FormatException(
        '[MICROCODE ERROR] --> Data.intData: ${data.intData} does not have a mapped branch type. Check the loaded ROM.',
      );
    } else {
      return branch;
    }
  }
}
