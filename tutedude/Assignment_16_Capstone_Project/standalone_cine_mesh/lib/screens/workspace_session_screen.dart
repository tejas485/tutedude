// lib/screens/workspace_session_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/network_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../config/theme_config.dart';
import 'components/session_tab_view.dart';
import 'components/session/telemetry_loader_dial.dart';

class WorkspaceSessionScreen extends StatefulWidget {
  final String localTunnelUrl;
  final String kaggleUrl;

  const WorkspaceSessionScreen({
    super.key,
    required this.localTunnelUrl,
    required this.kaggleUrl,
  });

  @override
  State<WorkspaceSessionScreen> createState() => _WorkspaceSessionScreenState();
}

class _WorkspaceSessionScreenState extends State<WorkspaceSessionScreen> {
  late String _currentTargetKaggleUrl;
  late String _currentTunnelAddress;

  bool _isAwaitingNetworkVerificationResponse = false;
  bool _isHandshakeVerifiedSuccess = false;
  String _networkDiagnosticsFeedbackMessage = "";

  @override
  void initState() {
    super.initState();
    _currentTargetKaggleUrl = widget.kaggleUrl;
    _currentTunnelAddress = widget.localTunnelUrl;
  }

  void _handleSuccessfulTunnelParsing(String verifiedUrl) async {
    if (_isAwaitingNetworkVerificationResponse) return;

    // 🛡️ LINT REPAIR: PRE-CACHE LOCAL CONTEXT TO AVOID ASYNC GAP DRIFT WARNINGS
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isAwaitingNetworkVerificationResponse = true;
      _networkDiagnosticsFeedbackMessage = "Dispatching live connection packets over proxy node channels...";
    });

    await MeshNetworkService.updateLocalTunnelUrl(verifiedUrl);
    final bool isChannelOperational = await MeshNetworkService.verifyTunnelLiveness();

    if (!mounted) return;

    if (isChannelOperational) {
      setState(() {
        _currentTunnelAddress = verifiedUrl;
        _isHandshakeVerifiedSuccess = true;
        _isAwaitingNetworkVerificationResponse = false;
      });
    } else {
      await MeshNetworkService.updateLocalTunnelUrl(widget.localTunnelUrl);
      setState(() {
        _isAwaitingNetworkVerificationResponse = false;
        _isHandshakeVerifiedSuccess = false;
      });

      messenger.showSnackBar(const SnackBar(
        content: Text("Handshake Rejected: The entered URL failed live validation checks. Confirm your terminal script is operational."),
        backgroundColor: CinemaMeshTheme.errorCrimson,
        duration: Duration(seconds: 4),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isHandshakeVerifiedSuccess ? "Core Engine Handshake Status" : "Kaggle Web Automation Center",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        backgroundColor: CinemaMeshTheme.surfaceSlate,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
          onPressed: () {
            final navigator = Navigator.of(context);
            if (navigator.canPop()) {
              navigator.pop();
            } else {
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null) {
                navigator.pushReplacement(MaterialPageRoute(
                  builder: (ctx) => CinemaOrchestrationDashboard(user: currentUser),
                ));
              }
            }
          },
        ),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _isAwaitingNetworkVerificationResponse
              ? Center(
            child: TelemetryLoaderDial(
              status: "PENDING",
              currentLogMessage: _networkDiagnosticsFeedbackMessage,
            ),
          )
              : !_isHandshakeVerifiedSuccess
              ? WorkspaceSessionTabView(
            kaggleUrl: _currentTargetKaggleUrl,
            localTunnelUrl: _currentTunnelAddress,
            onKaggleViewCreated: (_) {},
            onTunnelViewCreated: (_) {},
            onUrlChanged: (a, b, c) {},
            onAutomationSuccess: _handleSuccessfulTunnelParsing,
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: TelemetryLoaderDial(
                    status: "SUCCESS",
                    currentLogMessage: "Kaggle cluster node verified active. Proxy link established successfully.",
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CinemaMeshTheme.emeraldGreen,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.forum_outlined, color: Colors.white, size: 18),
                    label: const Text(
                      "Continue to Lounge Messages",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    onPressed: () {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => CinemaOrchestrationDashboard(user: currentUser)),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
