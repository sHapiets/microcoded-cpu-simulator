import 'package:flutter/cupertino.dart';
import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/immediate_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/datapath/multiplexers/reg_sel_multiplexer.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';
import 'package:microcoded_cpu_coe197/core/foundation/register_address.dart';

class ProcessorStateManager {
  ProcessorStateManager._();
  static final singleton = ProcessorStateManager._();

  Map<RegisterAddress, ValueNotifier<Data>> regFileState = {};

  List<List<ValueNotifier<Data>>> memoryState = List.generate(
    0x1ff,
    (_) => List.generate(4, (_) => ValueNotifier(Data.byteZero())),
  );

  Map<Buffer, ValueNotifier<bool>> bufferState = {
    Buffer.immEn: ValueNotifier(false),
    Buffer.regEn: ValueNotifier(false),
    Buffer.aluEn: ValueNotifier(false),
    Buffer.memEn: ValueNotifier(false),
  };

  ValueNotifier<Data> busDataState = ValueNotifier(Data.word(0));

  ValueNotifier<Data> aDataState = ValueNotifier(Data.word(0));
  ValueNotifier<Data> bDataState = ValueNotifier(Data.word(0));
  ValueNotifier<Data> memAddState = ValueNotifier(Data.word(0));
  ValueNotifier<Data> instrRegState = ValueNotifier(Data.word(0));

  ValueNotifier<bool> aLoadState = ValueNotifier(false);
  ValueNotifier<bool> bLoadState = ValueNotifier(false);
  ValueNotifier<bool> memAddLoadState = ValueNotifier(false);
  ValueNotifier<bool> instrRegLoadState = ValueNotifier(false);

  ValueNotifier<RegSel> regSelState = ValueNotifier(RegSel.rd);
  ValueNotifier<ImmSel> immSelState = ValueNotifier(ImmSel.immTypeB);

  void updateRegFileState(RegisterAddress registerAddress, Data newData) {
    regFileState[registerAddress]!.value = newData;
  }

  void initializeRegFileState(Map<RegisterAddress, Data> initializedRegFile) {
    regFileState = initializedRegFile.map((registerAddress, initializedData) {
      return MapEntry(registerAddress, ValueNotifier(initializedData));
    });
  }

  void updateMemoryState(Data newByte, Data memoryAddress) {
    int getMemoryWordAddress = memoryAddress.asUnsignedInt() >> 2;
    int getMemoryByteAddress = memoryAddress.asUnsignedInt() & 0x3;

    memoryState[getMemoryWordAddress][getMemoryByteAddress].value = newByte;
  }

  void updateBufferState(Buffer buffer, bool enableBool) {
    bufferState[buffer]!.value = enableBool;
  }

  void updateBusDataState(Data newData) {
    busDataState.value = newData;
  }

  void updateADataState(Data newData) {
    aDataState.value = newData;
  }

  void updateBDataState(Data newData) {
    bDataState.value = newData;
  }

  void updateMemAddState(Data newAddress) {
    memAddState.value = newAddress;
  }

  void updateInstrRegState(Data newInstrWord) {
    instrRegState.value = newInstrWord;
  }

  void updateALoadState(bool enableBool) {
    aLoadState.value = enableBool;
  }

  void updateBLoadState(bool enableBool) {
    bLoadState.value = enableBool;
  }

  void updateMemAddLoadState(bool enableBool) {
    memAddLoadState.value = enableBool;
  }

  void updateInstrRegLoadState(bool enableBool) {
    instrRegLoadState.value = enableBool;
  }

  void updateRegSelState(RegSel newRegSel) {
    regSelState.value = newRegSel;
  }

  void updateImmSelState(ImmSel newImmSel) {
    immSelState.value = newImmSel;
  }
}
