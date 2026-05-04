import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FunTime AllTime',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const FibonacciHomeScreen(),
    );
  }
}

class FibonacciHomeScreen extends StatefulWidget {
  const FibonacciHomeScreen({super.key});

  @override
  State<FibonacciHomeScreen> createState() => _FibonacciHomeScreenState();
}

class _FibonacciHomeScreenState extends State<FibonacciHomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<List<int>> _pyramid = [];

  void _generatePyramid(String input) {
    int? rows = int.tryParse(input);

    // Clear if input is empty or invalid
    if (rows == null || rows <= 0) {
      setState(() => _pyramid = []);
      return;
    }

    // Limit rows to 12 for better mobile screen fitting
    if (rows > 12) rows = 12;

    // Calculate total numbers needed for the pyramid: (n * (n + 1)) / 2
    int totalNumbers = (rows * (rows + 1)) ~/ 2;

    // Generate Fibonacci Sequence
    List<int> fib = [0, 1];
    for (int i = 2; i < totalNumbers; i++) {
      fib.add(fib[i - 1] + fib[i - 2]);
    }

    // Slice sequence into pyramid rows
    List<List<int>> tempPyramid = [];
    int currentIdx = 0;
    for (int i = 1; i <= rows; i++) {
      if (currentIdx < fib.length) {
        int end = currentIdx + i;
        // Safety check for indices
        tempPyramid.add(fib.sublist(currentIdx, end > fib.length ? fib.length : end));
        currentIdx += i;
      }
    }

    setState(() => _pyramid = tempPyramid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Yellow Background
      appBar: AppBar(
        title: const Text('FunTime AllTime'), // AppBar Title
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Here's the Mummy 😊", // Section Title with Emoji
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter number of rows (e.g. 5)',
                prefixIcon: Icon(Icons.sentiment_very_satisfied), // Smiling Emoji Icon
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              onChanged: _generatePyramid,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _pyramid.map((row) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        row.join('   '), // Pyramid Display
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
