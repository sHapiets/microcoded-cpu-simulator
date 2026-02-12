/* import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

class Bit extends Data {
  Bit({required super.intData}) {
    if (intData.bitLength > 1) {
      throw FormatException('[BIT ERROR] --> Constructed Bit exceeds 1 bit.');
    }
  }

  bool asBool() {
    switch (intData) {
      case 0:
        return false;
      case 1:
        return true;
      default:
        return false;
    }
  }

  factory Bit.zero() {
    return Bit(intData: 0);
  }

  factory Bit.one() {
    return Bit(intData: 1);
  }
}
 */
