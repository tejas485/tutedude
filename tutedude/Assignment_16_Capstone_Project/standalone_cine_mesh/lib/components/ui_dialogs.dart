// lib/components/ui_dialogs.dart
import 'package:flutter/material.dart';
import '../config/theme_config.dart'; // ◄── STATIC CONFIG DEPTH RELOCATION FIXED

class CinemaUiDialogs {
  static void showWarningAlert(BuildContext context, String titleText, String bodyText) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: CinemaMeshTheme.warningOrange, size: 22),
            const SizedBox(width: 8),
            Text(titleText, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(bodyText, style: const TextStyle(fontSize: 13, color: CinemaMeshTheme.mutedSubtleGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Acknowledge", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  static void showActionConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Text(message, style: const TextStyle(fontSize: 13, color: CinemaMeshTheme.mutedSubtleGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: CinemaMeshTheme.mutedSubtleGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CinemaMeshTheme.errorCrimson,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(confirmLabel, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
