import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

class Byte extends Data {
  Byte({required super.intData}) {
    if (intData.bitLength > 8) {
      throw FormatException(
        '[BYTE ERROR] --> Constructed Byte exceeds 8 bits.',
      );
    }
  }

  factory Byte.zero() {
    return Byte(intData: 0);
  }

  factory Byte.four() {
    return Byte(intData: 4);
  }

  factory Byte.fromHexString(String hexString) {
    final int intData = int.parse(hexString, radix: 16);
    return Byte(intData: intData);
  }
}
