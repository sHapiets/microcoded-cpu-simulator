import 'package:microcoded_cpu_coe197/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/datapath/component.dart';
import 'package:microcoded_cpu_coe197/foundation/data.dart';
import 'package:microcoded_cpu_coe197/foundation/word.dart';

class Operand extends Component {
  Operand();

  final bus = Bus.singleton;

  Data data = Word.zero();
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
