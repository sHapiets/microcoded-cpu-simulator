import 'package:microcoded_cpu_coe197/datapath/alu/alu_operations.dart';
import 'package:microcoded_cpu_coe197/datapath/alu/operands/a.dart';
import 'package:microcoded_cpu_coe197/datapath/alu/operands/b.dart';
import 'package:microcoded_cpu_coe197/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/datapath/component.dart';
import 'package:microcoded_cpu_coe197/foundation/word.dart';

class ALU extends Component {
  ALU._();
  static final singleton = ALU._();

  final a = A.singleton;
  final b = B.singleton;
  final bus = Bus.singleton;

  ALUOperation operation = ALUOperation.add;
  Word result = Word.zero();

  void operate() {
    switch (operation) {
      case ALUOperation.add:
        result = (a.data + b.data).asWord();
      default:
        result = (a.data + b.data).asWord();
    }
  }

  @override
  void updateBus() {
    operate();
    bus.passData(newData: result, componentBuffer: Buffer.aluEn);
    super.updateBus();
  }
}
