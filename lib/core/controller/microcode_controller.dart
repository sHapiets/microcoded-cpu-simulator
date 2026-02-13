import 'package:microcoded_cpu_coe197/core/controller/instruction_controller.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/alu.dart';
import 'package:microcoded_cpu_coe197/core/datapath/memory/memory.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:flutter/services.dart' show rootBundle;

class MicrocodeController {
  MicrocodeController._();
  static final singleton = MicrocodeController._();

  final alu = ALU.singleton;
  final memory = Memory.singleton;

  Data microcodePC = Data.wordZero();
  MicrocodeBranchType branchType = MicrocodeBranchType.next;
  Data jumpBranchAddress = Data.wordZero();
  List<Map<MicrocodeSignal, Data>> microcodeROM = [];
  Map<String, Data> dispatchMap = {};

  Map<MicrocodeSignal, Data> getSignals() {
    return microcodeROM[microcodePC.asUnsignedInt()];
  }

  void setJumpBranchAddress(Data address) {
    jumpBranchAddress = address;
  }

  Future<void> updateMicrocodeROM(String romPath) async {
    final romString = await rootBundle.loadString(romPath);
    final List<String> uInstrStrings = romString.split('\n');

    for (String uInstrString in uInstrStrings) {
      List<String> uSignalStrings = uInstrString.split('!');
      Map<MicrocodeSignal, Data> uSignals = {};

      uSignals[MicrocodeSignal.ldIR] = Data.fromUnsignedHexString(
        uSignalStrings[0],
        DataType.word,
      );
      uSignals[MicrocodeSignal.regSel] = Data.fromUnsignedHexString(
        uSignalStrings[1],
        DataType.word,
      );
      uSignals[MicrocodeSignal.regWrite] = Data.fromUnsignedHexString(
        uSignalStrings[2],
        DataType.word,
      );
      uSignals[MicrocodeSignal.regBuffer] = Data.fromUnsignedHexString(
        uSignalStrings[3],
        DataType.word,
      );
      uSignals[MicrocodeSignal.aLoad] = Data.fromUnsignedHexString(
        uSignalStrings[4],
        DataType.word,
      );
      uSignals[MicrocodeSignal.bLoad] = Data.fromUnsignedHexString(
        uSignalStrings[5],
        DataType.word,
      );
      uSignals[MicrocodeSignal.aluOperation] = Data.fromUnsignedHexString(
        uSignalStrings[6],
        DataType.word,
      );
      uSignals[MicrocodeSignal.aluBuffer] = Data.fromUnsignedHexString(
        uSignalStrings[7],
        DataType.word,
      );
      uSignals[MicrocodeSignal.ldMA] = Data.fromUnsignedHexString(
        uSignalStrings[8],
        DataType.word,
      );
      uSignals[MicrocodeSignal.memWr] = Data.fromUnsignedHexString(
        uSignalStrings[9],
        DataType.word,
      );
      uSignals[MicrocodeSignal.memBuffer] = Data.fromUnsignedHexString(
        uSignalStrings[10],
        DataType.word,
      );
      uSignals[MicrocodeSignal.immSel] = Data.fromUnsignedHexString(
        uSignalStrings[11],
        DataType.word,
      );
      uSignals[MicrocodeSignal.immBuffer] = Data.fromUnsignedHexString(
        uSignalStrings[12],
        DataType.word,
      );
      uSignals[MicrocodeSignal.jump] = Data.fromUnsignedHexString(
        uSignalStrings[14],
        DataType.word,
      );
      uSignals[MicrocodeSignal.uBr] = Data.fromUnsignedHexString(
        uSignalStrings[13],
        DataType.word,
      );

      microcodeROM.add(uSignals);
    }
  }

  Future<void> updateDispatchMap(String dispatchTablePath) async {
    final dispatchTableString = await rootBundle.loadString(dispatchTablePath);
    final List<String> dispatchMappingEntry = dispatchTableString.split("\n");

    for (String dispatchEntry in dispatchMappingEntry) {
      final instrTypeString = dispatchEntry.split(">>")[0];
      final microcodeAddressString = dispatchEntry.split(">>")[1];

      final microcodeAddress = Data.fromUnsignedHexString(
        microcodeAddressString,
        DataType.word,
      );

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

  void setBranchType(MicrocodeBranchType newBranchType) {
    branchType = newBranchType;
  }

  void branch() {
    switch (branchType) {
      case MicrocodeBranchType.next:
        microcodePC = Data.word(microcodePC.unsignedInt + 1);

      case MicrocodeBranchType.spin:
        if (memory.isNotBusy()) {
          microcodePC = Data.word(microcodePC.unsignedInt + 1);
        }

      case MicrocodeBranchType.eqZero:
        final aluData = alu.getResult();
        if (aluData.asUnsignedInt() == 0) {
          microcodePC = jumpBranchAddress;
        } else {
          microcodePC = Data.word(microcodePC.unsignedInt + 1);
        }

      case MicrocodeBranchType.notEqZero:
        final aluData = alu.getResult();
        if (aluData.asUnsignedInt() != 0) {
          microcodePC = jumpBranchAddress;
        } else {
          microcodePC = Data.word(microcodePC.unsignedInt + 1);
        }

      case MicrocodeBranchType.dispatch:
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

  void update() {
    branch();
  }
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
  eqZero,
  notEqZero,
  dispatch,
  jump;

  const MicrocodeBranchType();
  static const Map<int, MicrocodeBranchType> fromIntDataMapping = {
    0: MicrocodeBranchType.next,
    1: MicrocodeBranchType.jump,
    2: MicrocodeBranchType.eqZero,
    3: MicrocodeBranchType.notEqZero,
    4: MicrocodeBranchType.dispatch,
    5: MicrocodeBranchType.spin,
  };

  factory MicrocodeBranchType.fromData(Data data) {
    final branch = fromIntDataMapping[data.asUnsignedInt()];

    if (branch == null) {
      throw FormatException(
        '[MICROCODE ERROR] --> Data.intData: ${data.asUnsignedInt()} does not have a mapped branch type. Check the loaded ROM.',
      );
    } else {
      return branch;
    }
  }
}
