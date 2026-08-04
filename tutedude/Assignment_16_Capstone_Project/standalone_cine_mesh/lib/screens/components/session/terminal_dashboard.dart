// lib/screens/components/session/terminal_dashboard.dart
import 'package:flutter/material.dart';
import '../../../config/theme_config.dart';

class AnimatedTerminalDashboard extends StatelessWidget {
  final String activePhase;
  final double currentProgressValue;
  final List<String> taskConsoleHistory;

  const AnimatedTerminalDashboard({
    super.key,
    required this.activePhase,
    required this.currentProgressValue,
    required this.taskConsoleHistory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Card(
          color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white10, width: 1),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFFF5F56), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF27C93F), shape: BoxShape.circle)),
                    const SizedBox(width: 16),
                    const Text("cinemesh_core_provisioner.sh", style: TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'monospace')),
                  ],
                ),
                const Divider(color: Colors.white10, height: 24),
                Text(
                  "CURRENT INSTANTIATION TASK:",
                  style: TextStyle(color: CinemaMeshTheme.amberGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    activePhase,
                    key: ValueKey(activePhase),
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'monospace', height: 1.3),
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: currentProgressValue,
                    backgroundColor: Colors.white.withValues(alpha: 0.05), // ◄── FIX APPLIED
                    minHeight: 6,
                    valueColor: const AlwaysStoppedAnimation<Color>(CinemaMeshTheme.primaryNeonRed),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${(currentProgressValue * 100).toInt()}% ALLOCATED",
                      style: const TextStyle(color: Colors.white30, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("CONSOLE TRACE STREAM:", style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(6)),
                  child: ListView.builder(
                    itemCount: taskConsoleHistory.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          "> ${taskConsoleHistory[index]}",
                          style: TextStyle(
                            color: index == taskConsoleHistory.length - 1 ? Colors.greenAccent : Colors.white60,
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
