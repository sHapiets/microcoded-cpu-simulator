import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

class InstructionRegister extends Component {
  InstructionRegister._();
  static final singleton = InstructionRegister._();

  final bus = Bus.singleton;

  Data instrWord = Data.wordZero();
  bool loadEnable = false;

  void setLoadEnable(bool enableBool) {
    loadEnable = enableBool;
  }

  Data getInstrWord() {
    return instrWord;
  }

  void setInstrWord(Data newInstrWord) {
    instrWord = newInstrWord;
  }

  @override
  void readBus() {
    if (loadEnable) {
      final wordData = bus.getData().asType(DataType.word);
      setInstrWord(wordData);
    }
    super.readBus();
  }
}
