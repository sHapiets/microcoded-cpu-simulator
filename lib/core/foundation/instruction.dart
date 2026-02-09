import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/immediate_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/register_address.dart';
import 'package:microcoded_cpu_coe197/core/foundation/riscv_decoder.dart';
import 'package:microcoded_cpu_coe197/core/foundation/word.dart';

class Instruction {
  Instruction({required this.instrWord}) {
    instructionType = RISCVDecoder.instrTypeFromWord(instrWord);

    List<Data> instrDiv = [
      Data(intData: instrWord.intData & 0x7F),
      Data(intData: (instrWord.intData >> 7) & 0x1F),
      Data(intData: (instrWord.intData >> 12) & 0x7),
      Data(intData: (instrWord.intData >> 15) & 0x1F),
      Data(intData: (instrWord.intData >> 20) & 0x1F),
      Data(intData: (instrWord.intData >> 25) & 0x7F),
    ];

    switch (instructionType.opCodeType) {
      case OpCodeType.R:
        instrRegSelMapping = {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.fromData(instrDiv[4]),
        };
      case OpCodeType.I:
        instrRegSelMapping = {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.x0,
        };
      case OpCodeType.xI:
        instrRegSelMapping = {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.x0,
        };
      case OpCodeType.S:
        instrRegSelMapping = {
          RegSel.rd: RegisterAddress.x0,
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.fromData(instrDiv[4]),
        };
      case OpCodeType.B:
        instrRegSelMapping = {
          RegSel.rd: RegisterAddress.x0,
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.fromData(instrDiv[4]),
        };
      case OpCodeType.U:
        instrRegSelMapping = {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.x0,
          RegSel.rs2: RegisterAddress.x0,
        };
      case OpCodeType.J:
        instrRegSelMapping = {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.x0,
          RegSel.rs2: RegisterAddress.x0,
        };

      case OpCodeType.E:
        instrRegSelMapping = {
          RegSel.rd: RegisterAddress.x0,
          RegSel.rs1: RegisterAddress.x0,
          RegSel.rs2: RegisterAddress.x0,
        };
    }

    final I = "${instrDiv[5].asBitString(7)}${instrDiv[4].asBitString(5)}";
    final xI = instrDiv[4].asBitString(5);
    final S = "${instrDiv[5].asBitString(7)}${instrDiv[1].asBitString(5)}";

    instrImmSelMapping = {
      ImmSel.immTypeI: Data.fromBitString(I),
      ImmSel.immTypeXI: Data.fromBitString(xI),
      ImmSel.immTypeS: Data.fromBitString(S),
    };
  }

  final Word instrWord;
  late final InstructionType instructionType;
  late final Map<RegSel, RegisterAddress> instrRegSelMapping;
  late final Map<ImmSel, Data> instrImmSelMapping;

  factory Instruction.empty() {
    return Instruction(instrWord: Word.zero());
  }
}
