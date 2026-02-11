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
      case ALUOperation.copyB:
        result = b.data.asWord();
      case ALUOperation.inc1toA:
        result = (a.data + Data(intData: 1)).asWord();
      case ALUOperation.dec1toA:
        result = (a.data - Data(intData: 1)).asWord();
      case ALUOperation.inc4toA:
        result = (a.data + Data(intData: 4)).asWord();
      case ALUOperation.dec4toA:
        result = (a.data - Data(intData: 4)).asWord();
      case ALUOperation.add:
        result = (a.data + b.data).asWord();
      case ALUOperation.sub:
        result = (a.data - b.data).asWord();
      case ALUOperation.slt:
        final aSigned = a.data.intData.toSigned(32);
        final bSigned = b.data.intData.toSigned(32);
        result = (aSigned < bSigned) ? Word.one() : Word.zero();
      case ALUOperation.sltu:
        final aUnsigned = a.data.intData.toUnsigned(32);
        final bUnsigned = b.data.intData.toUnsigned(32);
        result = (aUnsigned < bUnsigned) ? Word.one() : Word.zero();
      case ALUOperation.sra:
        final b5Bit = Data(intData: (b.data.intData & 0x0F));
        result = Data(intData: (a.data.intData >> b5Bit.intData)).asWord();
      case ALUOperation.srl:
        final b5Bit = Data(intData: (b.data.intData & 0x0F));
        result = Data(intData: (a.data.intData >>> b5Bit.intData)).asWord();
      case ALUOperation.sll:
        final b5Bit = Data(intData: (b.data.intData & 0x0F));
        result = Data(intData: (a.data.intData << b5Bit.intData)).asWord();
      case ALUOperation.bitXOR:
        result = Data(intData: a.data.intData ^ b.data.intData).asWord();
      case ALUOperation.bitOR:
        result = Data(intData: a.data.intData | b.data.intData).asWord();
      case ALUOperation.bitAND:
        result = Data(intData: a.data.intData & b.data.intData).asWord();
    }
  }

  @override
  void updateBus() {
    operate();
    bus.passData(newData: result, componentBuffer: Buffer.aluEn);
    super.updateBus();
  }
}
