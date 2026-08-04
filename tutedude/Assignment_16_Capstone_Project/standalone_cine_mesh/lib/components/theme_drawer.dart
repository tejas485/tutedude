// lib/components/theme_drawer.dart
import 'package:flutter/material.dart';
import '../config/theme_config.dart'; // ◄── RELATIVE DEPTH FIXED FROM COMPONENTS SUBFOLDER

class ThemeConfigurationDrawer extends StatelessWidget {
  final Color currentAccent;
  final bool isDark;
  final ValueChanged<Color> onAccentColorChanged; // ◄── DECUPLED METHOD SIGNATURE INJECTED

  const ThemeConfigurationDrawer({
    super.key,
    required this.currentAccent,
    required this.isDark,
    required this.onAccentColorChanged, // ◄── BOUND PARAMETER CONTEXT FIXED
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: isDark ? CinemaMeshTheme.surfaceSlate : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: currentAccent),
              child: const Center(
                child: Text(
                  "Configure Theme Matrix",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "SELECT ACTIVE BRAND COLOR:",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CinemaMeshTheme.mutedSubtleGrey),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: CinemaMeshTheme.colorPaletteMap.entries.map((entry) {
                  final isSelected = currentAccent == entry.value;
                  return Card(
                    color: isSelected ? currentAccent.withValues(alpha: 0.15) : Colors.transparent,
                    elevation: 0,
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: entry.value, radius: 10),
                      title: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      trailing: isSelected ? Icon(Icons.check_circle, color: currentAccent, size: 18) : null,
                      onTap: () {
                        onAccentColorChanged(entry.value);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
