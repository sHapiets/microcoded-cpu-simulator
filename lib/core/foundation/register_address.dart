import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

enum RegisterAddress {
  pc(dataAddress: Data(intData: 32)),
  x0(dataAddress: Data(intData: 0)),
  x1(dataAddress: Data(intData: 1)),
  x2(dataAddress: Data(intData: 2)),
  x3(dataAddress: Data(intData: 3));

  const RegisterAddress({required this.dataAddress});
  final Data dataAddress;

  static const fromIntDataMapping = {
    32: RegisterAddress.pc,
    0: RegisterAddress.x0,
    1: RegisterAddress.x1,
    2: RegisterAddress.x2,
    3: RegisterAddress.x3,
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
