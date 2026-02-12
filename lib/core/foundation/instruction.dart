import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/immediate_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/register_address.dart';
import 'package:microcoded_cpu_coe197/core/foundation/riscv_decoder.dart';

class Instruction {
  Instruction({required this.instrWord, required this.instructionType}) {
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

  final Data instrWord;
  late final String dispatchKey;
  late final InstructionType instructionType;
  late final Map<RegSel, RegisterAddress> instrRegSelMapping;
  late final Map<ImmSel, Data> instrImmSelMapping;

  factory Instruction.nopRISCV() {
    return Instruction(
      instrWord: Data.wordZero(),
      instructionType: InstructionType.typeRISCV,
    );
  }
}

enum InstructionType { typeRISCV, nullArchitecture }
