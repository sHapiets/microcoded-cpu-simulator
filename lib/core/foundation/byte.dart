/* import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

class Byte extends Data {
  Byte({required super.intData}) {
    if (intData.bitLength > 8) {
      throw FormatException(
        '[BYTE ERROR] --> Constructed Byte exceeds 8 bits.',
      );
    }
  }

  int asSignedInt() {
    return intData.toSigned(8);
  }

  int asUnsignedInt() {
    return intData;
  }

  factory Byte.zero() {
    return Byte(intData: 0);
  }

  factory Byte.four() {
    return Byte(intData: 4);
  }
  /* 

  factory Byte.fromSignedHexString(String hexString) {
    final int intData = int.parse(hexString, radix: 16).toSigned(8);
    return Byte(intData: intData);
  }

  factory Byte.fromSignedBitString(String bitString) {
    final int intData = int.parse(bitString, radix: 2).toSigned(8);
    return Byte(intData: intData);
  } */

  factory Byte.fromUnsignedHexString(String hexString) {
    final int intData = int.parse(hexString, radix: 16).toUnsigned(8);
    return Byte(intData: intData);
  }

  factory Byte.fromUnsignedBitString(String bitString) {
    final int intData = int.parse(bitString, radix: 2).toUnsigned(8);
    return Byte(intData: intData);
  }
}
 */
