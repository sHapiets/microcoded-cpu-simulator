import 'package:microcoded_cpu_coe197/core/datapath/alu/alu_operations.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/a.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/b.dart';
import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/word.dart';

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
      case ALUOperation.copyA:
        result = a.data.asWord();
      case ALUOperation.add:
        result = (a.data + b.data).asWord();
      case ALUOperation.inc4toA:
        result = (a.data + Data(intData: 4)).asWord();
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
