import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/immediate_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/register_address.dart';

class RISCVDecoder {
  static RISCVInstruction instructionFromWord(Data instrWord) {
    List<Data> instrDiv = [
      Data.word(instrWord.asUnsignedInt() & 0x7F),
      Data.word((instrWord.asUnsignedInt() >> 7) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 12) & 0x7),
      Data.word((instrWord.asUnsignedInt() >> 15) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 20) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 25) & 0x7F),
    ];

    String opCodeString = instrDiv[0].asUnsignedBitString(7);
    switch (opCodeString) {
      case "0110011":
        final functString =
            "${instrDiv[2].asUnsignedBitString(3)}${instrDiv[5].asUnsignedBitString(7)}";
        switch (functString) {
          case "0000000000":
            return RISCVInstruction.add;
          case "0000100000":
            return RISCVInstruction.sub;
          case "1110000000":
            return RISCVInstruction.and;
          case "1100000000":
            return RISCVInstruction.or;
          case "1000000000":
            return RISCVInstruction.xor;
          case "0010000000":
            return RISCVInstruction.sll;
          case "1010000000":
            return RISCVInstruction.srl;
          case "1010100000":
            return RISCVInstruction.sra;
          case "0100000000":
            return RISCVInstruction.slt;
          case "0110000000":
            return RISCVInstruction.sltu;
          default:
            throw FormatException(
              '[RISCV-INSTRUCTION ERROR] --> R-type Instruction of FUNCT3|FUNCT7: (functString: $functString) does not exist. Check loaded instruction.',
            );
        }

      case "0010011":
        final String funct3string = instrDiv[2].asUnsignedBitString(3);
        String funct7string = "";
        if (funct3string == "001" || funct3string == "101") {
          funct7string = instrDiv[5].asUnsignedBitString(7);
        }

        final functString = "$funct3string$funct7string";
        switch (functString) {
          case "000":
            return RISCVInstruction.addi;
          case "111":
            return RISCVInstruction.andi;
          case "110":
            return RISCVInstruction.ori;
          case "100":
            return RISCVInstruction.xori;
          case "0010000000":
            return RISCVInstruction.slli;
          case "1010000000":
            return RISCVInstruction.srli;
          case "1010100000":
            return RISCVInstruction.srai;
          case "010":
            return RISCVInstruction.slti;
          case "011":
            return RISCVInstruction.sltiu;
          default:
            throw FormatException(
              '[RISCV-INSTRUCTION ERROR] --> I-type Instruction of FUNCT3|FUNCT7: (functString: $functString) does not exist. Check loaded instruction.',
            );
        }
      case "0000011":
        final funct3string = instrDiv[2].asUnsignedBitString(3);
        switch (funct3string) {
          case "000":
            return RISCVInstruction.lb;
          case "100":
            return RISCVInstruction.lbu;
          case "001":
            return RISCVInstruction.lh;
          case "101":
            return RISCVInstruction.lhu;
          case "010":
            return RISCVInstruction.lw;
          default:
            throw FormatException(
              '[RISCV-INSTRUCTION ERROR] --> I-type LOAD Instruction of FUNCT3: (functString: $funct3string) does not exist. Check loaded instruction.',
            );
        }

      case "0100011":
        final String funct3string = instrDiv[2].asUnsignedBitString(3);
        switch (funct3string) {
          case "000":
            return RISCVInstruction.sb;
          case "001":
            return RISCVInstruction.sh;
          case "010":
            return RISCVInstruction.sw;
          default:
            throw FormatException(
              '[RISCV-INSTRUCTION ERROR] --> S-type Instruction of FUNCT3: (functString: $funct3string) does not exist. Check loaded instruction.',
            );
        }

      case "0000000":
        return RISCVInstruction.nop;

      default:
        throw FormatException(
          '[RISCV-INSTRUCTION ERROR] --> OpCode: "$opCodeString" does not exist. Check loaded instruction',
        );
    }
  }

  static Map<RegSel, RegisterAddress> instrRegSelMapFromWord(
    Data instrWord,
    RISCVOpCodeType opcode,
  ) {
    List<Data> instrDiv = [
      Data.word(instrWord.asUnsignedInt() & 0x7F),
      Data.word((instrWord.asUnsignedInt() >> 7) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 12) & 0x7),
      Data.word((instrWord.asUnsignedInt() >> 15) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 20) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 25) & 0x7F),
    ];

    switch (opcode) {
      case RISCVOpCodeType.R:
        return {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.fromData(instrDiv[4]),
        };
      case RISCVOpCodeType.I:
        return {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.x0,
        };
      case RISCVOpCodeType.xI:
        return {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.x0,
        };
      case RISCVOpCodeType.S:
        return {
          RegSel.rd: RegisterAddress.x0,
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.fromData(instrDiv[4]),
        };
      case RISCVOpCodeType.B:
        return {
          RegSel.rd: RegisterAddress.x0,
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.fromData(instrDiv[4]),
        };
      case RISCVOpCodeType.U:
        return {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.x0,
          RegSel.rs2: RegisterAddress.x0,
        };
      case RISCVOpCodeType.J:
        return {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.x0,
          RegSel.rs2: RegisterAddress.x0,
        };

      case RISCVOpCodeType.E:
        return {
          RegSel.rd: RegisterAddress.x0,
          RegSel.rs1: RegisterAddress.x0,
          RegSel.rs2: RegisterAddress.x0,
        };
    }
  }

  static Map<ImmSel, Data> instrImmSelMapFromWord(
    Data instrWord,
    RISCVOpCodeType opcode,
  ) {
    List<Data> instrDiv = [
      Data.word(instrWord.asUnsignedInt() & 0x7F),
      Data.word((instrWord.asUnsignedInt() >> 7) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 12) & 0x7),
      Data.word((instrWord.asUnsignedInt() >> 15) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 20) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 25) & 0x7F),
    ];

    final I =
        "${instrDiv[5].asUnsignedBitString(7)}${instrDiv[4].asUnsignedBitString(5)}";
    final xI = instrDiv[4].asUnsignedBitString(5);
    final S =
        "${instrDiv[5].asUnsignedBitString(7)}${instrDiv[1].asUnsignedBitString(5)}";

    return {
      ImmSel.immTypeI: Data.fromUnsignedBitString(I, DataType.word),
      ImmSel.immTypeXI: Data.fromUnsignedBitString(xI, DataType.word),
      ImmSel.immTypeS: Data.fromUnsignedBitString(S, DataType.word),
    };
  }
}

enum RISCVOpCodeType { R, I, xI, S, B, U, J, E }

enum RISCVInstruction {
  nop(opCodeType: RISCVOpCodeType.E),

  add(opCodeType: RISCVOpCodeType.R),
  sub(opCodeType: RISCVOpCodeType.R),
  and(opCodeType: RISCVOpCodeType.R),
  or(opCodeType: RISCVOpCodeType.R),
  xor(opCodeType: RISCVOpCodeType.R),
  sll(opCodeType: RISCVOpCodeType.R),
  srl(opCodeType: RISCVOpCodeType.R),
  sra(opCodeType: RISCVOpCodeType.R),
  slt(opCodeType: RISCVOpCodeType.R),
  sltu(opCodeType: RISCVOpCodeType.R),

  addi(opCodeType: RISCVOpCodeType.I),
  andi(opCodeType: RISCVOpCodeType.I),
  ori(opCodeType: RISCVOpCodeType.I),
  xori(opCodeType: RISCVOpCodeType.I),
  slli(opCodeType: RISCVOpCodeType.I),
  srli(opCodeType: RISCVOpCodeType.I),
  srai(opCodeType: RISCVOpCodeType.I),
  slti(opCodeType: RISCVOpCodeType.I),
  sltiu(opCodeType: RISCVOpCodeType.I),

  lb(opCodeType: RISCVOpCodeType.I),
  lbu(opCodeType: RISCVOpCodeType.I),
  lh(opCodeType: RISCVOpCodeType.I),
  lhu(opCodeType: RISCVOpCodeType.I),
  lw(opCodeType: RISCVOpCodeType.I),

  sb(opCodeType: RISCVOpCodeType.S),
  sh(opCodeType: RISCVOpCodeType.S),
  sw(opCodeType: RISCVOpCodeType.S),

  lui(opCodeType: RISCVOpCodeType.U);

  const RISCVInstruction({required this.opCodeType});
  final RISCVOpCodeType opCodeType;
}
