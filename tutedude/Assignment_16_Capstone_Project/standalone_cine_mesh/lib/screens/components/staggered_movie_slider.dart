// lib/screens/components/staggered_movie_slider.dart
import 'package:flutter/material.dart';

class StaggeredMovieSlider extends StatelessWidget {
  final List<dynamic> movies;
  final Widget Function(BuildContext context, Map<String, dynamic> itemData) cardBuilder;

  const StaggeredMovieSlider({
    super.key,
    required this.movies,
    required this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final rawItem = movies[index];
          if (rawItem is! Map<String, dynamic>) return const SizedBox.shrink();

          // ─── HIGH-FIDELITY STAGGER MULTIPLIER MECHANICS ───
          final int itemDelayOffsetMillis = index * 140;

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            curve: Curves.easeOutQuint,
            duration: Duration(milliseconds: 600 + itemDelayOffsetMillis),
            builder: (context, animValue, child) {
              // Mathematical transformations to compute dynamic fade-in offsets smoothly
              final double transformSlideY = (1.0 - animValue) * 45.0;

              return Opacity(
                opacity: animValue,
                child: Transform.translate(
                  offset: Offset(0, transformSlideY),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: SizedBox(
                width: 170,
                child: cardBuilder(context, rawItem),
              ),
            ),
          );
        },
      ),
    );
  }
}
