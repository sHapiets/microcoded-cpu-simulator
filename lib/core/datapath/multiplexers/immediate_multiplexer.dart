import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

class ImmediateMultiplexer extends Component {
  ImmediateMultiplexer._();
  static final singleton = ImmediateMultiplexer._();

  Bus bus = Bus.singleton;

  ImmSel immSel = ImmSel.immTypeI;
  Map<ImmSel, Data> immediateMapping = {
    ImmSel.immTypeI: Data.wordZero(),
    ImmSel.immTypeXI: Data.wordZero(),
    ImmSel.immTypeS: Data.wordZero(),
    ImmSel.immTypeB: Data.wordZero(),
    ImmSel.immTypeU: Data.wordZero(),
    ImmSel.immTypeJ: Data.wordZero(),
    ImmSel.int24: Data.byte(24),
    ImmSel.int16: Data.byte(16),
    ImmSel.maskWord: Data.word(-1),
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
  int24,
  int16,
  maskWord;

  const ImmSel();
  static const Map<int, ImmSel> fromIntDataMapping = {
    0: immTypeI,
    1: immTypeS,
    2: immTypeB,
    3: immTypeU,
    4: immTypeJ,
    5: int24,
    6: int16,
    7: maskWord,
  };

  factory ImmSel.fromData(Data data) {
    final immSelected = fromIntDataMapping[data.asUnsignedInt()];
    if (immSelected == null) {
      throw FormatException(
        '[IMM.SEL ERROR] --> Data.intData: ${data.asUnsignedInt()} does not correspond to any ImmSel value. Check the loaded ROM.',
      );
    } else {
      return immSelected;
    }
  }
}
