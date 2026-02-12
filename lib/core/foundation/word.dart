/* import 'package:microcoded_cpu_coe197/core/foundation/byte.dart';
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

  int asSignedInt() {
    return intData.toSigned(32);
  }

  int asUnsignedInt() {
    return intData;
  }

  factory Word.zero() {
    return Word(intData: 0);
  }

  factory Word.one() {
    return Word(intData: 1);
  }

  factory Word.fromBytes(List<Byte> orderedBytesLittleEndian) {
    int sumIntData = 0;
    sumIntData += orderedBytesLittleEndian[0].asUnsignedInt();
    sumIntData += orderedBytesLittleEndian[1].asUnsignedInt() << 8;
    sumIntData += orderedBytesLittleEndian[2].asUnsignedInt() << 16;
    sumIntData += orderedBytesLittleEndian[3].asUnsignedInt() << 24;
    return Word(intData: sumIntData);
  }

  /* 
  factory Word.fromSignedHexString(String hexString) {
    final int intData = int.parse(hexString, radix: 16).toSigned(32);
    return Word(intData: intData);
  }

  factory Word.fromSignedBitString(String bitString) {
    final int intData = int.parse(bitString, radix: 2).toSigned(32);
    return Word(intData: intData);
  } */

  factory Word.fromUnsignedHexString(String hexString) {
    final int intData = int.parse(hexString, radix: 16).toUnsigned(32);
    return Word(intData: intData);
  }

  factory Word.fromUnsignedBitString(String bitString) {
    final int intData = int.parse(bitString, radix: 2).toUnsigned(32);
    return Word(intData: intData);
  }
}
 */
