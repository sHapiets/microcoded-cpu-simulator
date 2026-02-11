import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

enum RegisterAddress {
  pc(dataAddress: Data(intData: 32)),
  x0(dataAddress: Data(intData: 0)),
  x1(dataAddress: Data(intData: 1)),
  x2(dataAddress: Data(intData: 2)),
  x3(dataAddress: Data(intData: 3)),
  x4(dataAddress: Data(intData: 4)),
  x5(dataAddress: Data(intData: 5)),
  x6(dataAddress: Data(intData: 6)),
  x7(dataAddress: Data(intData: 7)),
  x8(dataAddress: Data(intData: 8));

  const RegisterAddress({required this.dataAddress});
  final Data dataAddress;

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
    final RegisterAddress? addressFromData = fromIntDataMapping[data.intData];

    if (addressFromData == null) {
      throw FormatException(
        '[REGISTER ADDRESS ERROR] --> Invalid intData to Register Address',
      );
    }

    return addressFromData;
  }
}
