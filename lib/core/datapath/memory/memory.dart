import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/byte.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/half_word.dart';
import 'package:microcoded_cpu_coe197/core/foundation/word.dart';

class Memory extends Component {
  Memory._();
  static final singleton = Memory._();

  final bus = Bus.singleton;

  final List<List<Byte>> byteMemory = List.generate(
    20,
    (_) => List.generate(4, (_) => Byte.zero()),
  );

  Word memoryAddress = Word.zero();
  int get memoryWordAddress => memoryAddress.intData >> 2;
  int get memoryByteAddress => memoryAddress.intData & 0x3;

  final int instrWordAddressBegin = 0x00;
  final int instrWordAddressLimit = 0x05;
  final int dynamicWordAddressBegin = 0x06;
  final int dynamicWordAddressLimit = 0x0a;
  bool get memAddressOnInstrSpace =>
      (memoryWordAddress >= instrWordAddressBegin &&
      memoryWordAddress <= instrWordAddressLimit);

  bool addressloadEnable = false;
  MemoryWriteType writeType = MemoryWriteType.off;

  void setMemAddress(Word newAddress) {
    memoryAddress = newAddress;
  }

  void setAddressLoadEnable(bool enableBool) {
    addressloadEnable = enableBool;
  }

  void setMemWriteType(MemoryWriteType newWriteType) {
    writeType = newWriteType;
  }

  void setByte(Byte newByte, Word storeAddress) {
    int getMemoryWordAddress = storeAddress.intData >> 2;
    int getMemoryByteAddress = storeAddress.intData & 0x3;

    byteMemory[getMemoryWordAddress][getMemoryByteAddress] = newByte;
  }

  void storeByte(Byte newByte) {
    bool addressNotDivBy4 = (memoryAddress.intData & 0x3) != 0;
    if (addressNotDivBy4) {
      throw FormatException(
        "[MEM. ADDRESS ERROR] --> Memory attempts to store a Word, but the memory address does not point to a valid Word address: (0x${memoryAddress.asHexString(6)}).",
      );
    }

    setByte(newByte, memoryAddress);
  }

  void storeHalf(HalfWord newHalf) {
    bool addressNotDivBy4 = (memoryAddress.intData & 0x3) != 0;
    if (addressNotDivBy4) {
      throw FormatException(
        "[MEM. ADDRESS ERROR] --> Memory attempts to store a Word, but the memory address does not point to a valid Word address: (0x${memoryAddress.asHexString(6)}).",
      );
    }

    final halfWordByteLength = 2;
    for (int i = 0; i < halfWordByteLength; i++) {
      final byte = newHalf.byte[i];
      final addressIncrement = Word(intData: i);
      setByte(byte, memoryAddress + addressIncrement);
    }
  }

  void storeWord(Word newWord) {
    bool addressNotDivBy4 = (memoryAddress.intData & 0x3) != 0;
    if (addressNotDivBy4) {
      throw FormatException(
        "[MEM. ADDRESS ERROR] --> Memory attempts to store a Word, but the memory address does not point to a valid Word address: (0x${memoryAddress.asHexString(6)}).",
      );
    }

    final wordByteLength = 4;
    for (int i = 0; i < wordByteLength; i++) {
      final byte = newWord.byte[i];
      final addressIncrement = Word(intData: i);
      setByte(byte, memoryAddress + addressIncrement);
    }
  }

  void loadWord() {
    int getMemoryWordAddress(Word memAddress) => memAddress.intData >> 2;
    int getMemoryByteAddress(Word memAddress) => memAddress.intData & 0x3;

    late final Word newWord;
    List<Byte> bytes = [];
    final int wordByteLength = 4;
    for (int i = 0; i < wordByteLength; i++) {
      final iterMemoryAddress = memoryAddress + Word(intData: i);
      final iterWordAddress = getMemoryWordAddress(iterMemoryAddress);
      final iterByteAddress = getMemoryByteAddress(iterMemoryAddress);
      final byte = byteMemory[iterWordAddress][iterByteAddress];
      bytes.add(byte);
    }
    newWord = Word.fromBytes(bytes);

    bus.passData(newData: newWord, componentBuffer: Buffer.memEn);
  }

  void presetInstructionLoad() {
    byteMemory[0][0] = Byte.fromHexString('23');
    byteMemory[0][1] = Byte.fromHexString('0c');
    byteMemory[0][2] = Byte.fromHexString('20');
    byteMemory[0][3] = Byte.fromHexString('00');

    byteMemory[1][0] = Byte.fromHexString('23');
    byteMemory[1][1] = Byte.fromHexString('1c');
    byteMemory[1][2] = Byte.fromHexString('20');
    byteMemory[1][3] = Byte.fromHexString('00');

    byteMemory[2][0] = Byte.fromHexString('23');
    byteMemory[2][1] = Byte.fromHexString('2c');
    byteMemory[2][2] = Byte.fromHexString('20');
    byteMemory[2][3] = Byte.fromHexString('00');
  }

  @override
  void readBus() {
    if (addressloadEnable == true) {
      final busData = bus.getData();
      setMemAddress(busData.asWord());
    }

    switch (writeType) {
      case MemoryWriteType.off:
        break;
      case MemoryWriteType.storeByte:
        final busData = bus.getData();
        final intMaskedByte = busData.intData & 0xFF;
        storeByte(Byte(intData: intMaskedByte));
      case MemoryWriteType.storeHalf:
        final busData = bus.getData();
        final intMaskedHalf = busData.intData & 0xFFFF;
        storeHalf(HalfWord(intData: intMaskedHalf));
      case MemoryWriteType.storeWord:
        final busData = bus.getData();
        storeWord(busData.asWord());
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
    final writeType = fromIntDataMapping[data.intData];
    if (writeType == null) {
      throw FormatException(
        "[MEM.WRITE-TYPE ERROR] --> Data.intData: ${data.intData} : is not mapped to any MemoryWriteType. Check loaded ROM.",
      );
    }

    return writeType;
  }
}
