import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added clean direct Stream access
import 'package:provider/provider.dart';
import 'package:todo/core/services/notification_service.dart';
import 'package:todo/core/services/fcm_service.dart';
import 'package:todo/core/theme/theme_controller.dart';
import 'package:todo/features/auth/controllers/auth_controller.dart';
import 'package:todo/features/todo/controllers/todo_controller.dart';
import 'package:todo/features/auth/views/login_screen.dart';
import 'package:todo/features/todo/views/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyA8iz0wu4mAi-m9n4IUqbx7YInWiMQEooM",
        authDomain: "todo-is-cool.firebaseapp.com",
        projectId: "todo-is-cool",
        storageBucket: "todo-is-cool.firebasestorage.app",
        messagingSenderId: "251038220230",
        appId: "1:251038220230:web:d73a04c085fcbcc7953cc7"
    ),
  );

  final themeController = ThemeController();

  await SimplifiedNotificationEngine.init();
  await FcmService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => TodoController()),
        ChangeNotifierProvider.value(value: themeController),
      ],
      child: const MindfulTaskApp(),
    ),
  );
}

class MindfulTaskApp extends StatelessWidget {
  const MindfulTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Provider.of<ThemeController>(context, listen: true);

    final customTransitionsTheme = PageTransitionsTheme(
      builders: {
        TargetPlatform.android: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: const CupertinoPageTransitionsBuilder(),
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mindful Tasks ✨',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeCtrl.currentSeedColor,
          brightness: Brightness.light,
        ),
        pageTransitionsTheme: customTransitionsTheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeCtrl.currentSeedColor,
          brightness: Brightness.dark,
        ),
        pageTransitionsTheme: customTransitionsTheme,
      ),
      themeMode: themeCtrl.themeMode,

      // FIXED ENGINE GUARD: Replaced volatile local variable checks with a native Firebase StreamBuilder.
      // This forces Flutter to rebuild the widget tree instantly when a login or logout event happens,
      // entirely eliminating the need for browser refreshes.
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the network handshake is still computing, render a simple center spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: themeCtrl.currentSeedColor),
              ),
            );
          }

          // True Reactive Guard Gate Switcher Loop
          if (snapshot.hasData && snapshot.data != null) {
            return const DashboardScreen(); // Direct push on successful verification
          }

          return const LoginScreen(); // Fallback back to login screen on hard logout purges
        },
      ),
    );
  }
}
