// lib/components/movie_card_actions.dart
import 'package:flutter/material.dart';

class MovieCardActions extends StatelessWidget {
  final int id;
  final String title;
  final String homepage;
  final Color currentAccent;
  final bool isDark;
  final Function(String key, int id, String dataValue) onAction;

  const MovieCardActions({
    super.key,
    required this.id,
    required this.title,
    required this.homepage,
    required this.currentAccent,
    required this.isDark,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final BorderSide optionalBorder = BorderSide(
      color: isDark ? Colors.white24 : Colors.black12,
    );

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          // 1. View Movie Website Target Button
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: currentAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                elevation: 0,
              ),
              onPressed: () => onAction("view_url", id, homepage),
              child: const Text("View Website", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 6),

          // 2. Favorite Bookmark Button
          IconButton(
            // ─── FIXED: MOVED PROPERTY TO TOP LEVEL WIDGET PROPERTY NODE ───
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: optionalBorder),
            ),
            icon: Icon(Icons.bookmark_border, size: 16, color: isDark ? Colors.white70 : Colors.black54),
            onPressed: () => onAction("bookmark", id, title),
          ),
          const SizedBox(width: 6),

          // 3. 🍿 THE WATCH LATER ACTION BUTTON
          IconButton(
            // ─── FIXED: MOVED PROPERTY TO TOP LEVEL WIDGET PROPERTY NODE ───
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: optionalBorder),
            ),
            icon: const Icon(Icons.watch_later_outlined, size: 16, color: Colors.amber),
            onPressed: () => onAction("watch_later", id, title),
          ),
        ],
      ),
    );
  }
}
