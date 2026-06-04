import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

enum RegisterAddress {
  none,
  pc,

  x0,
  x1,
  x2,
  x3,
  x4,
  x5,
  x6,
  x7,
  x8,
  x9,
  x10,
  x11,
  x12,
  x13,
  x14,
  x15,
  x16,
  x17,
  x18,
  x19,
  x20,
  x21,
  x22,
  x23,
  x24,
  x25,
  x26,
  x27,
  x28,
  x29,
  x30,
  x31;

  const RegisterAddress();

  static const fromIntDataMapping = {
    -1: RegisterAddress.none,
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
    9: RegisterAddress.x9,
    10: RegisterAddress.x10,
    11: RegisterAddress.x11,
    12: RegisterAddress.x12,
    13: RegisterAddress.x13,
    14: RegisterAddress.x14,
    15: RegisterAddress.x15,
    16: RegisterAddress.x16,
    17: RegisterAddress.x17,
    18: RegisterAddress.x18,
    19: RegisterAddress.x19,
    20: RegisterAddress.x20,
    21: RegisterAddress.x21,
    22: RegisterAddress.x22,
    23: RegisterAddress.x23,
    24: RegisterAddress.x24,
    25: RegisterAddress.x25,
    26: RegisterAddress.x26,
    27: RegisterAddress.x27,
    28: RegisterAddress.x28,
    29: RegisterAddress.x29,
    30: RegisterAddress.x30,
    31: RegisterAddress.x31,
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
