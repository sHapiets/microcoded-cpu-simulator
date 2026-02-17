import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/operand.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';

class A extends Operand {
  A._();
  static final singleton = A._();

  final processorStateManager = ProcessorStateManager.singleton;

  @override
  void readBus() {
    processorStateManager.updateALoadState(loadEnable);
    if (loadEnable) {
      data = bus.getData();
      processorStateManager.updateADataState(data);
    }
    super.readBus();
  }
}
