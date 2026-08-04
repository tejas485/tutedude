// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'config/firebase_config.dart';
import 'services/kaggle_storage_service.dart';
import 'services/kaggle_automation_provisioner.dart';
import 'dashboard/dashboard_screen.dart';
import 'auth/login_screen.dart'; // ◄── 🔥 ADDED THIS MISSING IMPORT LINK RIGHT HERE

// Global ValueNotifier handles dark-theme status checks cleanly
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
final ValueNotifier<Color> accentColorNotifier = ValueNotifier(Colors.redAccent);

void main() async {
  // Unlocks low-level native architecture channel binds before bootstrapping widgets
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Establishes a secure connection to Firebase database nodes
    await Firebase.initializeApp(
      options: CinemaFirebaseConfig.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization bypass check error: $e");
  }

  // 🔄 AUTO-RESUMPTION INTERCEPT: Evaluates disk cache arrays upon engine boot context paths
  await KaggleStorageService.attemptHeadlessClusterAutoResumption();

  runApp(const CineMeshAppLifecycleOrchestrator());
}

class CineMeshAppLifecycleOrchestrator extends StatefulWidget {
  const CineMeshAppLifecycleOrchestrator({super.key});

  @override
  State<CineMeshAppLifecycleOrchestrator> createState() => _CineMeshAppLifecycleOrchestratorState();
}

class _CineMeshAppLifecycleOrchestratorState extends State<CineMeshAppLifecycleOrchestrator> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Registers active window state tracker hooks
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // 📴 SYSTEMIC CLOSURE INTERCEPT: Catches when the app window is killed or removed from background
    if (state == AppLifecycleState.detached || state == AppLifecycleState.hidden) {
      // Drop background keep-alive loop streams instantly to save remote computation limits
      KaggleAutomationProvisioner.terminateActiveKaggleClusterLifecycle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'CineMesh Lounge',
          themeMode: currentMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const AuthRouterSwitch(), // Points directly to your authorization gateway gate
        );
      },
    );
  }
}

class AuthRouterSwitch extends StatelessWidget {
  const AuthRouterSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasData && snap.data != null) {
          return CinemaOrchestrationDashboard(user: snap.data!);
        }
        // Points to your application login profile view
        return const StandaloneLoginScreen();
      },
    );
  }
}
