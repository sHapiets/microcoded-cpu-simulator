import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

enum ALUOperation {
  copyA,
  copyB,
  inc1toA,
  dec1toA,
  inc4toA,
  dec4toA,
  add,
  sub,
  slt,
  sltu,
  sra,
  srl,
  sll,
  bitXOR,
  bitOR,
  bitAND;

  const ALUOperation();
  static const fromIntDataMapping = {
    0: ALUOperation.copyA,
    1: ALUOperation.copyB,
    2: ALUOperation.inc1toA,
    3: ALUOperation.dec1toA,
    4: ALUOperation.inc4toA,
    5: ALUOperation.dec4toA,
    6: ALUOperation.add,
    7: ALUOperation.sub,
    8: ALUOperation.slt,
    9: ALUOperation.sltu,
    10: ALUOperation.sra,
    11: ALUOperation.srl,
    12: ALUOperation.sll,
    13: ALUOperation.bitXOR,
    14: ALUOperation.bitOR,
    15: ALUOperation.bitAND,
  };

  factory ALUOperation.fromData(Data data) {
    final ALUOperation? aluOp = fromIntDataMapping[data.intData];

    if (aluOp == null) {
      throw FormatException(
        '[ALUOPERATION ERROR] --> Data.intData: ${data.intData} does not map to a valid ALUOperation. Check ROM ALUOp.',
      );
    }

    return aluOp;
  }
}
