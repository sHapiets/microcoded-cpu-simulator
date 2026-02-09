import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/byte.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/half_word.dart';
import 'package:microcoded_cpu_coe197/core/foundation/word.dart';

class ImmediateMultiplexer extends Component {
  ImmediateMultiplexer._();
  static final singleton = ImmediateMultiplexer._();

  Bus bus = Bus.singleton;

  ImmSel immSel = ImmSel.immTypeI;
  Map<ImmSel, Data> immediateMapping = {
    ImmSel.immTypeI: Word.zero(),
    ImmSel.immTypeXI: Word.zero(),
    ImmSel.immTypeS: Word.zero(),
    ImmSel.immTypeB: Word.zero(),
    ImmSel.immTypeU: Word.zero(),
    ImmSel.immTypeJ: Word.zero(),
    ImmSel.maskByte: Byte(intData: 0xFF),
    ImmSel.maskHalf: HalfWord(intData: 0xFFFF),
  };

  void setImmSel(ImmSel newImmSel) {
    immSel = newImmSel;
  }

  void updateImmediateMapping(ImmSel selectedImmSel, Data newImm) {
    immediateMapping.update(selectedImmSel, (_) => newImm);
  }

  @override
  void updateBus() {
    final immediateData = immediateMapping[immSel];
    if (immediateData == null) {
      throw FormatException(
        '[IMM. MULTIPLEXER ERROR] --> Current immSel value: ImmSel.$immSel exists, but is not an entry in the multiplexer. Check source code implementation of ImmediateMultiplexer.',
      );
    } else {
      bus.passData(newData: immediateData, componentBuffer: Buffer.immEn);
    }
    super.updateBus();
  }
}

enum ImmSel {
  immTypeI,
  immTypeXI,
  immTypeS,
  immTypeB,
  immTypeU,
  immTypeJ,
  maskByte,
  maskHalf;

  const ImmSel();
  static const Map<int, ImmSel> fromIntDataMapping = {
    0: immTypeI,
    1: immTypeS,
    2: immTypeB,
    3: immTypeU,
    4: immTypeJ,
    5: maskByte,
    6: maskHalf,
  };

  factory ImmSel.fromData(Data data) {
    final immSelected = fromIntDataMapping[data.intData];
    if (immSelected == null) {
      throw FormatException(
        '[IMM.SEL ERROR] --> Data.intData: ${data.intData} does not correspond to any ImmSel value. Check the loaded ROM.',
      );
    } else {
      return immSelected;
    }
  }
}
