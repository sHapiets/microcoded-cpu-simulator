import 'package:microcoded_cpu_coe197/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/datapath/component.dart';
import 'package:microcoded_cpu_coe197/foundation/byte.dart';
import 'package:microcoded_cpu_coe197/foundation/data.dart';
import 'package:microcoded_cpu_coe197/foundation/word.dart';

class Memory extends Component {
  Memory._();
  static final singleton = Memory._();

  final bus = Bus.singleton;

  final List<Byte> dynamic = List.filled(20, Byte.zero());
  final List<Byte> instruction = List.filled(48, Byte.zero());

  Data data = Word.zero();
  Word memoryAddress = Word.zero();
  bool loadEnable = false;
  bool writeEnable = false;

  void loadByte() {
    data = dynamic[memoryAddress.intData];
  }

  void storeByte() {}

  void storeWord() {}
}
