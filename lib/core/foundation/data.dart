class Data {
  Data({required this.signedInt, required this.dataType}) {
    int minSignedBitLength = signedInt.bitLength + 1;
    if (dataType == DataType.bit) {
      minSignedBitLength = 1;
    }
    if (minSignedBitLength > dataType.bitLength) {
      throw FormatException(
        '[DATA ERROR] --> Constructed Data(signedInt: $signedInt) needs $minSignedBitLength as a signed integer, but the DataType: "${dataType.name}" only has ${dataType.bitLength}. This is a source code error and not a runtime parameter bug.',
      );
    }

    unsignedInt = signedInt.toUnsigned(dataType.bitLength);
  }

  int unsignedInt = 0;
  final int signedInt;
  final DataType dataType;

  bool isNegative() => signedInt != unsignedInt;

  bool asBool() {
    if (unsignedInt != 0 && unsignedInt != 1) {
      throw FormatException(
        '[DATA ERROR] --> Attempt to get asBool() from Data.unsignedInt: "$unsignedInt",  which cannot be represented as a bool (unsignedInt = 0/1 only)',
      );
    }

    return (unsignedInt == 0) ? false : true;
  }

  List<Data> get byteList {
    switch (dataType) {
      case DataType.bit:
        return [asType(DataType.byte)];
      case DataType.byte:
        return [this];
      case DataType.fiveBit:
        return [
          Data.byte(signedInt & 0xFF),
          Data.byte((signedInt >> 8) & 0xFF),
        ];
      case DataType.halfword:
        return [
          Data.byte(signedInt & 0xFF),
          Data.byte((signedInt >> 8) & 0xFF),
        ];
      case DataType.word:
        return [
          Data.byte(signedInt & 0xFF),
          Data.byte((signedInt >> 8) & 0xFF),
          Data.byte((signedInt >> 16) & 0xFF),
          Data.byte((signedInt >> 24) & 0xFF),
        ];
    }
  }

  String asUnsignedBitString(int bitLength) {
    return unsignedInt.toRadixString(2).padLeft(bitLength, '0');
  }

  String asUnsignedHexString(int hexLength) {
    return unsignedInt.toRadixString(16).padLeft(hexLength, '0');
  }

  int asSignedInt() {
    return signedInt;
  }

  int asUnsignedInt() {
    return unsignedInt;
  }

  Data asType(DataType newDataType) {
    return Data(signedInt: signedInt, dataType: newDataType);
  }

  factory Data.signedAdd(Data a, Data b, DataType dataType) {
    final sum = (a.asSignedInt() + b.asSignedInt());
    final signedSum = sum.toSigned(dataType.bitLength);
    return Data(signedInt: signedSum, dataType: dataType);
  }
  factory Data.signedSub(Data a, Data b, DataType dataType) {
    final diff = a.asSignedInt() - b.asSignedInt();
    final signedDiff = diff.toSigned(dataType.bitLength);
    return Data(signedInt: signedDiff, dataType: dataType);
  }

  factory Data.fromUnsignedHexString(String hexString, DataType dataType) {
    final int unsignedHexAsInt = int.parse(hexString, radix: 16);
    final int signedHexAsInt = unsignedHexAsInt.toSigned(dataType.bitLength);
    return Data(signedInt: signedHexAsInt, dataType: dataType);
  }

  factory Data.fromUnsignedBitString(String bitString, DataType dataType) {
    final int unsignedBitsAsInt = int.parse(bitString, radix: 2);
    final int signedBitsAsInt = unsignedBitsAsInt.toSigned(dataType.bitLength);
    return Data(signedInt: signedBitsAsInt, dataType: dataType);
  }

  factory Data.bit(int signedInt) {
    return Data(signedInt: signedInt, dataType: DataType.bit);
  }
  factory Data.fiveBit(int signedInt) {
    return Data(signedInt: signedInt, dataType: DataType.fiveBit);
  }
  factory Data.byte(int signedInt) {
    return Data(signedInt: signedInt, dataType: DataType.byte);
  }
  factory Data.halfWord(int signedInt) {
    return Data(signedInt: signedInt, dataType: DataType.halfword);
  }
  factory Data.word(int signedInt) {
    return Data(signedInt: signedInt, dataType: DataType.word);
  }

  factory Data.wordZero() {
    return Data.word(0);
  }
  factory Data.wordOne() {
    return Data.word(1);
  }
  factory Data.byteZero() {
    return Data.byte(0);
  }

  factory Data.wordFromBytes(List<Data> bytes) {
    int sumUnsignedInt = 0;
    sumUnsignedInt += bytes[0].asUnsignedInt();
    sumUnsignedInt += bytes[1].asUnsignedInt() << 8;
    sumUnsignedInt += bytes[2].asUnsignedInt() << 16;
    sumUnsignedInt += bytes[3].asUnsignedInt() << 24;
    int sumSignedInt = sumUnsignedInt.toSigned(32);
    return Data.word(sumSignedInt);
  }
}

enum DataType {
  bit(bitLength: 1),
  fiveBit(bitLength: 5),
  byte(bitLength: 8),
  halfword(bitLength: 16),
  word(bitLength: 32);

  const DataType({required this.bitLength});
  final int bitLength;
}
