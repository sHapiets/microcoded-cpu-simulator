import 'package:microcoded_cpu_coe197/core/foundation/byte.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

class Word extends Data {
  Word({required super.intData}) {
    if (intData.bitLength > 32) {
      throw FormatException(
        '[WORD ERROR] --> Constructed Word exceeds 32 bits.',
      );
    }
  }

  List<Byte> get byte {
    return [
      Byte(intData: intData & 0xFF),
      Byte(intData: (intData >> 8) & 0xFF),
      Byte(intData: (intData >> 16) & 0xFF),
      Byte(intData: (intData >> 24) & 0xFF),
    ];
  }

  factory Word.zero() {
    return Word(intData: 0);
  }

  factory Word.one() {
    return Word(intData: 1);
  }

  factory Word.fromBytes(List<Byte> orderedBytesLittleEndian) {
    int sumIntData = 0;
    sumIntData += orderedBytesLittleEndian[0].intData;
    sumIntData += orderedBytesLittleEndian[1].intData << 8;
    sumIntData += orderedBytesLittleEndian[2].intData << 16;
    sumIntData += orderedBytesLittleEndian[3].intData << 24;
    return Word(intData: sumIntData);
  }

  @override
  Word operator +(Data other) {
    return Word(intData: intData + other.intData);
  }
}
