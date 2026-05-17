// lib/widgets/circular_load_widget.dart

import 'package:flutter/material.dart';

class CircularLoadWidget extends StatelessWidget {
  final double currentLoad;

  const CircularLoadWidget({super.key, required this.currentLoad});

  @override
  Widget build(BuildContext context) {
    // Determine the background indicator color fill according to load thresholds
    Color backgroundColor = Colors.green.shade600;
    Color textColor = Colors.white;

    if (currentLoad >= 3.5) {
      backgroundColor = Colors.red.shade700;
    } else if (currentLoad >= 2.0) {
      backgroundColor = Colors.amber.shade700;
    }

    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle, // FIX: Enforces a strict circular geometry shape structure
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentLoad.toStringAsFixed(3),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: textColor,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'kW/h',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: textColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
