// lib/dashboard/components/chat_toolbar.dart
import 'package:flutter/material.dart';

class ChatActionToolbar extends StatefulWidget {
  final Color currentAccent;
  final VoidCallback onViewHistory;
  final VoidCallback onViewFavorites;
  final VoidCallback onViewWatchLater;
  final Function(double minimumRating) onRatingThresholdChanged;

  const ChatActionToolbar({
    super.key,
    required this.currentAccent,
    required this.onViewHistory,
    required this.onViewFavorites,
    required this.onViewWatchLater,
    required this.onRatingThresholdChanged,
  });

  @override
  State<ChatActionToolbar> createState() => _ChatActionToolbarState();
}

class _ChatActionToolbarState extends State<ChatActionToolbar> {
  double _currentSliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      color: isDark ? Colors.black26 : Colors.grey.shade200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: widget.currentAccent),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
                icon: Icon(Icons.history, size: 11, color: widget.currentAccent),
                label: Text("History", style: TextStyle(color: widget.currentAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                onPressed: widget.onViewHistory,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: widget.currentAccent, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), elevation: 0),
                icon: const Icon(Icons.bookmark, size: 11, color: Colors.white),
                label: const Text("Favorites", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                onPressed: widget.onViewFavorites,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), elevation: 0),
                icon: const Icon(Icons.update, size: 11, color: Colors.white),
                label: const Text("Watch Later", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                onPressed: widget.onViewWatchLater,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(Icons.star_half, size: 14, color: widget.currentAccent),
                const SizedBox(width: 4),
                Text(
                  _currentSliderValue == 0.0 ? "All Ratings" : "${_currentSliderValue.toStringAsFixed(1)}+ ⭐",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4, // Slightly wider track path for visibility alignment
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      // ─── CRITICAL VISIBILITY UPGRADE FOR LIGHT/DARK MODES ───
                      tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 3.5),
                      activeTickMarkColor: isDark ? Colors.black87 : Colors.white70,
                      inactiveTickMarkColor: isDark ? Colors.white38 : Colors.black38,
                    ),
                    child: Slider(
                      value: _currentSliderValue,
                      min: 0.0,
                      max: 9.0,
                      divisions: 18,
                      activeColor: widget.currentAccent,
                      inactiveColor: isDark ? Colors.white10 : Colors.black12,
                      onChanged: (double value) {
                        setState(() => _currentSliderValue = value);
                        widget.onRatingThresholdChanged(value);
                      },
                    ),
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
