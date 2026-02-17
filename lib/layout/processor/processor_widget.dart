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

  final Offset instrRegPosition = const Offset(0, -250);
  final Offset immMultiplexerPosition = const Offset(100, 30);
  final Offset regSelMultiplexerPosition = const Offset(100, -150);
  final Offset registerPosition = const Offset(350, -70);
  final Offset aPostion = const Offset(690, -100);
  final Offset bPostion = const Offset(730, 0);
  final Offset aluPosition = const Offset(900, -50);
  final Offset memoryPosition = const Offset(1100, -50);
  final Offset memAddPosition = const Offset(1050, -250);
  final Offset busPosition = const Offset(0, 200);
  final Offset buffersPosition = const Offset(0, 170);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Transform.scale(
        scale: 0.8,
        child: Container(
          padding: EdgeInsetsGeometry.all(20),
          height: widgetHeight,
          width: widgetWidth,
          color: const Color.fromARGB(0, 124, 203, 51),
          child: Stack(
            children: [
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Transform.translate(
                  offset: aluPosition,
                  child: ALUWidget(),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Transform.translate(offset: aPostion, child: AWidget()),
              ),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Transform.translate(offset: bPostion, child: BWidget()),
              ),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Transform.translate(
                  offset: memoryPosition,
                  child: MemoryWidget(),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Transform.translate(
                  offset: memAddPosition,
                  child: MemoryAddressWidget(),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Transform.translate(
                  offset: registerPosition,
                  child: RegisterFileWidget(),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Transform.translate(
                  offset: regSelMultiplexerPosition,
                  child: RegSelMultiplexerWidget(),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Transform.translate(
                  offset: immMultiplexerPosition,
                  child: ImmediateMultiplexerWidget(),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Transform.translate(
                  offset: instrRegPosition,
                  child: InstructionRegisterWidget(),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Transform.translate(
                  offset: busPosition,
                  child: BusWidget(),
                ),
              ),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Transform.translate(
                  offset: buffersPosition,
                  child: BuffersWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
