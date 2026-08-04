import 'package:flutter/material.dart';
import '../../../../core/theme/theme_controller.dart';

class OverallAnalyticsCard extends StatelessWidget {
  final double totalCompletionRatio;
  final bool isDark;
  final ThemeController themeCtrl;
  final int totalTasksCount;

  const OverallAnalyticsCard({
    super.key,
    required this.totalCompletionRatio,
    required this.isDark,
    required this.themeCtrl,
    required this.totalTasksCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeCtrl.getTintedSurface(context, strength: 0.12),
        borderRadius: const BorderRadius.all(Radius.circular(28)),
        boxShadow: themeCtrl.getNeumorphicShadow(context),
        border: Border.all(
          color: themeCtrl.currentSeedColor.withValues(alpha: 0.25),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: totalCompletionRatio,
                  strokeWidth: 8,
                  backgroundColor: isDark ? Colors.black38 : Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation(themeCtrl.currentSeedColor),
                ),
              ),
              Text(
                '${(totalCompletionRatio * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: themeCtrl.currentSeedColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Metric Status Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeCtrl.currentSeedColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalTasksCount == 0
                      ? 'Your queue logs are clear.'
                      : 'Keep processing updates to complete milestones.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
