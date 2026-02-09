import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/word.dart';

class Bus extends Component {
  Bus._();
  static final singleton = Bus._();

  Data busData = Word.zero();
  bool busOccupied = false;
  Map<Buffer, bool> buffers = {
    Buffer.immEn: false,
    Buffer.regEn: false,
    Buffer.aluEn: false,
    Buffer.memEn: false,
  };

  void setBuffer(Buffer buffer, bool enableBool) {
    if (enableBool == false) {
      buffers[buffer] = false;
      return;
    }

    if (enableBool == true && busOccupied == false) {
      buffers[buffer] = true;
      busOccupied = true;
    } else {
      throw FormatException(
        '[BUS ERROR] --> Bus is occupied by more than one buffer. Check loaded uCoded ROM.',
      );
    }
  }

  void resetAllBuffers() {
    busOccupied = false;
    busData = Word.zero();
    buffers.updateAll((_, _) => false);
  }

  void passData({required Data newData, required Buffer componentBuffer}) {
    if (busOccupied == false) {
      throw FormatException(
        '[BUS ERROR] --> Bus is currently floating, as all buffers are inactive. Check loaded uCoded ROM.',
      );
    }
    if (buffers[componentBuffer] == true) {
      busData = newData;
    }
  }

  Data getData() {
    return busData;
  }
}

enum Buffer { immEn, regEn, aluEn, memEn }
