import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int diceNumber = 1;
  bool isRolling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  void rollDice() {
    if (isRolling) return;
    setState(() => isRolling = true);

    _controller.forward(from: 0).then((_) {
      setState(() {
        diceNumber = Random().nextInt(6) + 1;
        isRolling = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Generate random spin values during animation
                double angle = _controller.value * 12 * pi;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002) // Perspective
                    ..rotateX(isRolling ? angle : 0)
                    ..rotateY(isRolling ? angle * 0.5 : 0)
                    ..rotateZ(isRolling ? angle * 0.2 : 0),
                  child: DiceFace(number: diceNumber),
                );
              },
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: isRolling ? null : rollDice,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: Text(isRolling ? 'ROLLING...' : 'ROLL DICE',
                  style: const TextStyle(fontSize: 20, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DiceFace extends StatelessWidget {
  final int number;
  const DiceFace({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15)],
      ),
      child: CustomPaint(painter: DicePainter(number)),
    );
  }
}

class DicePainter extends CustomPainter {
  final int number;
  DicePainter(this.number);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final double r = size.width * 0.1; // Dot radius
    final double center = size.width / 2;
    final double left = size.width * 0.25;
    final double right = size.width * 0.75;
    final double top = size.height * 0.25;
    final double bottom = size.height * 0.75;

    List<Offset> getDots() {
      switch (number) {
        case 1: return [Offset(center, center)];
        case 2: return [Offset(left, top), Offset(right, bottom)];
        case 3: return [Offset(left, top), Offset(center, center), Offset(right, bottom)];
        case 4: return [Offset(left, top), Offset(right, top), Offset(left, bottom), Offset(right, bottom)];
        case 5: return [Offset(left, top), Offset(right, top), Offset(center, center), Offset(left, bottom), Offset(right, bottom)];
        case 6: return [Offset(left, top), Offset(right, top), Offset(left, center), Offset(right, center), Offset(left, bottom), Offset(right, bottom)];
        default: return [];
      }
    }

    for (var dot in getDots()) {
      canvas.drawCircle(dot, r, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
