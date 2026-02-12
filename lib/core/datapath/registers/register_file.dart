import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/register_address.dart';

class RegisterFile extends Component {
  RegisterFile._();
  static final singleton = RegisterFile._();

  final regSelMultiplexer = RegSelMultiplexer.singleton;
  final bus = Bus.singleton;

  Map<RegisterAddress, Data> registers = {
    RegisterAddress.pc: Data.wordZero(),
    RegisterAddress.x0: Data.wordZero(),
    RegisterAddress.x1: Data.word(4),
    RegisterAddress.x2: Data.word(0xF0F0F0F),
    RegisterAddress.x3: Data.wordZero(),
    RegisterAddress.x4: Data.word(4),
    RegisterAddress.x5: Data.wordZero(),
    RegisterAddress.x6: Data.wordZero(),
    RegisterAddress.x7: Data.word(-1),
    RegisterAddress.x8: Data.word(10),
  };

  bool writeEnable = false;

  void updatePC() {}

  void setWriteEnable(bool enableBool) {
    writeEnable = enableBool;
  }

  void writeRegister() {
    final selectedAddress = regSelMultiplexer.getRegisterAddress();
    registers[selectedAddress] = bus.getData();
  }

  void readRegister() {
    final selectedAddress = regSelMultiplexer.getRegisterAddress();
    bus.passData(
      newData: registers[selectedAddress]!,
      componentBuffer: Buffer.regEn,
    );
  }

  @override
  void updateBus() {
    readRegister();
    super.updateBus();
  }

  @override
  void readBus() {
    if (writeEnable) {
      writeRegister();
    }
    super.readBus();
  }
}
