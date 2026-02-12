import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

class Operand extends Component {
  Operand();

  final bus = Bus.singleton;

  Data data = Data.wordZero();
  bool loadEnable = false;

  void setLoadEnable(bool enable) {
    loadEnable = enable;
  }

  @override
  void readBus() {
    if (loadEnable) {
      data = bus.getData();
    }
    super.readBus();
  }
}
