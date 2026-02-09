import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/word.dart';

class InstructionRegister extends Component {
  InstructionRegister._();
  static final singleton = InstructionRegister._();

  final bus = Bus.singleton;

  Word instrWord = Word.zero();
  bool loadEnable = false;

  void setLoadEnable(bool enableBool) {
    loadEnable = enableBool;
  }

  Word getInstrWord() {
    return instrWord;
  }

  void setInstrWord(Word newInstrWord) {
    instrWord = newInstrWord;
  }

  @override
  void readBus() {
    if (loadEnable) {
      final busData = bus.getData().asWord();
      setInstrWord(busData);
    }
    super.readBus();
  }
}
