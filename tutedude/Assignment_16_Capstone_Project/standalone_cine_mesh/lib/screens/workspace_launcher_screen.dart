// lib/screens/workspace_launcher_screen.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../services/kaggle_storage_service.dart';
import 'workspace_session_screen.dart';

class WorkspaceLauncherScreen extends StatefulWidget {
  const WorkspaceLauncherScreen({super.key});

  @override
  State<WorkspaceLauncherScreen> createState() => _WorkspaceLauncherScreenState();
}

class _WorkspaceLauncherScreenState extends State<WorkspaceLauncherScreen> {
  final String _currentStepMessage = "Waking up Kaggle cluster nodes...";
  bool _isLoaderActive = true;
  String? _fatalErrorFound;

  @override
  void initState() {
    super.initState();
    _startUniversalHandshakeLoop();
  }

  void _startUniversalHandshakeLoop() async {
    // 🌐 SPLITTING GATEWAY: If Web is identified, skip all popups and launch page 2 directly
    if (kIsWeb) {
      debugPrint("🌐 Web build identified. Route directly to Web Automation Center.");
      _navigateToSession("https://loca.lt", "web_user");
      return;
    }

    // 📱 DESKTOP & MOBILE PROFILE VALIDATION LOOP
    final credentials = await KaggleStorageService.getCredentials();
    final String user = credentials["username"] ?? "";
    final String token = credentials["key"] ?? credentials["apiKey"] ?? "";

    if (user.isEmpty || token.isEmpty) {
      if (!mounted) return;
      setState(() {
        _isLoaderActive = false;
        _fatalErrorFound = "Authentication Error: No local Kaggle token cached. Please upload your kaggle.json file first.";
      });
      return;
    }

    _navigateToSession("https://loca.lt", user);
  }

  void _navigateToSession(String tunnelUrl, String username) {
    final String verifiedKaggleUrl = "https://kaggle.com";

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (routeCtx) => WorkspaceSessionScreen(
        localTunnelUrl: tunnelUrl,
        kaggleUrl: verifiedKaggleUrl,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoaderActive) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E17) : Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(color: Color(0xFFFF2E93), strokeWidth: 3),
                ),
                const SizedBox(height: 24),
                Text("CineMesh AI Core Initializer", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(_currentStepMessage, style: textTheme.bodySmall, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0E17) : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gpp_bad_outlined, color: Color(0xFFFF1744), size: 44),
              const SizedBox(height: 16),
              Text("Initialization Halted", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFFF1744))),
              const SizedBox(height: 8),
              Text(_fatalErrorFound ?? "An unexpected processing fault occurred.", style: textTheme.bodySmall, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF2E93),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) navigator.pop();
                },
                child: const Text("Return to Lounge", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
