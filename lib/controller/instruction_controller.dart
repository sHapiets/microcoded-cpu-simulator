import 'package:microcoded_cpu_coe197/controller/controller.dart';
import 'package:microcoded_cpu_coe197/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/datapath/registers/instruction_register.dart';
import 'package:microcoded_cpu_coe197/foundation/instruction.dart';

class InstructionController extends Controller {
  InstructionController._();
  static final singleton = InstructionController._();

  final instructionRegister = InstructionRegister.singleton;
  final regSelMultiplexer = RegSelMultiplexer.singleton;

  Instruction instruction = Instruction.empty();

  void updateInstruction() {
    final instrWord = instructionRegister.getInstrWord();
    instruction = Instruction(instrWord: instrWord);
  }

  void updateRegSelMultiplexer() {}

  @override
  void updateComponents() {
    updateInstruction();
    updateRegSelMultiplexer();
    super.updateComponents();
  }
}
