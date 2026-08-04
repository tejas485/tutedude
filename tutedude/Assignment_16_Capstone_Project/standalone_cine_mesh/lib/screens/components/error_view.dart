// lib/screens/components/error_view.dart
import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

class WorkspaceErrorView extends StatelessWidget {
  final String errorMessage;

  const WorkspaceErrorView({super.key, required this.errorMessage});

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
              const Icon(Icons.gpp_bad_outlined, color: CinemaMeshTheme.errorCrimson, size: 44),
              const SizedBox(height: 16),
              const Text("Initialization Halted", style: TextStyle(fontWeight: FontWeight.bold, color: CinemaMeshTheme.errorCrimson, fontSize: 14)),
              const SizedBox(height: 8),
              Text(errorMessage, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: CinemaMeshTheme.primaryNeonRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () => Navigator.pop(context),
                child: const Text("Return to Lounge", style: TextStyle(color: Colors.white, fontSize: 12)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
