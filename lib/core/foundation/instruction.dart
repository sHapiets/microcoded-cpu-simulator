import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/immediate_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/register_address.dart';
import 'package:microcoded_cpu_coe197/core/foundation/riscv_decoder.dart';
import 'package:microcoded_cpu_coe197/core/foundation/word.dart';

class Instruction extends Data {
  Instruction({required this.instrWord, required this.instructionType})
    : super(intData: instrWord.intData) {
    switch (instructionType) {
      case InstructionType.typeRISCV:
        final RISCVInstruction instruction = RISCVDecoder.instructionFromWord(
          instrWord,
        );
        dispatchKey = instruction.name;
        instrRegSelMapping = RISCVDecoder.instrRegSelMapFromWord(
          instrWord,
          instruction.opCodeType,
        );
        instrImmSelMapping = RISCVDecoder.instrImmSelMapFromWord(
          instrWord,
          instruction.opCodeType,
        );

      default:
        throw FormatException('[UNFIXED]');
    }
  }

  final Word instrWord;
  late final String dispatchKey;
  late final InstructionType instructionType;
  late final Map<RegSel, RegisterAddress> instrRegSelMapping;
  late final Map<ImmSel, Data> instrImmSelMapping;

  factory Instruction.nopRISCV() {
    return Instruction(
      instrWord: Word.zero(),
      instructionType: InstructionType.typeRISCV,
    );
  }
}

enum InstructionType { typeRISCV, nullArchitecture }
