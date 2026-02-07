import 'package:microcoded_cpu_coe197/foundation/data.dart';

enum RegisterAddress {
  pc(dataAddress: Data(intData: 32)),
  x0(dataAddress: Data(intData: 0)),
  x1(dataAddress: Data(intData: 1)),
  x2(dataAddress: Data(intData: 2)),
  x3(dataAddress: Data(intData: 3));

  const RegisterAddress({required this.dataAddress});
  final Data dataAddress;

  static RegisterAddress fromData(Data data) {
    return RegisterAddress.values.firstWhere(
      (regAdd) {
        return regAdd.dataAddress.intData == data.intData;
      },
      orElse: () {
        throw FormatException(
          '[REGISTER ADDRESS ERROR] --> Invalid intData to Register Address',
        );
      },
    );
  }
}
