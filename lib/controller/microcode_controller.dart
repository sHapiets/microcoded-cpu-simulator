import 'package:microcoded_cpu_coe197/foundation/data.dart';
import 'package:microcoded_cpu_coe197/foundation/word.dart';
import 'package:flutter/services.dart' show rootBundle;

class MicrocodeController {
  MicrocodeController._();
  static final singleton = MicrocodeController._();

  Word microcodePC = Word.zero();
  List<Map<MicrocodeSignal, Data>> decodedROM = [];

  Future<void> updateDecodedROM(String romPath) async {
    final romString = await rootBundle.loadString(romPath);
    final List<String> uInstrStrings = romString.split('\n');

    for (String uInstrString in uInstrStrings) {
      List<String> uSignalStrings = uInstrString.split('!');
      Map<MicrocodeSignal, Data> uSignals = {};

      uSignals[MicrocodeSignal.regSel] = Data.fromHexString(uSignalStrings[1]);
      uSignals[MicrocodeSignal.regWrite] = Data.fromHexString(
        uSignalStrings[2],
      );
      uSignals[MicrocodeSignal.regEn] = Data.fromHexString(uSignalStrings[3]);
      uSignals[MicrocodeSignal.aLoad] = Data.fromHexString(uSignalStrings[4]);
      uSignals[MicrocodeSignal.bLoad] = Data.fromHexString(uSignalStrings[5]);
      uSignals[MicrocodeSignal.aluOperation] = Data.fromHexString(
        uSignalStrings[6],
      );
      uSignals[MicrocodeSignal.aluEn] = Data.fromHexString(uSignalStrings[7]);

      decodedROM.add(uSignals);
    }
  }

  Future<void> initializePresetROM() async {
    await updateDecodedROM('lib/rom/microcoded_rom.ucr');
  }

  void initialize() {}
}

enum MicrocodeSignal {
  regSel,
  regWrite,
  regEn,
  aLoad,
  bLoad,
  aluOperation,
  aluEn,
}
