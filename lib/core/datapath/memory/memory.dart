import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/byte.dart';
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
  void setByte(Byte newData) {
    byteMemory[memoryWordAddress][memoryByteAddress] = newData;
  }

  final int instrWordAddressBegin = 0x00;
  final int instrWordAddressLimit = 0xFF;
  final int dynamicWordAddressBegin = 0x100;
  final int dynamicWordAddressLimit = 0x1FF;
  bool get memAddressOnInstrSpace =>
      (memoryWordAddress >= instrWordAddressBegin &&
      memoryWordAddress <= instrWordAddressLimit);

  bool addressloadEnable = false;
  bool writeEnable = false;

  void setMemAddress(Word newAddress) {
    memoryAddress = newAddress;
  }

  void setAddressLoadEnable(bool enableBool) {
    addressloadEnable = enableBool;
  }

  void setMemWriteEnable(bool enableBool) {
    writeEnable = enableBool;
  }

  void storeByte(Byte newByte) {
    if (memAddressOnInstrSpace == true) {
      throw FormatException(
        '[MEMORY ERROR]: Attempted to write on Instruction Space during runtime. Dynamic Memory spans only from 0x${dynamicWordAddressBegin.toRadixString(16)}00 to 0x${dynamicWordAddressLimit.toRadixString(16)}FF',
      );
    } else if (writeEnable == true) {
      setByte(newByte);
    }
  }

  void storeWord() {}

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
    byteMemory[0][0] = Byte.fromHexString('B3');
    byteMemory[0][1] = Byte.fromHexString('01');
    byteMemory[0][2] = Byte.fromHexString('11');
    byteMemory[0][3] = Byte.fromHexString('00');
    byteMemory[1][0] = Byte.fromHexString('B3');
    byteMemory[1][1] = Byte.fromHexString('00');
    byteMemory[1][2] = Byte.fromHexString('31');
    byteMemory[1][3] = Byte.fromHexString('00');
  }

  @override
  void readBus() {
    if (addressloadEnable == true) {
      final busData = bus.getData();
      setMemAddress(busData.asWord());
    }
    super.readBus();
  }

  @override
  void updateBus() {
    loadWord();
    super.updateBus();
  }
}
