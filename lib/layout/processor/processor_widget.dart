import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/alu/alu_widget.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/alu/operands/a_widget.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/alu/operands/b_widget.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/bus/buffers_widget.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/bus/bus_widget.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/memory/memory_address_widget.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/memory/memory_widget.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/multiplexer/immediate_multiplexer_widget.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/multiplexer/reg_sel_multiplexer_widget.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/registers/instruction_register_widget.dart';
import 'package:microcoded_cpu_coe197/layout/processor/datapath/registers/register_file_widget.dart';

class ProcessorWidget extends StatefulWidget {
  const ProcessorWidget({super.key});

  @override
  State<ProcessorWidget> createState() => _ProcessorWidgetState();
}

class _ProcessorWidgetState extends State<ProcessorWidget> {
  final widgetWidth = 1280.0;
  final widgetHeight = 720.0;

  final Offset instrRegPosition = const Offset(-550, -250);
  final Offset immMultiplexerPosition = const Offset(-450, 30);
  final Offset regSelMultiplexerPosition = const Offset(-450, -150);
  final Offset registerPosition = const Offset(-200, -70);
  final Offset aPostion = const Offset(140, -100);
  final Offset bPostion = const Offset(180, 0);
  final Offset aluPosition = const Offset(350, -50);
  final Offset memoryPosition = const Offset(550, -50);
  final Offset memAddPosition = const Offset(500, -250);
  final Offset busPosition = const Offset(0, 200);
  final Offset buffersPosition = const Offset(0, 170);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        width: widgetWidth,
        height: widgetHeight,
        margin: EdgeInsets.all(50),
        child: Stack(
          children: [
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: aluPosition,
                child: ALUWidget(),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(offset: aPostion, child: AWidget()),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(offset: bPostion, child: BWidget()),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: memoryPosition,
                child: MemoryWidget(),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: memAddPosition,
                child: MemoryAddressWidget(),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: registerPosition,
                child: RegisterFileWidget(),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: regSelMultiplexerPosition,
                child: RegSelMultiplexerWidget(),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: immMultiplexerPosition,
                child: ImmediateMultiplexerWidget(),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: instrRegPosition,
                child: InstructionRegisterWidget(),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: busPosition,
                child: BusWidget(),
              ),
            ),
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: buffersPosition,
                child: BuffersWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
