import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

class Memory extends Component {
  Memory._();
  static final singleton = Memory._();

  final bus = Bus.singleton;

  Data memoryAddress = Data.wordZero();
  int get memoryWordAddress => memoryAddress.asUnsignedInt() >> 2;
  int get memoryByteAddress => memoryAddress.asUnsignedInt() & 0x3;

  final int instrWordAddressBegin = 0x00;
  final int instrWordAddressLimit = 0x05;
  final int dynamicWordAddressBegin = 0x06;
  final int dynamicWordAddressLimit = 0x0a;
  bool get memAddressOnInstrSpace =>
      (memoryWordAddress >= instrWordAddressBegin &&
      memoryWordAddress <= instrWordAddressLimit);

  final List<List<Data>> byteMemory = List.generate(
    0x0a,
    (_) => List.generate(4, (_) => Data.byteZero()),
  );

  bool addressloadEnable = false;
  MemoryWriteType writeType = MemoryWriteType.off;
  bool get writeEnable => (writeType != MemoryWriteType.off);

  final int totalReadCycles = 2;
  final int totalWriteCycles = 3;
  int readCycles = 2;
  int writeCycles = 3;
  bool isBusyReading = false;
  bool isBusyWriting = false;
  bool isNotBusy() => (!isBusyWriting && !isBusyReading);

  void setMemAddress(Data newAddress) {
    final newAddAsWord = newAddress.asType(DataType.word);
    memoryAddress = newAddAsWord;
  }

  void setAddressLoadEnable(bool enableBool) {
    addressloadEnable = enableBool;
  }

  void setMemWriteType(MemoryWriteType newWriteType) {
    writeType = newWriteType;
  }

  void setByte(Data newByte, Data storeAddress) {
    int getMemoryWordAddress = storeAddress.asUnsignedInt() >> 2;
    int getMemoryByteAddress = storeAddress.asUnsignedInt() & 0x3;

    byteMemory[getMemoryWordAddress][getMemoryByteAddress] = newByte;
  }

  void storeByte(Data newByte) {
    bool addressNotDivBy4 = (memoryAddress.asUnsignedInt() & 0x3) != 0;
    if (addressNotDivBy4) {
      throw FormatException(
        "[MEM. ADDRESS ERROR] --> Memory attempts to store a Word, but the memory address does not point to a valid Word address: (0x${memoryAddress.asUnsignedHexString(8)}).",
      );
    }

    setByte(newByte, memoryAddress);
  }

  void storeHalf(Data newHalf) {
    bool addressNotDivBy4 = (memoryAddress.asUnsignedInt() & 0x3) != 0;
    if (addressNotDivBy4) {
      throw FormatException(
        "[MEM. ADDRESS ERROR] --> Memory attempts to store a Word, but the memory address does not point to a valid Word address: (0x${memoryAddress.asUnsignedHexString(8)}).",
      );
    }

    final halfWordByteLength = 2;
    for (int i = 0; i < halfWordByteLength; i++) {
      final byte = newHalf.byteList[i];
      final iterAddress = Data.word(memoryAddress.asUnsignedInt() + i);
      setByte(byte, iterAddress);
    }
  }

  void storeWord(Data newWord) {
    bool addressNotDivBy4 = (memoryAddress.asUnsignedInt() & 0x3) != 0;
    if (addressNotDivBy4) {
      throw FormatException(
        "[MEM. ADDRESS ERROR] --> Memory attempts to store a Word, but the memory address does not point to a valid Word address: (0x${memoryAddress.asUnsignedHexString(6)}).",
      );
    }

    final wordByteLength = 4;
    for (int i = 0; i < wordByteLength; i++) {
      final byte = newWord.byteList[i];
      final iterAddress = Data.word(memoryAddress.asUnsignedInt() + i);
      setByte(byte, iterAddress);
    }
  }

  void storeData() {
    switch (writeType) {
      case MemoryWriteType.off:
        break;
      case MemoryWriteType.storeByte:
        final byteData = bus.getData();
        storeByte(byteData);
      case MemoryWriteType.storeHalf:
        final halfData = bus.getData();
        storeHalf(halfData);
      case MemoryWriteType.storeWord:
        final wordData = bus.getData();
        storeWord(wordData);
    }
  }

  void loadWord() {
    int getMemoryWordAddress(Data memAddress) =>
        memAddress.asUnsignedInt() >> 2;
    int getMemoryByteAddress(Data memAddress) =>
        memAddress.asUnsignedInt() & 0x3;

    late final Data newWord;
    List<Data> bytes = [];
    final int wordByteLength = 4;
    for (int i = 0; i < wordByteLength; i++) {
      final iterMemoryAddress = Data.word(memoryAddress.asUnsignedInt() + i);
      final iterWordAddress = getMemoryWordAddress(iterMemoryAddress);
      final iterByteAddress = getMemoryByteAddress(iterMemoryAddress);
      final byte = byteMemory[iterWordAddress][iterByteAddress];
      bytes.add(byte);
    }
    newWord = Data.wordFromBytes(bytes);

    bus.passData(newData: newWord, componentBuffer: Buffer.memEn);
  }

  void processWriteCycle() {
    writeCycles--;
    isBusyWriting = true;
  }

  void processReadCycle() {
    readCycles--;
    isBusyReading = true;
  }

  void resetWriteCycles() {
    writeCycles = totalWriteCycles;
    isBusyWriting = false;
  }

  void resetReadCycles() {
    readCycles = totalReadCycles;
    isBusyReading = false;
  }

  void presetInstructionLoad() {
    byteMemory[0][0] = Data.fromUnsignedHexString('83', DataType.byte);
    byteMemory[0][1] = Data.fromUnsignedHexString('21', DataType.byte);
    byteMemory[0][2] = Data.fromUnsignedHexString('80', DataType.byte);
    byteMemory[0][3] = Data.fromUnsignedHexString('01', DataType.byte);

    byteMemory[6][0] = Data.fromUnsignedHexString('FF', DataType.byte);
    byteMemory[6][1] = Data.fromUnsignedHexString('80', DataType.byte);
    byteMemory[6][2] = Data.fromUnsignedHexString('00', DataType.byte);
    byteMemory[6][3] = Data.fromUnsignedHexString('80', DataType.byte);

    byteMemory[1][0] = Data.fromUnsignedHexString('23', DataType.byte);
    byteMemory[1][1] = Data.fromUnsignedHexString('1e', DataType.byte);
    byteMemory[1][2] = Data.fromUnsignedHexString('30', DataType.byte);
    byteMemory[1][3] = Data.fromUnsignedHexString('00', DataType.byte);

    /* byteMemory[2][0] = Data.fromUnsignedHexString('23', DataType.byte);
    byteMemory[2][1] = Data.fromUnsignedHexString('2c', DataType.byte);
    byteMemory[2][2] = Data.fromUnsignedHexString('20', DataType.byte);
    byteMemory[2][3] = Data.fromUnsignedHexString('00', DataType.byte); */
  }

  @override
  void readBus() {
    super.readBus();
    if (addressloadEnable == true) {
      final busData = bus.getData();
      setMemAddress(busData);
    }

    if (writeEnable == false) {
      resetWriteCycles();
      return;
    }

    if (writeCycles == 0) {
      storeData();
      resetWriteCycles();
      return;
    }

    processWriteCycle();
  }

  @override
  void updateBus() {
    final bool memEn = bus.getBuffer(Buffer.memEn);
    super.updateBus();
    if (memEn == false) {
      resetReadCycles();
      return;
    }

    if (readCycles == 0) {
      loadWord();
      resetReadCycles();
      return;
    }

    processReadCycle();
  }
}

enum MemoryWriteType {
  off,
  storeByte,
  storeHalf,
  storeWord;

  const MemoryWriteType();
  static const Map<int, MemoryWriteType> fromIntDataMapping = {
    0: off,
    1: storeByte,
    2: storeHalf,
    3: storeWord,
  };

  factory MemoryWriteType.fromData(Data data) {
    final writeType = fromIntDataMapping[data.asUnsignedInt()];
    if (writeType == null) {
      throw FormatException(
        "[MEM.WRITE-TYPE ERROR] --> Data.intData: ${data.asUnsignedInt()} : is not mapped to any MemoryWriteType. Check loaded ROM.",
      );
    }

    return writeType;
  }
}
