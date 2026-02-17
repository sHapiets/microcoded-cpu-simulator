import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/operand.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';

class B extends Operand {
  B._();
  static final singleton = B._();

  final processorStateManager = ProcessorStateManager.singleton;

  @override
  void readBus() {
    processorStateManager.updateBLoadState(loadEnable);
    if (loadEnable) {
      data = bus.getData();
      processorStateManager.updateBDataState(data);
    }
    super.readBus();
  }
}
