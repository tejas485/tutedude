// lib/chat_panel.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard/components/chat_toolbar.dart'; // ◄── ARCHITECTURE IMPORT PATH CHANGED HERE
import 'recommendation_grid.dart';
import 'config/theme_config.dart'; // ◄── CONFIG MOVED UNDER CONFIG SUBFOLDER

class MeshChatPanel extends StatefulWidget {
  final List<Map<String, dynamic>> chatHistory;
  final TextEditingController inputController;
  final bool pending;
  final VoidCallback onSend;
  final Color currentAccent;
  final VoidCallback onViewHistory;
  final VoidCallback onViewFavorites;
  final VoidCallback onViewWatchLater;
  final Function(double minimumRating) onRatingThresholdChanged;
  final Function(String key, int id, String dataValue) onMovieAction;

  const MeshChatPanel({
    super.key,
    required this.chatHistory,
    required this.inputController,
    required this.pending,
    required this.onSend,
    required this.currentAccent,
    required this.onViewHistory,
    required this.onViewFavorites,
    required this.onViewWatchLater,
    required this.onRatingThresholdChanged,
    required this.onMovieAction,
  });

  @override
  State<MeshChatPanel> createState() => _MeshChatPanelState();
}

class _MeshChatPanelState extends State<MeshChatPanel> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant MeshChatPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chatHistory.length != oldWidget.chatHistory.length || widget.pending != oldWidget.pending) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        ChatActionToolbar(
          currentAccent: widget.currentAccent,
          onViewHistory: widget.onViewHistory,
          onViewFavorites: widget.onViewFavorites,
          onViewWatchLater: widget.onViewWatchLater,
          onRatingThresholdChanged: widget.onRatingThresholdChanged,
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            itemCount: widget.chatHistory.length,
            itemBuilder: (context, index) {
              final chatItem = widget.chatHistory[index];
              final String role = chatItem["role"] ?? "user";
              final bool isGemini = role == "gemini";
              final List<dynamic> movieList = chatItem["movies"] ?? [];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  crossAxisAlignment: isGemini ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isGemini
                            ? (isDark ? CinemaMeshTheme.surfaceSlate : Colors.grey.shade300)
                            : widget.currentAccent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        chatItem["msg"] ?? "",
                        style: TextStyle(color: isGemini ? (isDark ? Colors.white : Colors.black87) : Colors.white, fontSize: 13),
                      ),
                    ),
                    if (isGemini && movieList.isNotEmpty)
                      Container(
                        height: 310,
                        margin: const EdgeInsets.only(top: 10.0),
                        child: MeshRecommendationGrid(
                          movies: List<Map<String, dynamic>>.from(movieList),
                          userUid: FirebaseAuth.instance.currentUser?.uid ?? "x4zzNNvl4eXseCD7yLF0XWOULJ42",
                          currentAccent: widget.currentAccent,
                          onPreferenceSave: widget.onMovieAction,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),

        if (widget.pending)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 12, height: 12,
                        child: CircularProgressIndicator(strokeWidth: 1.5, valueColor: AlwaysStoppedAnimation<Color>(CinemaMeshTheme.amberGold)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "CineMesh is resolving multi-vector graphs...",
                        style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: isDark ? Colors.white60 : Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        Container(
          padding: const EdgeInsets.all(10.0),
          color: isDark ? CinemaMeshTheme.surfaceSlate : Colors.white,
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.inputController,
                    onSubmitted: (_) => widget.onSend(),
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Tell CineMesh your favorite movies...",
                      filled: true,
                      fillColor: isDark ? Colors.black12 : Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                CircleAvatar(
                  backgroundColor: widget.currentAccent,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 16),
                    onPressed: widget.onSend,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
