import 'package:microcoded_cpu_coe197/controller/microcode_controller.dart';
import 'package:microcoded_cpu_coe197/controller/signal_controller.dart';
import 'package:microcoded_cpu_coe197/datapath/alu/alu.dart';
import 'package:microcoded_cpu_coe197/datapath/alu/operands/a.dart';
import 'package:microcoded_cpu_coe197/datapath/alu/operands/b.dart';
import 'package:microcoded_cpu_coe197/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/datapath/registers/register_file.dart';
import 'package:microcoded_cpu_coe197/foundation/word.dart';

class TempController {
  TempController._();
  static final singleton = TempController._();

  final a = A.singleton;
  final b = B.singleton;
  final alu = ALU.singleton;

  final registerFile = RegisterFile.singleton;
  final bus = Bus.singleton;

  void runInstructions(int counter) {
    switch (counter) {
      case 0:
        SignalController.singleton.updateComponents();

        a.updateBus();
        b.updateBus();
        registerFile.updateBus();
        alu.updateBus();
        alu.readBus();
        a.readBus();
        b.readBus();
        registerFile.readBus();

        bus.resetAllBuffers();
        MicrocodeController.singleton.microcodePC += Word.one();
      case 1:
        SignalController.singleton.updateComponents();

        a.updateBus();
        b.updateBus();
        registerFile.updateBus();
        alu.updateBus();
        alu.readBus();
        a.readBus();
        b.readBus();
        registerFile.readBus();

        bus.resetAllBuffers();
        MicrocodeController.singleton.microcodePC += Word.one();
      case 2:
        SignalController.singleton.updateComponents();

        a.updateBus();
        b.updateBus();
        registerFile.updateBus();
        alu.updateBus();
        alu.readBus();
        a.readBus();
        b.readBus();
        registerFile.readBus();

        bus.resetAllBuffers();
        MicrocodeController.singleton.microcodePC += Word.one();
      default:
    }
  }
}
