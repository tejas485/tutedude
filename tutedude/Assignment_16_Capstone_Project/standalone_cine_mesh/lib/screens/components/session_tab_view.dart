// lib/screens/components/session_tab_view.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../config/theme_config.dart';
import 'session/instruction_panel.dart';
import 'session/workspace_action_card.dart';
import 'session/web_assistant_card.dart';

class WorkspaceSessionTabView extends StatelessWidget {
  final String kaggleUrl;
  final String localTunnelUrl;
  final dynamic onKaggleViewCreated;
  final dynamic onTunnelViewCreated;
  final dynamic onUrlChanged;
  final Function(String verifiedUrl) onAutomationSuccess;

  const WorkspaceSessionTabView({
    super.key,
    required this.kaggleUrl,
    required this.localTunnelUrl,
    required this.onKaggleViewCreated,
    required this.onTunnelViewCreated,
    required this.onUrlChanged,
    required this.onAutomationSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (kIsWeb) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E17) : Colors.grey.shade50,
        body: Row(
          children: [
            // Left Column Track: Manual Checklist Steps Instructions
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
                ),
                child: WorkspaceInstructionPanel(kaggleUrl: kaggleUrl),
              ),
            ),

            // Right Column Track: Links and Ingestion Controllers Block
            Expanded(
              flex: 4,
              child: Container(
                color: isDark ? Colors.black12 : Colors.grey.shade100,
                padding: const EdgeInsets.all(32.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Renders exactly once at the top of the right panel column tree tracker
                      WorkspaceActionCard(kaggleUrl: kaggleUrl),
                      const SizedBox(height: 24),
                      WebAssistantCard(
                        localTunnelUrl: localTunnelUrl,
                        onSyncComplete: onAutomationSuccess,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dev Workspace Links')),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: CinemaMeshTheme.primaryNeonRed),
          onPressed: () => onAutomationSuccess(localTunnelUrl),
          child: const Text("Initialize Mobile Sync Handshake", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
