import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class DynamicLoadingOverlay extends StatefulWidget {
  final String textReason;
  const DynamicLoadingOverlay({super.key, this.textReason = "Processing Secure Operations..."});

  @override
  State<DynamicLoadingOverlay> createState() => _DynamicLoadingOverlayState();
}

class _DynamicLoadingOverlayState extends State<DynamicLoadingOverlay> with TickerProviderStateMixin {
  late int _chosenLoaderForm;

  // Animation properties
  late AnimationController _tickController;
  late Animation<double> _tickAnimation;

  late AnimationController _rollerController;

  // Typing animation state
  String _visibleText = "";
  int _typingIndex = 0;
  Timer? _typingTimer;
  final String _loadingPhrase = "Synchronizing across cloud instances...";

  @override
  void initState() {
    super.initState();
    // Randomly select one of the 3 animation options (0: Tickmark, 1: Typing, 2: Roller)
    _chosenLoaderForm = Random().nextInt(3);

    // Form 1: Tickmark config
    // FIXED: Corrected the vsync token layout from the accidental text corruption typo
    _tickController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _tickAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _tickController, curve: Curves.elasticOut),
    );
    if (_chosenLoaderForm == 0) {
      _tickController.repeat(reverse: true);
    }

    // Form 2: Typing config
    if (_chosenLoaderForm == 1) {
      _startTypingLoop();
    }

    // Form 3: Roller config
    _rollerController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    if (_chosenLoaderForm == 2) {
      _rollerController.repeat();
    }
  }

  void _startTypingLoop() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_typingIndex < _loadingPhrase.length) {
        setState(() {
          _visibleText += _loadingPhrase[_typingIndex];
          _typingIndex++;
        });
      } else {
        setState(() {
          _visibleText = "";
          _typingIndex = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _tickController.dispose();
    _typingTimer?.cancel();
    _rollerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seedColor = Theme.of(context).colorScheme.primary;

    return Container(
      // FIXED: Replaced with modern .withValues() syntax layer to fully clean the deprecation warning
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          constraints: const BoxConstraints(maxWidth: 340),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 24, offset: Offset(0, 12))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Renders one of the 3 chosen animation shapes dynamically
              if (_chosenLoaderForm == 0) _buildTickmarkAnimation(seedColor),
              if (_chosenLoaderForm == 1) _buildTypingAnimation(seedColor),
              if (_chosenLoaderForm == 2) _buildRollerAnimation(seedColor),
              const SizedBox(height: 24),
              Text(
                widget.textReason,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Loader 1: Task completion tickmark animation layout
  Widget _buildTickmarkAnimation(Color color) {
    return ScaleTransition(
      scale: _tickAnimation,
      child: Container(
        width: 80,
        height: 80,
        // FIXED: Replaced with modern .withValues() syntax layer to fully clean the deprecation warning
        decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.15)),
        child: Icon(Icons.check_circle_rounded, size: 54, color: color),
      ),
    );
  }

  // Loader 2: High-visibility typing script simulation line loader
  Widget _buildTypingAnimation(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      // FIXED: Wrapped the minHeight parameter inside a BoxConstraints element correctly
      constraints: const BoxConstraints(minHeight: 60),
      width: double.infinity,
      // FIXED: Replaced with modern .withValues() syntax layer to fully clean the deprecation warning
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
      child: Text(
        "$_visibleText▋",
        style: TextStyle(fontFamily: 'monospace', color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Loader 3: Modern 3D Neumorphic Roller
  Widget _buildRollerAnimation(Color color) {
    return RotationTransition(
      turns: _rollerController,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // FIXED: Replaced with modern .withValues() syntax layer to fully clean the deprecation warning
          border: Border.all(color: color.withValues(alpha: 0.1), width: 6),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
