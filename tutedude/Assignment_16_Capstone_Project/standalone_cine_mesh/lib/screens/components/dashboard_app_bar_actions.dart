// lib/screens/components/dashboard_app_bar_actions.dart
import 'package:flutter/material.dart';

class DashboardAppBarActions extends StatelessWidget {
  final VoidCallback onStateRefreshRequired;

  const DashboardAppBarActions({
    super.key,
    required this.onStateRefreshRequired,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ─── REMOVED DUPLICATE FILE PICKER DIALOG LINK ───
        IconButton(
          tooltip: "Workspace Status Active",
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          padding: const EdgeInsets.all(8.0),
          icon: const Icon(
            Icons.cloud_done_outlined,
            color: Colors.amber,
            size: 22,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Use the Secure Local Provisioner panel below to manage your token files."),
              duration: Duration(seconds: 2),
            ));
          },
        ),
        const SizedBox(width: 4),
        IconButton(
          tooltip: "Lounge Theme Settings",
          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          padding: const EdgeInsets.all(8.0),
          icon: Icon(
            Icons.palette_outlined,
            color: colorScheme.onSurface.withValues(alpha: 0.7), // Fixed: Modern M3 precision compliance
            size: 22,
          ),
          onPressed: () {
            if (!context.mounted) return;
            Scaffold.of(context).openEndDrawer();
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
