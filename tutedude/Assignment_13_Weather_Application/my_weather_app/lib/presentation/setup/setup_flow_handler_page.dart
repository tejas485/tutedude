import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/weather_setup_service.dart';
import '../dashboard/weather_dashboard_page.dart';

class SetupFlowHandlerPage extends StatefulWidget {
  const SetupFlowHandlerPage({super.key});

  @override
  State<SetupFlowHandlerPage> createState() => _SetupFlowHandlerPageState();
}

class _SetupFlowHandlerPageState extends State<SetupFlowHandlerPage> {
  final WeatherSetupService _setupService = WeatherSetupService();
  final TextEditingController _keyInputController = TextEditingController();

  String _statusMessage = "Setting up your weather space...";
  bool _showKeyEntryForm = false;
  bool _isCheckingKey = false;
  bool _needsPermissionFallback = false;

  @override
  void initState() {
    super.initState();
    _executeSystemCheck();
  }

  Future<void> _executeSystemCheck() async {
    setState(() {
      _needsPermissionFallback = false;
      _statusMessage = "Checking your connection to the web...";
    });

    bool networkOk = await _setupService.isNetworkConnected();
    if (!networkOk) {
      setState(() => _statusMessage = "Oops! We can't reach the internet. Please check your data or Wi-Fi connection.");
      return;
    }

    setState(() => _statusMessage = "Requesting device permission tokens...");
    bool permissionsOk = await _setupService.requestInitialPermissions();
    if (!permissionsOk) {
      setState(() {
        _needsPermissionFallback = true;
        _statusMessage = "Location access is turned off. We need location access to show weather updates for where you are.";
      });
      return;
    }

    setState(() {
      _showKeyEntryForm = true;
      _statusMessage = "We're online! Please enter your OpenWeather API key to finish setup.";
    });
  }

  Future<void> _verifyAndSubmitKey() async {
    String token = _keyInputController.text.trim();
    if (token.isEmpty) return;

    setState(() {
      _isCheckingKey = true;
      _statusMessage = "Verifying your API key with OpenWeather servers...";
    });

    bool isValid = await _setupService.validateApiKey(token);
    if (isValid) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => WeatherDashboardPage(apiKey: token)),
      );
    } else {
      setState(() {
        _isCheckingKey = false;
        _statusMessage = "Hmm, that key didn't work. Double-check your key code or wait a few minutes for it to activate.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_queue, size: 80, color: Colors.blueAccent),
                const SizedBox(height: 24),
                Text(_statusMessage, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.4)),
                const SizedBox(height: 32),

                if (_needsPermissionFallback) ...[
                  ElevatedButton.icon(
                    onPressed: () async {
                      await openAppSettings();
                      _executeSystemCheck();
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text("Open App Settings"),
                  ),
                  const SizedBox(height: 12),
                ],

                if (!_showKeyEntryForm && !_isCheckingKey)
                  ElevatedButton.icon(
                    onPressed: _executeSystemCheck,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry Check"),
                  ),

                if (_showKeyEntryForm && !_isCheckingKey) ...[
                  TextField(
                    controller: _keyInputController,
                    decoration: const InputDecoration(labelText: "Paste API Key Here", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _verifyAndSubmitKey,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                      child: const Text("Validate & Continue"),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _setupService.launchApiKeyGenerationWebsite(),
                    child: const Text("Create a key here"),
                  ),
                ],
                if (_isCheckingKey) const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
