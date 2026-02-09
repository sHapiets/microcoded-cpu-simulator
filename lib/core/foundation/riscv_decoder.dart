import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/word.dart';

class RISCVDecoder {
  static InstructionType instrTypeFromWord(Word instrWord) {
    List<Data> instrDiv = [
      Data(intData: instrWord.intData & 0x7F),
      Data(intData: (instrWord.intData >> 7) & 0x1F),
      Data(intData: (instrWord.intData >> 12) & 0x7),
      Data(intData: (instrWord.intData >> 15) & 0x1F),
      Data(intData: (instrWord.intData >> 20) & 0x1F),
      Data(intData: (instrWord.intData >> 25) & 0x7F),
    ];

    String opCodeString = instrDiv[0].asBitString(7);
    switch (opCodeString) {
      case "0110011":
        final functString =
            "${instrDiv[2].asBitString(3)}${instrDiv[5].asBitString(7)}";
        switch (functString) {
          case "0000000000":
            return InstructionType.add;
          case "0000100000":
            return InstructionType.sub;
          default:
            throw FormatException(
              '[INSTRUCTION ERROR] --> R-type Instruction (functString: $functString)does not exist',
            );
        }

      case "0000000":
        return InstructionType.nop;

      default:
        throw FormatException(
          '[INSTRUCTION ERROR] --> OpCode: $opCodeString does not exist',
        );
    }
  }
}

enum OpCodeType { R, I, xI, S, B, U, J, E }

enum InstructionType {
  nop(opCodeType: OpCodeType.E),
  add(opCodeType: OpCodeType.R),
  sub(opCodeType: OpCodeType.R);

  const InstructionType({required this.opCodeType});
  final OpCodeType opCodeType;
}
