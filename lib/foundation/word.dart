import 'package:microcoded_cpu_coe197/foundation/byte.dart';
import 'package:microcoded_cpu_coe197/foundation/data.dart';

class Word extends Data {
  Word({required super.intData});

  List<Byte> get byte {
    return [
      Byte(intData: intData & 0xFF),
      Byte(intData: (intData >> 8) & 0xFF),
      Byte(intData: (intData >> 16) & 0xFF),
      Byte(intData: (intData >> 24) & 0xFF),
    ];
  }

  factory Word.zero() {
    return Word(intData: 0);
  }

  factory Word.one() {
    return Word(intData: 1);
  }

  @override
  Word operator +(Data other) {
    return Word(intData: intData + other.intData);
  }
}
