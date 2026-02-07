import 'package:microcoded_cpu_coe197/controller/controller.dart';
import 'package:microcoded_cpu_coe197/controller/microcode_controller.dart';
import 'package:microcoded_cpu_coe197/datapath/alu/alu.dart';
import 'package:microcoded_cpu_coe197/datapath/alu/alu_operations.dart';
import 'package:microcoded_cpu_coe197/datapath/alu/operands/a.dart';
import 'package:microcoded_cpu_coe197/datapath/alu/operands/b.dart';
import 'package:microcoded_cpu_coe197/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/datapath/memory/memory.dart';
import 'package:microcoded_cpu_coe197/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/datapath/registers/register_file.dart';

class SignalController extends Controller {
  SignalController._();
  static final singleton = SignalController._();

  final bus = Bus.singleton;
  final alu = ALU.singleton;
  final registerFile = RegisterFile.singleton;
  final regSelMultiplexer = RegSelMultiplexer.singleton;
  final a = A.singleton;
  final b = B.singleton;
  final memory = Memory.singleton;

  final uCodeController = MicrocodeController.singleton;

  void sendSignals() {
    final uCodeSignals =
        uCodeController.decodedROM[uCodeController.microcodePC.intData];

    for (MicrocodeSignal signal in uCodeSignals.keys) {
      final data = uCodeSignals[signal]!;
      final enableBool = data.asBit().asBool();

      switch (signal) {
        case MicrocodeSignal.regSel:
          RegSel selectedRegSel = data.convertAsRegSel();
          regSelMultiplexer.setRegSel(selectedRegSel);
        case MicrocodeSignal.regWrite:
          registerFile.writeEnable = data.asBit().asBool();
        case MicrocodeSignal.regEn:
          bus.setBuffer(Buffer.regEn, enableBool);
        case MicrocodeSignal.aLoad:
          a.setLoadEnable(enableBool);
        case MicrocodeSignal.bLoad:
          b.setLoadEnable(enableBool);
        case MicrocodeSignal.aluOperation:
          alu.operation = ALUOperation.values[data.intData];
        case MicrocodeSignal.aluEn:
          bus.setBuffer(Buffer.aluEn, enableBool);
      }
    }
  }

  @override
  void updateComponents() {
    sendSignals();
    super.updateComponents();
  }
}
