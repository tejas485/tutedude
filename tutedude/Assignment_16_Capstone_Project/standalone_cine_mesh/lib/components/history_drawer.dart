// lib/components/history_drawer.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'movie_card.dart';
import '../config/theme_config.dart';

class HistoryDrawerOverlay extends StatelessWidget {
  final List<Map<String, dynamic>> rawHistoryObjects;
  final Color accentColor;
  final TextEditingController inputController;
  final Function(String key, int id, String dataValue) onMovieAction;
  final VoidCallback onClearAllHistory;

  const HistoryDrawerOverlay({
    super.key,
    required this.rawHistoryObjects,
    required this.accentColor,
    required this.inputController,
    required this.onMovieAction,
    required this.onClearAllHistory,
  });

  String parseTimestampLabel(String? isoString) {
    if (isoString == null || isoString.isEmpty) return "Recent Time";
    try {
      final parsed = DateTime.parse(isoString);
      // ─── LINT REPAIR FIXED: CONVERTED FROM CLOSURES TO STATIC FUNCTION METHODS ───
      String pad(int n) => n.toString().padLeft(2, '0');
      return "${parsed.year}-${pad(parsed.month)}-${pad(parsed.day)} at ${pad(parsed.hour)}:${pad(parsed.minute)}";
    } catch (_) {
      return "Saved Vibe";
    }
  }

  void _handleHistoryMovieCallback(BuildContext dialogCtx, String key, int id, String val) {
    Navigator.pop(dialogCtx);
    onMovieAction(key, id, val);
  }

  Widget _buildRecoveredMovieDisplayCard(BuildContext scrollCtx, List<Map<String, dynamic>> sourceList, int index, Color accent, bool isDark, BuildContext rootCtx) {
    return TmdbMovieDisplayCard(
      movieData: sourceList[index],
      fallbackIndex: index,
      currentAccent: accent,
      isDark: isDark,
      onAction: (String key, int id, String dataValue) => _handleHistoryMovieCallback(rootCtx, key, id, dataValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "AI Memory Matrix",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: accentColor),
              ),
              Row(
                children: [
                  if (rawHistoryObjects.isNotEmpty)
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: CinemaMeshTheme.errorCrimson),
                      icon: const Icon(Icons.delete_sweep, size: 16),
                      label: const Text("Wipe Logs", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      onPressed: onClearAllHistory,
                    ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: rawHistoryObjects.isEmpty
                ? const Center(
              child: Text(
                "No historical log entries registered in cloud nodes.",
                style: TextStyle(color: CinemaMeshTheme.mutedSubtleGrey, fontSize: 13),
              ),
            )
                : ListView.builder(
              itemCount: rawHistoryObjects.length,
              itemBuilder: (context, i) {
                final log = rawHistoryObjects[i];
                final String sender = log["sender"] ?? "user";
                final String msg = log["query"] ?? "";
                final String timestamp = parseTimestampLabel(log["timestamp"]);
                final bool isAi = sender == "cinemesh_ai";

                if (!isAi) {
                  return ListTile(
                    leading: Icon(Icons.account_circle, color: accentColor, size: 18),
                    title: Text(msg, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    subtitle: Text("Dispatched: $timestamp", style: const TextStyle(fontSize: 9, color: CinemaMeshTheme.mutedSubtleGrey)),
                    onTap: () {
                      inputController.text = msg;
                      Navigator.pop(context);
                    },
                  );
                }

                final String? attachedJson = log["attached_movies_json"];
                final bool hasMovies = attachedJson != null && attachedJson.isNotEmpty;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey.shade100,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ExpansionTile(
                    leading: Icon(Icons.auto_awesome, color: CinemaMeshTheme.amberGold, size: 16),
                    title: Text(
                      msg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text("Calculated: $timestamp", style: TextStyle(fontSize: 9, color: CinemaMeshTheme.mutedSubtleGrey)),
                    iconColor: accentColor,
                    childrenPadding: const EdgeInsets.all(12.0),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg,
                        style: TextStyle(fontSize: 11, height: 1.4, color: isDark ? Colors.white70 : Colors.black87),
                      ),
                      if (hasMovies) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(height: 1, color: Colors.white10),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.movie_filter, size: 14, color: Colors.white),
                          label: const Text("Show Recommended Movies", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            _revealRecoveredMoviesCarousel(context, attachedJson, isDark, accentColor);
                          },
                        ),
                      ]
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _revealRecoveredMoviesCarousel(BuildContext context, String jsonString, bool isDark, Color accent) {
    try {
      final List<dynamic> decodedList = jsonDecode(jsonString);
      final List<Map<String, dynamic>> parsedMovies = List<Map<String, dynamic>>.from(decodedList);

      showModalBottomSheet(
        context: context,
        backgroundColor: isDark ? CinemaMeshTheme.deepSpaceBlack : const Color(0xFFF4F6F9),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => Container(
          height: 380,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recovered Query Matches",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => Navigator.pop(ctx),
                    )
                  ],
                ),
              ),
              const Divider(indent: 20, endIndent: 20),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemCount: parsedMovies.length,
                  itemBuilder: (scrollCtx, index) => _buildRecoveredMovieDisplayCard(
                    scrollCtx,
                    parsedMovies,
                    index,
                    accent,
                    isDark,
                    context,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint("Failed to build recovered layout elements: $e");
    }
  }
}
