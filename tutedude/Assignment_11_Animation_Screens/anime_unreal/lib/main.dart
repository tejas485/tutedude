import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animation Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// --- MAIN NAVIGATIONAL HOME SCREEN ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Animations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContainerAnimationScreen()),
              ),
              child: const Text('1. AnimatedContainer Screen'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OpacityAnimationScreen()),
              ),
              child: const Text('2. AnimatedOpacity Screen'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ControllerAnimationScreen()),
              ),
              child: const Text('3. AnimationController Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 1: ANIMATED CONTAINER (Implicit) ---
class ContainerAnimationScreen extends StatefulWidget {
  const ContainerAnimationScreen({super.key});

  @override
  State<ContainerAnimationScreen> createState() => _ContainerAnimationScreenState();
}

class _ContainerAnimationScreenState extends State<ContainerAnimationScreen> {
  bool _isExpanded = false;

  void _toggleContainer() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Container')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutBack, // Smooth elastic physics bounce effect
              width: _isExpanded ? 240.0 : 120.0,
              height: _isExpanded ? 240.0 : 120.0,
              decoration: BoxDecoration(
                color: _isExpanded ? Colors.teal : Colors.deepOrange,
                borderRadius: BorderRadius.circular(_isExpanded ? 32.0 : 8.0),
                boxShadow: _isExpanded
                    ? [BoxShadow(color: Colors.black26, blurRadius: 15, spreadRadius: 2)]
                    : [],
              ),
              child: const Center(
                child: Icon(Icons.star, color: Colors.white, size: 40),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _toggleContainer,
              child: const Text('Animate Properties'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 2: ANIMATED OPACITY (Implicit) ---
class OpacityAnimationScreen extends StatefulWidget {
  const OpacityAnimationScreen({super.key});

  @override
  State<OpacityAnimationScreen> createState() => _OpacityAnimationScreenState();
}

class _OpacityAnimationScreenState extends State<OpacityAnimationScreen> {
  bool _isVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Opacity')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.linear,
              child: const Card(
                elevation: 4,
                color: Colors.blueAccent,
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'Fading Content Block',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _toggleVisibility,
              child: Text(_isVisible ? 'Fade Out' : 'Fade In'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 3: ANIMATION CONTROLLER (Explicit) ---
class ControllerAnimationScreen extends StatefulWidget {
  const ControllerAnimationScreen({super.key});

  @override
  State<ControllerAnimationScreen> createState() => _ControllerAnimationScreenState();
}

// SingleTickerProviderStateMixin supplies the necessary ticker for fluid display frame sync
class _ControllerAnimationScreenState extends State<ControllerAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Explicit controller handles custom duration parameters
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Continuous 360 degree rotation curve definition
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.1415926535).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    // CRITICAL: Disposal closes running background tickers and frees system resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animation Controller')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AnimatedBuilder updates rotation values without rebuilding the full screen layout tree
            AnimatedBuilder(
              animation: _rotationAnimation,
              child: Container(
                width: 150,
                height: 150,
                color: Colors.indigo,
                child: const Center(
                  child: Text('Explicit', style: TextStyle(color: Colors.white)),
                ),
              ),
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: child,
                );
              },
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => _controller.forward(),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  icon: const Icon(Icons.settings_backup_restore),
                  onPressed: () => _controller.reverse(),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  icon: const Icon(Icons.loop),
                  onPressed: () => _controller.repeat(),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  icon: const Icon(Icons.stop),
                  onPressed: () => _controller.stop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
