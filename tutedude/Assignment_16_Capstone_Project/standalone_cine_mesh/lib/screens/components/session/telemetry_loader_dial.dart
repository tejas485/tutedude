// lib/screens/components/session/telemetry_loader_dial.dart
import 'package:flutter/material.dart';
import '../../../config/theme_config.dart';

class TelemetryLoaderDial extends StatelessWidget {
  final String status;
  final String currentLogMessage;

  const TelemetryLoaderDial({
    super.key,
    required this.status,
    required this.currentLogMessage,
  });

  /// Evaluates the terminal stream output strings and assigns a precise completion percentage
  double _calculateCompilationPercentage() {
    if (status == "SUCCESS") return 1.0;
    if (status == "CRASH" || status == "ERROR") return 0.0;

    final msg = currentLogMessage.toLowerCase();
    if (msg.contains("initialized cleanly") || msg.contains("fully deployed")) {
      return 0.95;
    }
    if (msg.contains("syncing notebook") || msg.contains("mounted to runtime")) {
      return 0.65;
    }
    if (msg.contains("metadata") || msg.contains("initialization")) {
      return 0.35;
    }
    return 0.10; // Default bootstrapping phase
  }

  @override
  Widget build(BuildContext context) {
    final double completionFraction = _calculateCompilationPercentage();
    final int percentInt = (completionFraction * 100).toInt();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glowing Backdrop Track Ring
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? Colors.white10 : Colors.black12,
                  ),
                ),
              ),
              // High-Precision Segmented Telemetry Arc Track
              SizedBox(
                width: 140,
                height: 140,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: completionFraction),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, animValue, _) {
                    return CircularProgressIndicator(
                      value: animValue,
                      strokeWidth: 10,
                      strokeCap: StrokeCap.round,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        CinemaMeshTheme.primaryNeonRed,
                      ),
                    );
                  },
                ),
              ),
              // Inner Percentage Text Analytics Displays
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$percentInt%",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: status == "ERROR" || status == "CRASH"
                          ? CinemaMeshTheme.errorCrimson
                          : CinemaMeshTheme.amberGold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Clean Telemetry Logger Terminal Overlay Message Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                currentLogMessage,
                key: ValueKey(currentLogMessage),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: CinemaMeshTheme.mutedSubtleGrey,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
