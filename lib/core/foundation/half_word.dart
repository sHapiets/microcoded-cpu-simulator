/* import 'package:microcoded_cpu_coe197/core/foundation/byte.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

class HalfWord extends Data {
  HalfWord({required super.intData}) {
    if (intData.bitLength > 16) {
      throw FormatException(
        '[HALF-WORD ERROR] --> Constructed HalfWord exceeds 16 bits.',
      );
    }
  }

  int asSignedInt() {
    return intData.toSigned(16);
  }

  int asUnsignedInt() {
    return intData;
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
  /* 
  factory HalfWord.fromSignedHexString(String hexString) {
    final int intData = int.parse(hexString, radix: 16).toSigned(32);
    return HalfWord(intData: intData);
  }

  factory HalfWord.fromSignedBitString(String bitString) {
    final int intData = int.parse(bitString, radix: 2).toSigned(32);
    return HalfWord(intData: intData);
  } */

  factory HalfWord.fromUnsignedHexString(String hexString) {
    final int intData = int.parse(hexString, radix: 16).toUnsigned(16);
    return HalfWord(intData: intData);
  }

  factory HalfWord.fromUnsignedBitString(String bitString) {
    final int intData = int.parse(bitString, radix: 2).toUnsigned(16);
    return HalfWord(intData: intData);
  }
}
 */
