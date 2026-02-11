import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/foundation/register_address.dart';
import 'package:microcoded_cpu_coe197/core/foundation/word.dart';

class RegisterFile extends Component {
  RegisterFile._();
  static final singleton = RegisterFile._();

  final regSelMultiplexer = RegSelMultiplexer.singleton;
  final bus = Bus.singleton;

  Map<RegisterAddress, Word> registers = {
    RegisterAddress.pc: Word.zero(),
    RegisterAddress.x0: Word.zero(),
    RegisterAddress.x1: Word(intData: 4),
    RegisterAddress.x2: Word(intData: 0xF0F0F0F),
    RegisterAddress.x3: Word(intData: 0),
    RegisterAddress.x4: Word(intData: 4),
    RegisterAddress.x5: Word(intData: 0),
    RegisterAddress.x6: Word(intData: 0),
    RegisterAddress.x7: Word(intData: 8),
    RegisterAddress.x8: Word(intData: 10),
  };

  bool writeEnable = false;

  void updatePC() {}

  void setWriteEnable(bool enableBool) {
    writeEnable = enableBool;
  }

  void writeRegister() {
    final selectedAddress = regSelMultiplexer.getRegisterAddress();
    registers[selectedAddress] = bus.getData().asWord();
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
