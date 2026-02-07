import 'package:microcoded_cpu_coe197/foundation/register_address.dart';

class RegSelMultiplexer {
  RegSelMultiplexer._();
  static final singleton = RegSelMultiplexer._();

  RegSel regSel = RegSel.pc;
  Map<RegSel, RegisterAddress> addressMapping = {
    RegSel.pc: RegisterAddress.pc,
    RegSel.rs1: RegisterAddress.x1,
    RegSel.rs2: RegisterAddress.x2,
    RegSel.rd: RegisterAddress.x0,
  };

  void setRegSel(RegSel newRegSel) {
    regSel = newRegSel;
  }

  RegisterAddress getRegisterAddress() {
    return addressMapping[regSel]!;
  }
}

enum RegSel { rs1, rs2, rd, pc }
