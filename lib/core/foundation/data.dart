import 'package:microcoded_cpu_coe197/core/foundation/bit.dart';
import 'package:microcoded_cpu_coe197/core/foundation/byte.dart';
import 'package:microcoded_cpu_coe197/core/foundation/word.dart';

class Data {
  const Data({required this.intData});

  final int intData;

  Bit asBit() {
    return Bit(intData: intData);
  }

  Byte asByte() {
    return Byte(intData: intData);
  }

  Word asWord() {
    return Word(intData: intData);
  }

  String asBitString(int maxLength) {
    return intData.toRadixString(2).padLeft(maxLength, '0');
  }

  String asHexString(int maxLength) {
    return intData.toRadixString(16).padLeft(maxLength, '0');
  }

  Data operator +(Data other) {
    return Data(intData: intData + other.intData);
  }

  factory Data.fromHexString(String hexString) {
    final int intData = int.parse(hexString, radix: 16);
    return Data(intData: intData);
  }

  factory Data.fromBitString(String hexString) {
    final int intData = int.parse(hexString, radix: 2);
    return Data(intData: intData);
  }
}
