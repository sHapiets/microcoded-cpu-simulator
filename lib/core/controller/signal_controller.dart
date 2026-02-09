import 'package:microcoded_cpu_coe197/core/controller/controller.dart';
import 'package:microcoded_cpu_coe197/core/controller/microcode_controller.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/alu.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/alu_operations.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/a.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/b.dart';
import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/memory/memory.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/immediate_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/registers/instruction_register.dart';
import 'package:microcoded_cpu_coe197/core/datapath/registers/register_file.dart';

class SignalController extends Controller {
  SignalController._();
  static final singleton = SignalController._();

  final bus = Bus.singleton;
  final alu = ALU.singleton;
  final instructionRegister = InstructionRegister.singleton;
  final registerFile = RegisterFile.singleton;
  final regSelMultiplexer = RegSelMultiplexer.singleton;
  final a = A.singleton;
  final b = B.singleton;
  final memory = Memory.singleton;
  final immediateMultiplexer = ImmediateMultiplexer.singleton;
  final microcodeController = MicrocodeController.singleton;

  void sendSignals() {
    final uCodeSignals = microcodeController.getSignals();

    for (MicrocodeSignal signal in uCodeSignals.keys) {
      final data = uCodeSignals[signal]!;

      switch (signal) {
        case MicrocodeSignal.ldIR:
          instructionRegister.setLoadEnable(data.asBit().asBool());
        case MicrocodeSignal.regSel:
          RegSel selectedRegSel = RegSel.fromData(data);
          regSelMultiplexer.setRegSel(selectedRegSel);
        case MicrocodeSignal.regWrite:
          registerFile.setWriteEnable(data.asBit().asBool());
        case MicrocodeSignal.regBuffer:
          bus.setBuffer(Buffer.regEn, data.asBit().asBool());
        case MicrocodeSignal.aLoad:
          a.setLoadEnable(data.asBit().asBool());
        case MicrocodeSignal.bLoad:
          b.setLoadEnable(data.asBit().asBool());
        case MicrocodeSignal.aluOperation:
          alu.operation = ALUOperation.fromData(data);
        case MicrocodeSignal.aluBuffer:
          bus.setBuffer(Buffer.aluEn, data.asBit().asBool());
        case MicrocodeSignal.ldMA:
          memory.setAddressLoadEnable(data.asBit().asBool());
        case MicrocodeSignal.memWr:
          memory.setMemWriteEnable(data.asBit().asBool());
        case MicrocodeSignal.memBuffer:
          bus.setBuffer(Buffer.memEn, data.asBit().asBool());
        case MicrocodeSignal.immSel:
          immediateMultiplexer.setImmSel(ImmSel.fromData(data));
        case MicrocodeSignal.immBuffer:
          bus.setBuffer(Buffer.immEn, data.asBit().asBool());
        case MicrocodeSignal.uBr:
          microcodeController.branch(MicrocodeBranchType.fromData(data));
        case MicrocodeSignal.jump:
          microcodeController.setJumpBranchAddress(data.asWord());
      }
    }
  }

  @override
  void updateComponents() {
    sendSignals();
    super.updateComponents();
  }
}
