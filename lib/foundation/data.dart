import 'package:microcoded_cpu_coe197/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/foundation/bit.dart';
import 'package:microcoded_cpu_coe197/foundation/byte.dart';
import 'package:microcoded_cpu_coe197/foundation/word.dart';

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

  RegSel convertAsRegSel() {
    switch (intData) {
      case 0:
        return RegSel.rs1;
      case 1:
        return RegSel.rs2;
      case 2:
        return RegSel.rd;
      case 3:
        return RegSel.pc;
      default:
        throw FormatException("[ROM ERROR] --> Invalid RegSel from ROM");
    }
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
