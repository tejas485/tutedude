// lib/components/movie_card.dart
import 'package:flutter/material.dart';
import '../config/theme_config.dart'; // ◄── FIXED IMPORT PATH LOCATION
import 'movie_card_header.dart';
import 'movie_card_actions.dart';

class TmdbMovieDisplayCard extends StatelessWidget {
  final Map<String, dynamic> movieData;
  final int fallbackIndex;
  final Color currentAccent;
  final bool isDark;
  final Function(String key, int id, String dataValue) onAction;

  const TmdbMovieDisplayCard({
    super.key,
    required this.movieData,
    required this.fallbackIndex,
    required this.currentAccent,
    required this.isDark,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final int id = movieData["id"] is int ? movieData["id"] as int : fallbackIndex;
    final String title = movieData["title"]?.toString() ?? "Unknown Title";
    final String description = movieData["description"]?.toString() ?? "No plot details available.";
    final String tagline = movieData["tagline"]?.toString() ?? "";
    final String director = movieData["director"]?.toString() ?? "Unknown";
    final String homepage = movieData["homepage"]?.toString() ?? "https://themoviedb.org";

    final double rating = (movieData["vote_average"] is num) ? (movieData["vote_average"] as num).toDouble() : 0.0;
    final int runtime = (movieData["runtime_minutes"] is num)
        ? (movieData["runtime_minutes"] as num).toInt()
        : 0;
    final double similarity = (movieData["similarity_score"] is num) ? (movieData["similarity_score"] as num).toDouble() : 0.0;

    List<String> genresList = [];
    if (movieData["genres"] is List) {
      genresList = (movieData["genres"] as List).map((e) => e.toString()).toList();
    } else if (movieData["genres"] is String) {
      genresList = [movieData["genres"].toString()];
    }
    if (genresList.isEmpty) genresList = ["Film"];

    List<String> castList = [];
    if (movieData["cast"] is List) {
      castList = (movieData["cast"] as List).map((e) => e.toString()).toList();
    }

    final String runtimeDisplay = runtime > 0 ? "${runtime ~/ 60}h ${runtime % 60}m" : "N/A";
    final Color textColorTheme = isDark ? Colors.white70 : Colors.black87;

    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isDark ? CinemaMeshTheme.surfaceSlate : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 3))
        ],
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MovieCardHeader(title: title, rating: rating, currentAccent: currentAccent, isDark: isDark),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 11, color: currentAccent),
                              const SizedBox(width: 3),
                              Text(runtimeDisplay, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textColorTheme)),
                            ],
                          ),
                          Text("${(similarity * 100).toStringAsFixed(0)}% Match", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: CinemaMeshTheme.emeraldGreen)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4, runSpacing: 4,
                        children: genresList.take(3).map((genre) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: currentAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                          child: Text(genre.toUpperCase(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: currentAccent)),
                        )).toList(),
                      ),
                      const SizedBox(height: 8),
                      if (tagline.isNotEmpty) ...[
                        Text('"$tagline"', style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: CinemaMeshTheme.mutedSubtleGrey)),
                        const SizedBox(height: 6),
                      ],
                      Text(description, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.black54, height: 1.35)),
                      const Divider(height: 16, color: Colors.white10),
                      Row(
                        children: [
                          const Text("Director: ", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: CinemaMeshTheme.mutedSubtleGrey)),
                          Expanded(child: Text(director, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: textColorTheme))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Cast: ", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: CinemaMeshTheme.mutedSubtleGrey)),
                          Expanded(child: Text(castList.isNotEmpty ? castList.take(3).join(", ") : "N/A", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: textColorTheme, fontSize: 10))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MovieCardActions(id: id, title: title, homepage: homepage, currentAccent: currentAccent, isDark: isDark, onAction: onAction),
          ],
        ),
      ),
    );
  }
}
