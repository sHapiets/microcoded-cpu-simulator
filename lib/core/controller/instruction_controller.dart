import 'package:microcoded_cpu_coe197/core/controller/controller.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/immediate_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/registers/instruction_register.dart';
import 'package:microcoded_cpu_coe197/core/foundation/instruction.dart';
import 'package:microcoded_cpu_coe197/core/foundation/word.dart';

class InstructionController extends Controller {
  InstructionController._();
  static final singleton = InstructionController._();

  final instructionRegister = InstructionRegister.singleton;
  final regSelMultiplexer = RegSelMultiplexer.singleton;
  final immediateMultiplexer = ImmediateMultiplexer.singleton;

  Instruction instruction = Instruction.empty();

  void updateInstruction() {
    final instrWord = instructionRegister.getInstrWord();
    instruction = Instruction(instrWord: instrWord);
  }

  void updateRegSelMultiplexer() {
    final regSelMap = instruction.instrRegSelMapping;
    for (RegSel regSel in regSelMap.keys) {
      regSelMultiplexer.updateAddressMapping(regSel, regSelMap[regSel]!);
    }
  }

  void updateImmMultiplexer() {
    final immSelMap = instruction.instrImmSelMapping;
    for (ImmSel immSel in immSelMap.keys) {
      immediateMultiplexer.updateImmediateMapping(immSel, immSelMap[immSel]!);
    }
  }

  @override
  void updateComponents() {
    updateRegSelMultiplexer();
    updateImmMultiplexer();
    super.updateComponents();
  }

  @override
  void readComponents() {
    updateInstruction();
    super.readComponents();
  }
}
