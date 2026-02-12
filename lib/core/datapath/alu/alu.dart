import 'package:microcoded_cpu_coe197/core/datapath/alu/alu_operations.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/a.dart';
import 'package:microcoded_cpu_coe197/core/datapath/alu/operands/b.dart';
import 'package:microcoded_cpu_coe197/core/datapath/bus.dart';
import 'package:microcoded_cpu_coe197/core/datapath/component.dart';
import 'package:microcoded_cpu_coe197/core/foundation/data.dart';

class ALU extends Component {
  ALU._();
  static final singleton = ALU._();

  final a = A.singleton;
  final b = B.singleton;
  final bus = Bus.singleton;

  ALUOperation operation = ALUOperation.add;
  Data result = Data.wordZero();

  void operate() {
    final int aMinBitLength = a.data.dataType.bitLength;
    final int bMinBitLength = b.data.dataType.bitLength;
    final minDataType = (aMinBitLength > bMinBitLength)
        ? a.data.dataType
        : b.data.dataType;
    final maxDataType = (aMinBitLength > bMinBitLength)
        ? b.data.dataType
        : a.data.dataType;

    switch (operation) {
      case ALUOperation.copyA:
        result = a.data;
      case ALUOperation.copyB:
        result = b.data;
      case ALUOperation.inc1toA:
        result = Data.signedAdd(a.data, Data.word(1), a.data.dataType);
      case ALUOperation.dec1toA:
        result = Data.signedSub(a.data, Data.word(1), a.data.dataType);
      case ALUOperation.inc4toA:
        result = Data.signedAdd(a.data, Data.word(4), a.data.dataType);
      case ALUOperation.dec4toA:
        result = Data.signedSub(a.data, Data.word(4), a.data.dataType);
      case ALUOperation.add:
        result = Data.signedAdd(a.data, b.data, minDataType);
      case ALUOperation.sub:
        result = Data.signedSub(a.data, b.data, minDataType);
      case ALUOperation.slt:
        final aSigned = a.data.asSignedInt();
        final bSigned = b.data.asSignedInt();
        result = (aSigned < bSigned) ? Data.bit(1) : Data.bit(0);
      case ALUOperation.sltu:
        final aUnsigned = a.data.asUnsignedInt();
        final bUnsigned = b.data.asUnsignedInt();
        result = (aUnsigned < bUnsigned) ? Data.bit(1) : Data.bit(0);
      case ALUOperation.sra:
        final aSigned = a.data.asSignedInt();
        final shiftAmount = b.data.asUnsignedInt();
        result = Data(
          signedInt: (aSigned >> shiftAmount).toSigned(
            a.data.dataType.bitLength,
          ),
          dataType: a.data.dataType,
        );
      case ALUOperation.srl:
        final aUnsigned = a.data.asUnsignedInt();
        final shiftAmount = b.data.asUnsignedInt();
        result = Data(
          signedInt: aUnsigned >> shiftAmount,
          dataType: a.data.dataType,
        );
      case ALUOperation.sll:
        final aUnsigned = a.data.asUnsignedInt();
        final shiftAmount = b.data.asUnsignedInt();
        result = Data(
          signedInt: aUnsigned << shiftAmount,
          dataType: a.data.dataType,
        );
      case ALUOperation.bitXOR:
        final aSigned = a.data.asSignedInt();
        final bSigned = b.data.asSignedInt();
        final resultSigned = (aSigned ^ bSigned).toSigned(
          minDataType.bitLength,
        );
        result = Data(signedInt: resultSigned, dataType: minDataType);
      case ALUOperation.bitOR:
        final aSigned = a.data.asSignedInt();
        final bSigned = b.data.asSignedInt();
        final resultSigned = (aSigned | bSigned).toSigned(
          minDataType.bitLength,
        );
        result = Data(signedInt: resultSigned, dataType: minDataType);
      case ALUOperation.bitAND:
        final aSigned = a.data.asSignedInt();
        final bSigned = b.data.asSignedInt();
        final resultSigned = (aSigned & bSigned).toSigned(
          maxDataType.bitLength,
        );
        result = Data(signedInt: resultSigned, dataType: maxDataType);
    }
  }

  Data getResult() {
    operate();
    return result;
  }

  @override
  void updateBus() {
    operate();
    bus.passData(newData: result, componentBuffer: Buffer.aluEn);
    super.updateBus();
  }
}
