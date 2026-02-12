import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

enum RegisterAddress {
  pc,
  x0,
  x1,
  x2,
  x3,
  x4,
  x5,
  x6,
  x7,
  x8;

  const RegisterAddress();

  static const fromIntDataMapping = {
    32: RegisterAddress.pc,
    0: RegisterAddress.x0,
    1: RegisterAddress.x1,
    2: RegisterAddress.x2,
    3: RegisterAddress.x3,
    4: RegisterAddress.x4,
    5: RegisterAddress.x5,
    6: RegisterAddress.x6,
    7: RegisterAddress.x7,
    8: RegisterAddress.x8,
  };

  factory RegisterAddress.fromData(Data data) {
    final RegisterAddress? addressFromData =
        fromIntDataMapping[data.asUnsignedInt()];

    if (addressFromData == null) {
      throw FormatException(
        '[REGISTER ADDRESS ERROR] --> Invalid intData to Register Address',
      );
    }

    return addressFromData;
  }
}
