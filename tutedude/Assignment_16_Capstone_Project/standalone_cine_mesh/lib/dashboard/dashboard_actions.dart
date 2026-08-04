// lib/dashboard/dashboard_actions.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dashboard_imports.dart';
import 'package:standalone_cine_mesh/screens/workspace_session_screen.dart';
import 'components/kaggle_link_dialog.dart'; // Handles file parsing overlay card

class DashboardActionsHandler {
  /// Entry point routing users to the appropriate configuration layer based on platform context
  static Future<void> pasteAndApplyKaggleTunnel(BuildContext context, VoidCallback onUpdate) async {
    await CinemaNotificationService.displayLocalRetentionPing();
    if (!context.mounted) return;

    if (kIsWeb) {
      // 🌐 WEB ROUTE: Bypasses file picker overlay, routes straight to checksheet manual view
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const WorkspaceSessionScreen(
            localTunnelUrl: "",
            kaggleUrl: "https://kaggle.com",
          ),
        ),
      );
    } else {
      // 📱 NATIVE MOBILE ROUTE (Android/iOS): Invokes the secure credential JSON file picker dialog layout
      showDialog(
        context: context,
        builder: (ctx) => KaggleLinkDialog(
          onUpdate: onUpdate,
        ),
      );
    }
  }

  /// Processes contextual actions sent up from individual movie layout cards safely
  static Future<void> routeMovieInteraction({
    required BuildContext context,
    required String key,
    required int id,
    required String dataValue,
    required List<Map<String, dynamic>> chatHistory,
    required List<Map<String, dynamic>> localWatchLater,
    required String userUid,
    required VoidCallback onUpdate,
  }) async {
    if (key == "view_url") {
      final Uri url = Uri.parse(dataValue);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
      return;
    }

    Map<String, dynamic>? targetMovie;
    for (var chat in chatHistory.reversed) {
      final movies = chat["movies"] as List?;
      if (movies == null || movies.isEmpty) continue;

      for (var m in movies) {
        if (m is Map && m["id"] == id) {
          targetMovie = Map<String, dynamic>.from(m);
          break;
        }
      }
      if (targetMovie != null) break;
    }

    if (targetMovie == null) return;

    if (key == "watch_later") {
      if (!localWatchLater.any((m) => m["id"] == id)) {
        localWatchLater.add(targetMovie);
        onUpdate();
      }
    } else if (key == "bookmark") {
      await FirebaseFirestore.instance.collection('cinema_users').doc(userUid).set({
        'bookmarks': FieldValue.arrayUnion([targetMovie])
      }, SetOptions(merge: true));
    }
  }
}
