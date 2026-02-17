import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/register_address.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';

class RegSelMultiplexer {
  RegSelMultiplexer._();
  static final singleton = RegSelMultiplexer._();

  final processorStateManager = ProcessorStateManager.singleton;

  RegSel regSel = RegSel.pc;
  Map<RegSel, RegisterAddress> addressMapping = {
    RegSel.pc: RegisterAddress.pc,
    RegSel.rs1: RegisterAddress.x1,
    RegSel.rs2: RegisterAddress.x2,
    RegSel.rd: RegisterAddress.x0,
  };

  void setRegSel(RegSel newRegSel) {
    regSel = newRegSel;
    processorStateManager.updateRegSelState(newRegSel);
  }

  RegisterAddress getRegisterAddress() {
    return addressMapping[regSel]!;
  }

  void updateAddressMapping(RegSel selectedRegSel, RegisterAddress newAddress) {
    addressMapping.update(selectedRegSel, (_) => newAddress);
  }
}

enum RegSel {
  rs1,
  rs2,
  rd,
  pc;

  const RegSel();
  static const fromIntDataMapping = {
    0: RegSel.rs1,
    1: RegSel.rs2,
    2: RegSel.rd,
    3: RegSel.pc,
  };

  factory RegSel.fromData(Data data) {
    final RegSel? regSelFromData = fromIntDataMapping[data.asUnsignedInt()];

    if (regSelFromData == null) {
      throw FormatException(
        '[REGSEL ERROR] --> Invalid Data.intData to Register Address. Check ROM RegSel.',
      );
    }

    return regSelFromData;
  }
}
