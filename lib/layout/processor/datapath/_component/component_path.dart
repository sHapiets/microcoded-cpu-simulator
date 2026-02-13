import 'package:flutter/painting.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/_component/component_painter.dart';

class ComponentPath {
  static Path paths(Size size, ComponentShape componentShape) {
    switch (componentShape) {
      case ComponentShape.alu:
        return Path()
          ..moveTo(0, size.height)
          ..lineTo(0, size.height * 0.6)
          ..lineTo(size.width * 0.2, size.height / 2)
          ..lineTo(0, size.height * 0.4)
          ..lineTo(0, size.height * 0)
          ..lineTo(size.width, size.height * 0.2)
          ..lineTo(size.width, size.height * 0.8)
          ..close();
      case ComponentShape.memory:
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20));
        return Path()..addRRect(rrect);
    }
  }
}
