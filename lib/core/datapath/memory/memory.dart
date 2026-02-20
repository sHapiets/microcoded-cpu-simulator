import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/processor_state_manager.dart';

class Memory extends Component {
  Memory._();
  static final singleton = Memory._();

  final bus = Bus.singleton;
  final processorStateManager = ProcessorStateManager.singleton;

  Data memoryAddress = Data.wordZero();
  int get memoryWordAddress => memoryAddress.asUnsignedInt() >> 2;
  int get memoryByteAddress => memoryAddress.asUnsignedInt() & 0x3;

  final int instrWordAddressBegin = 0x00;
  final int instrWordAddressLimit = 0x3f;
  final int dynamicWordAddressBegin = 0x40;
  final int dynamicWordAddressLimit = 0x6f;
  bool memAddressOnInstrSpace(Data wordAddress) =>
      (wordAddress.asUnsignedInt() >= instrWordAddressBegin &&
      wordAddress.asUnsignedInt() <= instrWordAddressLimit);

  final List<List<Data>> byteMemory = List.generate(
    0x70,
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
    processorStateManager.updateMemAddState(newAddress);
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
    processorStateManager.updateMemoryState(newByte, storeAddress);
  }

  void storeByte(Data newByte) {
    final byte = newByte.byteList[0];
    setByte(byte, memoryAddress);
  }

  void storeHalf(Data newHalf) {
    bool addressNotDivBy2 = (memoryAddress.asUnsignedInt() & 0x1) != 0;
    if (addressNotDivBy2) {
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

  void storeInstruction(Data newWord, Data address) {
    final wordByteLength = 4;
    for (int i = 0; i < wordByteLength; i++) {
      final byte = newWord.byteList[i];
      final iterAddress = Data.word(address.asUnsignedInt() + i);
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

  @override
  void readBus() {
    super.readBus();
    processorStateManager.updateMemAddLoadState(addressloadEnable);
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

/* 
void presetInstructionLoad() {
  setByte(Data.fromUnsignedHexString('93', DataType.byte), Data.word(0));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(1));
  setByte(Data.fromUnsignedHexString('50', DataType.byte), Data.word(2));
  setByte(Data.fromUnsignedHexString('01', DataType.byte), Data.word(3));

  setByte(Data.fromUnsignedHexString('13', DataType.byte), Data.word(4));
  setByte(Data.fromUnsignedHexString('F1', DataType.byte), Data.word(5));
  setByte(Data.fromUnsignedHexString('F0', DataType.byte), Data.word(6));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(7));

  setByte(Data.fromUnsignedHexString('93', DataType.byte), Data.word(8));
  setByte(Data.fromUnsignedHexString('E1', DataType.byte), Data.word(9));
  setByte(Data.fromUnsignedHexString('80', DataType.byte), Data.word(10));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(11));

  setByte(Data.fromUnsignedHexString('13', DataType.byte), Data.word(12));
  setByte(Data.fromUnsignedHexString('12', DataType.byte), Data.word(13));
  setByte(Data.fromUnsignedHexString('D1', DataType.byte), Data.word(14));
  setByte(Data.fromUnsignedHexString('01', DataType.byte), Data.word(15));

  setByte(Data.fromUnsignedHexString('93', DataType.byte), Data.word(16));
  setByte(Data.fromUnsignedHexString('52', DataType.byte), Data.word(17));
  setByte(Data.fromUnsignedHexString('D2', DataType.byte), Data.word(18));
  setByte(Data.fromUnsignedHexString('01', DataType.byte), Data.word(19));

  setByte(Data.fromUnsignedHexString('13', DataType.byte), Data.word(20));
  setByte(Data.fromUnsignedHexString('53', DataType.byte), Data.word(21));
  setByte(Data.fromUnsignedHexString('D2', DataType.byte), Data.word(22));
  setByte(Data.fromUnsignedHexString('41', DataType.byte), Data.word(23));

  setByte(Data.fromUnsignedHexString('93', DataType.byte), Data.word(24));
  setByte(Data.fromUnsignedHexString('23', DataType.byte), Data.word(25));
  setByte(Data.fromUnsignedHexString('13', DataType.byte), Data.word(26));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(27));

  setByte(Data.fromUnsignedHexString('13', DataType.byte), Data.word(28));
  setByte(Data.fromUnsignedHexString('34', DataType.byte), Data.word(29));
  setByte(Data.fromUnsignedHexString('13', DataType.byte), Data.word(30));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(31));

  setByte(Data.fromUnsignedHexString('13', DataType.byte), Data.word(32));
  setByte(Data.fromUnsignedHexString('44', DataType.byte), Data.word(33));
  setByte(Data.fromUnsignedHexString('F4', DataType.byte), Data.word(34));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(35));

  setByte(Data.fromUnsignedHexString('B3', DataType.byte), Data.word(36));
  setByte(Data.fromUnsignedHexString('80', DataType.byte), Data.word(37));
  setByte(Data.fromUnsignedHexString('10', DataType.byte), Data.word(38));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(39));

  setByte(Data.fromUnsignedHexString('33', DataType.byte), Data.word(40));
  setByte(Data.fromUnsignedHexString('81', DataType.byte), Data.word(41));
  setByte(Data.fromUnsignedHexString('20', DataType.byte), Data.word(42));
  setByte(Data.fromUnsignedHexString('40', DataType.byte), Data.word(43));

  setByte(Data.fromUnsignedHexString('B3', DataType.byte), Data.word(44));
  setByte(Data.fromUnsignedHexString('F1', DataType.byte), Data.word(45));
  setByte(Data.fromUnsignedHexString('30', DataType.byte), Data.word(46));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(47));

  setByte(Data.fromUnsignedHexString('33', DataType.byte), Data.word(48));
  setByte(Data.fromUnsignedHexString('E2', DataType.byte), Data.word(49));
  setByte(Data.fromUnsignedHexString('30', DataType.byte), Data.word(50));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(51));

  setByte(Data.fromUnsignedHexString('B3', DataType.byte), Data.word(52));
  setByte(Data.fromUnsignedHexString('92', DataType.byte), Data.word(53));
  setByte(Data.fromUnsignedHexString('52', DataType.byte), Data.word(54));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(55));

  setByte(Data.fromUnsignedHexString('33', DataType.byte), Data.word(56));
  setByte(Data.fromUnsignedHexString('D3', DataType.byte), Data.word(57));
  setByte(Data.fromUnsignedHexString('52', DataType.byte), Data.word(58));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(59));

  setByte(Data.fromUnsignedHexString('B3', DataType.byte), Data.word(60));
  setByte(Data.fromUnsignedHexString('D3', DataType.byte), Data.word(61));
  setByte(Data.fromUnsignedHexString('52', DataType.byte), Data.word(62));
  setByte(Data.fromUnsignedHexString('40', DataType.byte), Data.word(63));

  setByte(Data.fromUnsignedHexString('33', DataType.byte), Data.word(64));
  setByte(Data.fromUnsignedHexString('24', DataType.byte), Data.word(65));
  setByte(Data.fromUnsignedHexString('74', DataType.byte), Data.word(66));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(67));

  setByte(Data.fromUnsignedHexString('33', DataType.byte), Data.word(68));
  setByte(Data.fromUnsignedHexString('34', DataType.byte), Data.word(69));
  setByte(Data.fromUnsignedHexString('04', DataType.byte), Data.word(70));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(71));

  setByte(Data.fromUnsignedHexString('33', DataType.byte), Data.word(72));
  setByte(Data.fromUnsignedHexString('44', DataType.byte), Data.word(73));
  setByte(Data.fromUnsignedHexString('74', DataType.byte), Data.word(74));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(75));

  /// LOAD
  setByte(Data.fromUnsignedHexString('83', DataType.byte), Data.word(76));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(77));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(78));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(79));

  setByte(Data.fromUnsignedHexString('03', DataType.byte), Data.word(80));
  setByte(Data.fromUnsignedHexString('41', DataType.byte), Data.word(81));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(82));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(83));

  setByte(Data.fromUnsignedHexString('83', DataType.byte), Data.word(84));
  setByte(Data.fromUnsignedHexString('11', DataType.byte), Data.word(85));
  setByte(Data.fromUnsignedHexString('40', DataType.byte), Data.word(86));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(87));

  setByte(Data.fromUnsignedHexString('03', DataType.byte), Data.word(88));
  setByte(Data.fromUnsignedHexString('52', DataType.byte), Data.word(89));
  setByte(Data.fromUnsignedHexString('40', DataType.byte), Data.word(90));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(91));

  setByte(Data.fromUnsignedHexString('83', DataType.byte), Data.word(92));
  setByte(Data.fromUnsignedHexString('22', DataType.byte), Data.word(93));
  setByte(Data.fromUnsignedHexString('C0', DataType.byte), Data.word(94));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(95));

  /// STORE
  setByte(Data.fromUnsignedHexString('23', DataType.byte), Data.word(96));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(97));
  setByte(Data.fromUnsignedHexString('50', DataType.byte), Data.word(98));
  setByte(Data.fromUnsignedHexString('10', DataType.byte), Data.word(99));

  setByte(Data.fromUnsignedHexString('23', DataType.byte), Data.word(100));
  setByte(Data.fromUnsignedHexString('11', DataType.byte), Data.word(101));
  setByte(Data.fromUnsignedHexString('50', DataType.byte), Data.word(102));
  setByte(Data.fromUnsignedHexString('10', DataType.byte), Data.word(103));

  setByte(Data.fromUnsignedHexString('23', DataType.byte), Data.word(104));
  setByte(Data.fromUnsignedHexString('22', DataType.byte), Data.word(105));
  setByte(Data.fromUnsignedHexString('50', DataType.byte), Data.word(106));
  setByte(Data.fromUnsignedHexString('10', DataType.byte), Data.word(107));

  /// B
  setByte(Data.fromUnsignedHexString('93', DataType.byte), Data.word(112));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(113));
  setByte(Data.fromUnsignedHexString('20', DataType.byte), Data.word(114));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(115));

  setByte(Data.fromUnsignedHexString('13', DataType.byte), Data.word(116));
  setByte(Data.fromUnsignedHexString('01', DataType.byte), Data.word(117));
  setByte(Data.fromUnsignedHexString('10', DataType.byte), Data.word(118));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(119));

  setByte(Data.fromUnsignedHexString('13', DataType.byte), Data.word(120));
  setByte(Data.fromUnsignedHexString('01', DataType.byte), Data.word(121));
  setByte(Data.fromUnsignedHexString('11', DataType.byte), Data.word(122));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(123));

  setByte(Data.fromUnsignedHexString('E3', DataType.byte), Data.word(124));
  setByte(Data.fromUnsignedHexString('0E', DataType.byte), Data.word(125));
  setByte(Data.fromUnsignedHexString('11', DataType.byte), Data.word(126));
  setByte(Data.fromUnsignedHexString('FE', DataType.byte), Data.word(127));

  setByte(Data.fromUnsignedHexString('93', DataType.byte), Data.word(128));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(129));
  setByte(Data.fromUnsignedHexString('50', DataType.byte), Data.word(130));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(131));

  setByte(Data.fromUnsignedHexString('13', DataType.byte), Data.word(132));
  setByte(Data.fromUnsignedHexString('01', DataType.byte), Data.word(133));
  setByte(Data.fromUnsignedHexString('A0', DataType.byte), Data.word(134));
  setByte(Data.fromUnsignedHexString('00', DataType.byte), Data.word(135));

  setByte(Data.fromUnsignedHexString('13', DataType.byte), Data.word(136));
  setByte(Data.fromUnsignedHexString('01', DataType.byte), Data.word(137));
  setByte(Data.fromUnsignedHexString('E1', DataType.byte), Data.word(138));
  setByte(Data.fromUnsignedHexString('FF', DataType.byte), Data.word(139));

  setByte(Data.fromUnsignedHexString('E3', DataType.byte), Data.word(140));
  setByte(Data.fromUnsignedHexString('5E', DataType.byte), Data.word(141));
  setByte(Data.fromUnsignedHexString('11', DataType.byte), Data.word(142));
  setByte(Data.fromUnsignedHexString('FE', DataType.byte), Data.word(143));

  setByte(Data.fromUnsignedHexString("93", DataType.byte), Data.word(144));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(145));
  setByte(Data.fromUnsignedHexString("B0", DataType.byte), Data.word(146));
  setByte(Data.fromUnsignedHexString("FF", DataType.byte), Data.word(147));

  setByte(Data.fromUnsignedHexString("13", DataType.byte), Data.word(148));
  setByte(Data.fromUnsignedHexString("01", DataType.byte), Data.word(149));
  setByte(Data.fromUnsignedHexString("20", DataType.byte), Data.word(150));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(151));

  setByte(Data.fromUnsignedHexString("13", DataType.byte), Data.word(152));
  setByte(Data.fromUnsignedHexString("01", DataType.byte), Data.word(153));
  setByte(Data.fromUnsignedHexString("F1", DataType.byte), Data.word(154));
  setByte(Data.fromUnsignedHexString("FF", DataType.byte), Data.word(155));

  setByte(Data.fromUnsignedHexString("E3", DataType.byte), Data.word(156));
  setByte(Data.fromUnsignedHexString("6E", DataType.byte), Data.word(157));
  setByte(Data.fromUnsignedHexString("11", DataType.byte), Data.word(158));
  setByte(Data.fromUnsignedHexString("FE", DataType.byte), Data.word(159));

  setByte(Data.fromUnsignedHexString("93", DataType.byte), Data.word(160));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(161));
  setByte(Data.fromUnsignedHexString("50", DataType.byte), Data.word(162));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(163));

  setByte(Data.fromUnsignedHexString("13", DataType.byte), Data.word(164));
  setByte(Data.fromUnsignedHexString("01", DataType.byte), Data.word(165));
  setByte(Data.fromUnsignedHexString("80", DataType.byte), Data.word(166));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(167));

  setByte(Data.fromUnsignedHexString("13", DataType.byte), Data.word(168));
  setByte(Data.fromUnsignedHexString("01", DataType.byte), Data.word(169));
  setByte(Data.fromUnsignedHexString("F1", DataType.byte), Data.word(170));
  setByte(Data.fromUnsignedHexString("FF", DataType.byte), Data.word(171));

  setByte(Data.fromUnsignedHexString("E3", DataType.byte), Data.word(172));
  setByte(Data.fromUnsignedHexString("CE", DataType.byte), Data.word(173));
  setByte(Data.fromUnsignedHexString("20", DataType.byte), Data.word(174));
  setByte(Data.fromUnsignedHexString("FE", DataType.byte), Data.word(175));

  setByte(Data.fromUnsignedHexString("93", DataType.byte), Data.word(176));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(177));
  setByte(Data.fromUnsignedHexString("50", DataType.byte), Data.word(178));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(179));

  setByte(Data.fromUnsignedHexString("13", DataType.byte), Data.word(180));
  setByte(Data.fromUnsignedHexString("01", DataType.byte), Data.word(181));
  setByte(Data.fromUnsignedHexString("F0", DataType.byte), Data.word(182));
  setByte(Data.fromUnsignedHexString("FF", DataType.byte), Data.word(183));

  setByte(Data.fromUnsignedHexString("13", DataType.byte), Data.word(184));
  setByte(Data.fromUnsignedHexString("01", DataType.byte), Data.word(185));
  setByte(Data.fromUnsignedHexString("21", DataType.byte), Data.word(186));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(187));

  setByte(Data.fromUnsignedHexString("E3", DataType.byte), Data.word(188));
  setByte(Data.fromUnsignedHexString("9E", DataType.byte), Data.word(189));
  setByte(Data.fromUnsignedHexString("20", DataType.byte), Data.word(190));
  setByte(Data.fromUnsignedHexString("FE", DataType.byte), Data.word(191));

  setByte(Data.fromUnsignedHexString("37", DataType.byte), Data.word(192));
  setByte(Data.fromUnsignedHexString("11", DataType.byte), Data.word(193));
  setByte(Data.fromUnsignedHexString("DE", DataType.byte), Data.word(194));
  setByte(Data.fromUnsignedHexString("0A", DataType.byte), Data.word(195));

  setByte(Data.fromUnsignedHexString("93", DataType.byte), Data.word(196));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(197));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(198));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(199));

  setByte(Data.fromUnsignedHexString("13", DataType.byte), Data.word(200));
  setByte(Data.fromUnsignedHexString("01", DataType.byte), Data.word(201));
  setByte(Data.fromUnsignedHexString("40", DataType.byte), Data.word(202));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(203));

  setByte(Data.fromUnsignedHexString("93", DataType.byte), Data.word(204));
  setByte(Data.fromUnsignedHexString("01", DataType.byte), Data.word(205));
  setByte(Data.fromUnsignedHexString("80", DataType.byte), Data.word(206));
  setByte(Data.fromUnsignedHexString("10", DataType.byte), Data.word(207));

  setByte(Data.fromUnsignedHexString("13", DataType.byte), Data.word(208));
  setByte(Data.fromUnsignedHexString("02", DataType.byte), Data.word(209));
  setByte(Data.fromUnsignedHexString("C0", DataType.byte), Data.word(210));
  setByte(Data.fromUnsignedHexString("10", DataType.byte), Data.word(211));

  setByte(Data.fromUnsignedHexString("93", DataType.byte), Data.word(212));
  setByte(Data.fromUnsignedHexString("02", DataType.byte), Data.word(213));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(214));
  setByte(Data.fromUnsignedHexString("11", DataType.byte), Data.word(215));

  setByte(Data.fromUnsignedHexString("13", DataType.byte), Data.word(216));
  setByte(Data.fromUnsignedHexString("03", DataType.byte), Data.word(217));
  setByte(Data.fromUnsignedHexString("40", DataType.byte), Data.word(218));
  setByte(Data.fromUnsignedHexString("11", DataType.byte), Data.word(219));

  setByte(Data.fromUnsignedHexString("C9", DataType.byte), Data.word(220));
  setByte(Data.fromUnsignedHexString("81", DataType.byte), Data.word(221));
  setByte(Data.fromUnsignedHexString("20", DataType.byte), Data.word(222));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(223));

  setByte(Data.fromUnsignedHexString("49", DataType.byte), Data.word(224));
  setByte(Data.fromUnsignedHexString("C2", DataType.byte), Data.word(225));
  setByte(Data.fromUnsignedHexString("11", DataType.byte), Data.word(226));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(227));

  setByte(Data.fromUnsignedHexString("C9", DataType.byte), Data.word(228));
  setByte(Data.fromUnsignedHexString("C2", DataType.byte), Data.word(229));
  setByte(Data.fromUnsignedHexString("21", DataType.byte), Data.word(230));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(231));

  setByte(Data.fromUnsignedHexString("49", DataType.byte), Data.word(232));
  setByte(Data.fromUnsignedHexString("F3", DataType.byte), Data.word(233));
  setByte(Data.fromUnsignedHexString("01", DataType.byte), Data.word(234));
  setByte(Data.fromUnsignedHexString("00", DataType.byte), Data.word(235));
} */
