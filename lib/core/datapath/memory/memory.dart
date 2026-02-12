import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

class Memory extends Component {
  Memory._();
  static final singleton = Memory._();

  final bus = Bus.singleton;

  final List<List<Data>> byteMemory = List.generate(
    20,
    (_) => List.generate(4, (_) => Data.byteZero()),
  );

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

  bool addressloadEnable = false;
  MemoryWriteType writeType = MemoryWriteType.off;

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

  void presetInstructionLoad() {
    byteMemory[0][0] = Data.fromUnsignedHexString('83', DataType.byte);
    byteMemory[0][1] = Data.fromUnsignedHexString('01', DataType.byte);
    byteMemory[0][2] = Data.fromUnsignedHexString('80', DataType.byte);
    byteMemory[0][3] = Data.fromUnsignedHexString('01', DataType.byte);

    byteMemory[6][0] = Data.fromUnsignedHexString('80', DataType.byte);
    byteMemory[6][1] = Data.fromUnsignedHexString('01', DataType.byte);
    /* 
    byteMemory[1][0] = Data.fromUnsignedHexString('23', DataType.byte);
    byteMemory[1][1] = Data.fromUnsignedHexString('1c', DataType.byte);
    byteMemory[1][2] = Data.fromUnsignedHexString('20', DataType.byte);
    byteMemory[1][3] = Data.fromUnsignedHexString('00', DataType.byte);

    byteMemory[2][0] = Data.fromUnsignedHexString('23', DataType.byte);
    byteMemory[2][1] = Data.fromUnsignedHexString('2c', DataType.byte);
    byteMemory[2][2] = Data.fromUnsignedHexString('20', DataType.byte);
    byteMemory[2][3] = Data.fromUnsignedHexString('00', DataType.byte); */
  }

  @override
  void readBus() {
    if (addressloadEnable == true) {
      final busData = bus.getData();
      setMemAddress(busData);
    }

    switch (writeType) {
      case MemoryWriteType.off:
        break;
      case MemoryWriteType.storeByte:
        final byteData = bus.getData().asType(DataType.byte);
        storeByte(byteData);
      case MemoryWriteType.storeHalf:
        final halfData = bus.getData().asType(DataType.halfword);
        storeHalf(halfData);
      case MemoryWriteType.storeWord:
        final wordData = bus.getData().asType(DataType.word);
        storeWord(wordData);
    }
    super.readBus();
  }

  @override
  void updateBus() {
    loadWord();
    super.updateBus();
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
