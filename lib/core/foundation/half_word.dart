import 'package:microcoded_cpu_coe197/core/foundation/byte.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

class HalfWord extends Data {
  HalfWord({required super.intData}) {
    if (intData.bitLength > 16) {
      throw FormatException(
        '[HALF-WORD ERROR] --> Constructed HalfWord exceeds 16 bits.',
      );
    }
  }

  List<Byte> get byte {
    return [
      Byte(intData: intData & 0xFF),
      Byte(intData: (intData >> 8) & 0xFF),
    ];
  }

  factory HalfWord.zero() {
    return HalfWord(intData: 0);
  }

  factory HalfWord.one() {
    return HalfWord(intData: 1);
  }
}
