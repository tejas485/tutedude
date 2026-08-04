// lib/recommendation_grid.dart
import 'package:flutter/material.dart';
import 'components/movie_card.dart';

class MeshRecommendationGrid extends StatefulWidget {
  final List<Map<String, dynamic>> movies;
  final String userUid;
  final Color currentAccent;
  final Function(String key, int id, String dataValue) onPreferenceSave;

  const MeshRecommendationGrid({
    super.key,
    required this.movies,
    required this.userUid,
    required this.currentAccent,
    required this.onPreferenceSave,
  });

  @override
  State<MeshRecommendationGrid> createState() => _MeshRecommendationGridState();
}

class _MeshRecommendationGridState extends State<MeshRecommendationGrid> {
  final ScrollController _gridScrollController = ScrollController();

  @override
  void dispose() {
    _gridScrollController.dispose(); // Bypasses desktop canvas memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    // Constant parameters extracted from loops to preserve garbage collection memory pools
    const double cardWidth = 250.0;
    const double cardHorizontalMargins = 16.0;
    const double strictItemExtent = cardWidth + cardHorizontalMargins;

    return Scrollbar(
      controller: _gridScrollController,
      thumbVisibility: false, // Cleaner presentation matching dashboard aesthetics
      child: ListView.builder(
        controller: _gridScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: widget.movies.length,
        itemExtent: strictItemExtent, // Fixed layout size calculation optimization
        itemBuilder: (context, index) {
          return AnimatedMovieCardWrapper(
            movieMap: widget.movies[index],
            index: index,
            accent: widget.currentAccent,
            actionCallback: widget.onPreferenceSave,
          );
        },
      ),
    );
  }
}

class AnimatedMovieCardWrapper extends StatefulWidget {
  final Map<String, dynamic> movieMap;
  final int index;
  final Color accent;
  final Function(String key, int id, String dataValue) actionCallback;

  const AnimatedMovieCardWrapper({
    super.key,
    required this.movieMap,
    required this.index,
    required this.accent,
    required this.actionCallback,
  });

  @override
  State<AnimatedMovieCardWrapper> createState() => _AnimatedMovieCardWrapperState();
}

class _AnimatedMovieCardWrapperState extends State<AnimatedMovieCardWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController _bloomAnimationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Capped staggered calculations eliminating infinite duration accumulation loops
    final int boundedIndex = widget.index.clamp(0, 5);

    _bloomAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _bloomAnimationController,
      curve: Curves.easeOutCubic,
    );

    // Secure execution timing tracking safely inside the frame pipeline loop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Future.delayed(Duration(milliseconds: boundedIndex * 60), () {
        if (mounted) {
          _bloomAnimationController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _bloomAnimationController.dispose(); // Force-kills animation loops to prevent memory drift
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: TmdbMovieDisplayCard(
        movieData: widget.movieMap,
        fallbackIndex: widget.index,
        currentAccent: widget.accent,
        isDark: Theme.of(context).brightness == Brightness.dark,
        onAction: widget.actionCallback,
      ),
    );
  }
}
