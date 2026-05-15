import 'package:flutter/material.dart';
import 'snake_game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Flutter Snake',
      theme: ThemeData.dark(),
      home: const SnakeGameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
