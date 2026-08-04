// lib/components/watch_later_drawer.dart
import 'package:flutter/material.dart';
import '../config/theme_config.dart'; // ◄── FIXED IMPORT PATH LOCATION

class WatchLaterDrawerOverlay extends StatelessWidget {
  final List<Map<String, dynamic>> watchLaterData;
  final Color accentColor;
  final Function(Map<String, dynamic> movie) onTriggerReminder;
  final Function(Map<String, dynamic> movie) onRemoveMovie;

  const WatchLaterDrawerOverlay({
    super.key,
    required this.watchLaterData,
    required this.accentColor,
    required this.onTriggerReminder,
    required this.onRemoveMovie,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Watch Later Timeline",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: accentColor),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: watchLaterData.isEmpty
                ? Center(
              child: Text(
                "Your Watch Later queue is currently empty.",
                style: TextStyle(color: CinemaMeshTheme.mutedSubtleGrey, fontSize: 13),
              ),
            )
                : ListView.builder(
              itemCount: watchLaterData.length,
              itemBuilder: (context, i) {
                final item = watchLaterData[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  color: isDark ? Colors.black26 : Colors.grey.shade100,
                  child: ListTile(
                    title: Text(
                      item["title"] ?? "Unknown Title",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text("Director: ${item["director"] ?? "N/A"}", style: const TextStyle(fontSize: 11)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          // ─── DIAGNOSTIC FIX: REMOVED LEGACY CONST CONFLICT LAYOUT ERRORS HERE ───
                          icon: Icon(Icons.notification_add, color: CinemaMeshTheme.amberGold, size: 20),
                          onPressed: () => onTriggerReminder(item),
                        ),
                        IconButton(
                          // ─── DIAGNOSTIC FIX: REMOVED LEGACY CONST CONFLICT LAYOUT ERRORS HERE ───
                          icon: Icon(Icons.delete, color: CinemaMeshTheme.errorCrimson, size: 18),
                          onPressed: () => onRemoveMovie(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
