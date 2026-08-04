// lib/screens/components/diagnostic_view.dart
import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

class WorkspaceDiagnosticView extends StatelessWidget {
  final String statusMessage;

  const WorkspaceDiagnosticView({super.key, required this.statusMessage});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? CinemaMeshTheme.deepSpaceBlack : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: CinemaMeshTheme.primaryNeonRed),
              const SizedBox(height: 28),
              const Text("CineMesh AI Core Initializer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 8),
              Text(statusMessage, style: const TextStyle(fontSize: 11, color: CinemaMeshTheme.mutedSubtleGrey), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
