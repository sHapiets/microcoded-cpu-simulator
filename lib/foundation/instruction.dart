import 'package:microcoded_cpu_coe197/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/foundation/data.dart';
import 'package:microcoded_cpu_coe197/foundation/register_address.dart';
import 'package:microcoded_cpu_coe197/foundation/word.dart';

class Instruction {
  Instruction({required this.instrWord}) {
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
        instrRegSelMapping = {
          RegSel.pc: RegisterAddress.pc,
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.fromData(instrDiv[4]),
        };
        final functString =
            "${instrDiv[2].asBitString(3)}${instrDiv[5].asBitString(7)}";
        switch (functString) {
          case "0000000000":
            instructionType = InstructionType.add;
          default:
            throw FormatException(
              '[INSTRUCTION ERROR] --> R-type Instruction (functString: $functString)does not exist',
            );
        }

      default:
        throw FormatException('[INSTRUCTION ERROR] --> OpCode does not exist');
    }
  }

  final Word instrWord;
  late final InstructionType instructionType;
  late final Map<RegSel, RegisterAddress>? instrRegSelMapping;

  factory Instruction.empty() {
    return Instruction(instrWord: Word.zero());
  }
}

enum OpCodeType { R, I, xI, S, B, U, J, E }

enum InstructionType {
  add(opCodeType: OpCodeType.R),
  sub(opCodeType: OpCodeType.R);

  const InstructionType({required this.opCodeType});
  final OpCodeType opCodeType;
}
