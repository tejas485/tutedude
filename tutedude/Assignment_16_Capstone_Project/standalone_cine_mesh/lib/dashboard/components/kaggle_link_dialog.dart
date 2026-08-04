// lib/dashboard/components/kaggle_link_dialog.dart
import 'package:flutter/material.dart';
import '../../services/kaggle_file_provisioner.dart';
import '../../screens/components/session/terminal_dashboard.dart';
import '../../config/theme_config.dart';

class KaggleLinkDialog extends StatefulWidget {
  final VoidCallback onUpdate;

  const KaggleLinkDialog({super.key, required this.onUpdate});

  @override
  State<KaggleLinkDialog> createState() => _KaggleLinkDialogState();
}

class _KaggleLinkDialogState extends State<KaggleLinkDialog> {
  bool _isUploading = false;
  String _currentTaskPhase = "Awaiting credentials initialization matrix...";
  double _progressFraction = 0.0;
  final List<String> _consoleHistoryLog = [
    "Secure Local Provisioner Initialized.",
    "Isolated RAM disk allocations ready."
  ];

  void _triggerKaggleJsonPickerHandshake() async {
    setState(() {
      _isUploading = true;
      _currentTaskPhase = "Invoking native OS storage document selection frame...";
      _progressFraction = 0.05;
    });

    // Invoke automated asset encryption upload worker pipeline
    final result = await KaggleFileProvisioner.pickAndProcessKaggleJson(
      onProgressUpdate: (String phaseLabel, double fractionalProgress) {
        if (!mounted) return;
        setState(() {
          _currentTaskPhase = phaseLabel;
          _progressFraction = fractionalProgress;
          _consoleHistoryLog.add(phaseLabel);
        });
      },
    );

    if (!mounted) return;

    if (result["status"] == "SUCCESS") {
      widget.onUpdate();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Cluster Initialized Successfully! Connecting proxy links..."),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    } else {
      setState(() => _isUploading = false);
      if (result["status"] != "CANCELLED") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result["msg"] ?? "An automated cluster processing error occurred."),
          backgroundColor: CinemaMeshTheme.errorCrimson,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isUploading
            ? AnimatedTerminalDashboard(
          activePhase: _currentTaskPhase,
          currentProgressValue: _progressFraction,
          taskConsoleHistory: _consoleHistoryLog,
        )
            : Container(
          constraints: const BoxConstraints(maxWidth: 440),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.folder_zip_outlined, color: CinemaMeshTheme.primaryNeonRed, size: 24),
                  SizedBox(width: 10),
                  Text(
                    "Secure Local Provisioner",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                "Upload your auto-downloaded kaggle.json file below. "
                    "The configuration credentials will be processed strictly within volatile memory registers "
                    "and immediately shredded off disk boundaries.",
                style: TextStyle(fontSize: 13, color: CinemaMeshTheme.mutedSubtleGrey, height: 1.4),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CinemaMeshTheme.primaryNeonRed,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white, size: 16),
                    label: const Text(
                      "Select kaggle.json",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _triggerKaggleJsonPickerHandshake,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
