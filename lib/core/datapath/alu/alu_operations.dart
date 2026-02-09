import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

enum ALUOperation {
  copyA,
  inc4toA,
  add,
  sub;

  const ALUOperation();
  static const fromIntDataMapping = {
    0: copyA,
    4: inc4toA,
    6: ALUOperation.add,
    7: ALUOperation.sub,
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
