import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/register_address.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';

class RegisterFile extends Component {
  RegisterFile._();
  static final singleton = RegisterFile._();

  final processorStateManager = ProcessorStateManager.singleton;
  final regSelMultiplexer = RegSelMultiplexer.singleton;
  final bus = Bus.singleton;

  Map<RegisterAddress, Data> registers = {
    RegisterAddress.pc: Data.wordZero(),
    RegisterAddress.x0: Data.wordZero(),
    RegisterAddress.x1: Data.wordZero(),
    RegisterAddress.x2: Data.wordZero(),
    RegisterAddress.x3: Data.wordZero(),
    RegisterAddress.x4: Data.wordZero(),
    RegisterAddress.x5: Data.wordZero(),
    RegisterAddress.x6: Data.wordZero(),
    RegisterAddress.x7: Data.wordZero(),
    RegisterAddress.x8: Data.wordZero(),
  };

  bool writeEnable = false;

  void setWriteEnable(bool enableBool) {
    writeEnable = enableBool;
  }

  void writeRegister() {
    final selectedAddress = regSelMultiplexer.getRegisterAddress();
    if (selectedAddress == RegisterAddress.x0) {
      return;
    }

    final newData = bus.getData().asType(DataType.word);
    registers[selectedAddress] = newData;
    processorStateManager.updateRegFileState(selectedAddress, newData);
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
