import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:microcoded_cpu_coe197/main.dart';

class AppbarUI extends StatelessWidget implements PreferredSizeWidget {
  const AppbarUI({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,

      flexibleSpace: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0x22000000), width: 1.2),
          ),
        ),
      ),

      titleSpacing: 24,

      title: Row(
        children: [
          // CHIP ICON
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Color(0xFF2E6F80), Color(0xFF3B8EA5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  color: Color(0x222E6F80),
                ),
              ],
            ),

            child: const Icon(
              Icons.memory_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 14),

          // TITLE SECTION
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Microcoded CPU Simulator",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  fontFamily: "Nunito",
                ),
              ),

              Text(
                "RISC-V 32-bit ISA + custom CISC",
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).disabledColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                  fontFamily: "Roboto-Mono",
                ),
              ),
            ],
          ),
        ],
      ),

      actions: [
        /* 
        _toolbarButton(Icons.play_arrow_rounded, "Run"),

        _toolbarButton(Icons.skip_next_rounded, "Step"),

        _toolbarButton(Icons.restart_alt_rounded, "Reset"), */
        _toolbarButton(Icons.light_mode_rounded, "Light Mode", () {
          themeModeNotifier.value = ThemeMode.light;
        }),

        _toolbarButton(Icons.dark_mode_rounded, "Dark Mode", () {
          themeModeNotifier.value = ThemeMode.dark;
        }),

        const SizedBox(width: 12),
      ],
    );
  }

  Widget _toolbarButton(IconData icon, String tooltip, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onPressed,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0x14000000)),
              ),
              child: Icon(icon, size: 22, color: const Color(0xFF2E6F80)),
            ),
          ),
        ),
      ),
    );
  }
}
