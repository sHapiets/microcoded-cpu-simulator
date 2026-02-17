import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';

class Bus extends Component {
  Bus._();
  static final singleton = Bus._();

  final processorStateManager = ProcessorStateManager.singleton;

  Data busData = Data.wordZero();
  bool busOccupied = false;
  bool get isFloating => !busOccupied;
  Map<Buffer, bool> buffers = {
    Buffer.immEn: false,
    Buffer.regEn: false,
    Buffer.aluEn: false,
    Buffer.memEn: false,
  };

  void setBuffer(Buffer buffer, bool enableBool) {
    if (enableBool == false) {
      buffers[buffer] = false;
      processorStateManager.updateBufferState(buffer, enableBool);
      return;
    }

    if (enableBool == true && busOccupied == false) {
      buffers[buffer] = true;
      processorStateManager.updateBufferState(buffer, enableBool);
      busOccupied = true;
    } else {
      throw FormatException(
        '[BUS ERROR] --> Bus is occupied by more than one buffer. Check loaded microcoded ROM.',
      );
    }
  }

  bool getBuffer(Buffer buffer) {
    return buffers[buffer]!;
  }

  void resetAllBuffers() {
    busOccupied = false;
    busData = Data.wordZero();
    buffers.updateAll((_, _) => false);
  }

  void passData({required Data newData, required Buffer componentBuffer}) {
    if (buffers[componentBuffer] == true) {
      busData = newData;
      processorStateManager.updateBusDataState(newData);
    }
  }

  Data getData() {
    if (isFloating) {
      throw FormatException(
        '[BUS ERROR] --> Bus is currently floating, but a component attempts to load data from it. Check loaded uCoded ROM.',
      );
    }

    return busData;
  }
}

enum Buffer { immEn, regEn, aluEn, memEn }
