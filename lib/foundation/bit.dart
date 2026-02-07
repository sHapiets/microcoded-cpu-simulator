import 'package:microcoded_cpu_coe197/foundation/data.dart';

class Bit extends Data {
  Bit({required super.intData});

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
