import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigation_shell.dart';
import 'services/notification_service.dart';

void main() async {
  // 1. Guarantee native hardware widget bindings are locked before initialization
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize the centralized multi-user Cloud Firebase pipeline
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Instantiate the background/foreground cross-platform messaging notification engine
  final NotificationService notificationService = NotificationService();
  await notificationService.initializeNotificationEngine();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Encrypted Collaborative Workspace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      // Automatically listens to authentication changes across all your web testing tabs or mobile devices
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Display placeholder layout while the server is validating session tokens
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // If a user token is verified, bypass the portal and direct them to the main workspace rail
          if (snapshot.hasData && snapshot.data != null) {
            return const MainNavigationShell();
          }

          // Fallback state: Force unauthenticated users to register via the Auth portal
          return const AuthScreen();
        },
      ),
    );
  }
}
