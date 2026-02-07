import 'package:microcoded_cpu_coe197/foundation/data.dart';

class Byte extends Data {
  Byte({required super.intData});

  factory Byte.zero() {
    return Byte(intData: 0);
  }

  factory Byte.four() {
    return Byte(intData: 4);
  }
}
