import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/core/controller/runtime_controller.dart';
import 'package:microcoded_cpu_coe197/core/state_manager/runtime_state_manager.dart';

class RuntimeUI extends StatefulWidget {
  const RuntimeUI({super.key});

  @override
  State<RuntimeUI> createState() => _RuntimeUIState();
}

class _RuntimeUIState extends State<RuntimeUI> {
  final runtimeController = RuntimeController.singleton;
  final runtimeStateManager = RuntimeStateManager.singleton;

  final double uiWidth = 800;
  final double uiHeight = 200;

  final uiBackground = Container(
    height: 80,
    width: 480,
    decoration: BoxDecoration(
      color: const Color.fromARGB(183, 6, 45, 104),
      border: Border.all(color: const Color.fromARGB(40, 0, 0, 0), width: 2.0),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(17, 0, 0, 0),
          offset: Offset(10, 10),
        ),
      ],
    ),
  );

  final runCycleButton = IconButton(
    onPressed: () {
      RuntimeController.singleton.runCycle();
    },
    icon: Icon(Icons.play_circle_fill_rounded, size: 30, color: Colors.white),
  );

  final uiInstruction = Column();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        height: uiHeight,
        width: uiWidth,
        decoration: BoxDecoration(
          color: const Color.fromARGB(0, 255, 255, 255),
        ),
        child: Stack(
          children: [
            Center(child: uiBackground),
            Center(
              child: Transform.translate(
                offset: Offset(150, 0),
                child: runCycleButton,
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(-0, -30),
                child: Text(
                  "runtime",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: "Nunito",
                    shadows: [
                      Shadow(offset: Offset(1, 1), color: Colors.black12),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(-0, 20),
                child: Text(
                  "cycles",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: "Nunito",
                    shadows: [
                      Shadow(offset: Offset(1, 1), color: Colors.black12),
                    ],
                  ),
                ),
              ),
            ),

            /// DIVIDERS
            Center(
              child: Transform.translate(
                offset: Offset(50, 0),
                child: SizedBox(
                  height: 60,
                  child: VerticalDivider(
                    thickness: 2,
                    color: const Color.fromARGB(40, 0, 0, 0),
                  ),
                ),
              ),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(-50, 0),
                child: SizedBox(
                  height: 60,
                  child: VerticalDivider(
                    thickness: 2,
                    color: const Color.fromARGB(40, 0, 0, 0),
                  ),
                ),
              ),
            ),

            Center(
              child: Transform.translate(
                offset: Offset(150, -30),
                child: Text(
                  "microcode",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: "Nunito",
                    shadows: [
                      Shadow(offset: Offset(1, 1), color: Colors.black12),
                    ],
                  ),
                ),
              ),
            ),

            /// CURRENT RUNTIME CYCLE
            Center(
              child: Transform.translate(
                offset: Offset(0, 0),
                child: ValueListenableBuilder(
                  valueListenable: runtimeStateManager.runtimeCycles,
                  builder: (context, value, child) {
                    final text = "$value";

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) {
                        final offsetAnimation =
                            Tween<Offset>(
                              begin: const Offset(0.25, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOutBack,
                              ),
                            );

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        text,
                        key: ValueKey(text),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontFamily: "Nunito",
                          shadows: [
                            Shadow(offset: Offset(1, 1), color: Colors.black12),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            /// CURRENT MICROCODE
            Center(
              child: Transform.translate(
                offset: Offset(95, 0),
                child: ValueListenableBuilder(
                  valueListenable: runtimeStateManager.currentMicrocodeLine,
                  builder: (context, value, child) {
                    final text = "0x${value.toRadixString(16)}";

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) {
                        final offsetAnimation =
                            Tween<Offset>(
                              begin: const Offset(0.25, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOutBack,
                              ),
                            );

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        text,
                        key: ValueKey(text),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "Nunito",
                          shadows: [
                            Shadow(offset: Offset(1, 1), color: Colors.black12),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            /// NEXT MICROCODE
            Center(
              child: Transform.translate(
                offset: Offset(200, 0),
                child: ValueListenableBuilder(
                  valueListenable: runtimeStateManager.nextMicrocodeLine,
                  builder: (context, value, child) {
                    final text = "0x${value.toRadixString(16)}";

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) {
                        final offsetAnimation =
                            Tween<Offset>(
                              begin: const Offset(0.25, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOutBack,
                              ),
                            );

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        text,
                        key: ValueKey(text),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: "Nunito",
                          shadows: [
                            Shadow(offset: Offset(1, 1), color: Colors.black12),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            /// BRANCH TYPE
            Center(
              child: Transform.translate(
                offset: Offset(150, 20),
                child: ValueListenableBuilder(
                  valueListenable: runtimeStateManager.branchType,
                  builder: (context, value, child) {
                    final text = value.name;

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, animation) {
                        final offsetAnimation =
                            Tween<Offset>(
                              begin: const Offset(0.25, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOutBack,
                              ),
                            );

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        text,
                        key: ValueKey(text),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "Nunito",
                          shadows: [
                            Shadow(offset: Offset(1, 1), color: Colors.black12),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
