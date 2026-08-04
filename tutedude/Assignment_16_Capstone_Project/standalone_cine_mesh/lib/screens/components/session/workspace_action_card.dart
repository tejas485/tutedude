// lib/screens/components/session/workspace_action_card.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/theme_config.dart';

// ─── 🌐 SAFE CROSS-PLATFORM CONDITIONAL IMPORTS ───
// Maps to the empty baseline on Android, but automatically switches to the
// true web download routines when compiling a web target.
import 'download_helper_stub.dart'
if (dart.library.js_interop) 'download_helper_web.dart';

class WorkspaceActionCard extends StatelessWidget {
  final String kaggleUrl;

  const WorkspaceActionCard({super.key, required this.kaggleUrl});

  Future<void> _triggerLocalAssetDownload(BuildContext context, String assetSubPath) async {
    try {
      if (kIsWeb) {
        // Runs cleanly on web browser builds
        executeWebAssetDownload(assetSubPath);
        return;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Mobile & Desktop builds handle dataset allocation automatically upon kaggle.json upload."),
          backgroundColor: CinemaMeshTheme.amberGold,
        ));
      }
    } catch (e) {
      debugPrint("Failed to invoke local asset download pipeline: $e");
    }
  }

  Future<void> _openKaggleConsoleExternal() async {
    try {
      final Uri targetUri = Uri.parse(kaggleUrl);
      if (await canLaunchUrl(targetUri)) {
        await launchUrl(targetUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Failed to load official Kaggle interface room: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.hub_outlined, color: CinemaMeshTheme.primaryNeonRed, size: 20),
              SizedBox(width: 8),
              Text("Secure Workspace Links", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: CinemaMeshTheme.primaryNeonRed,
              side: const BorderSide(color: CinemaMeshTheme.primaryNeonRed),
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            ),
            icon: const Icon(Icons.cloud_download_outlined, size: 16),
            label: const Text("Download core_kernel.ipynb Notebook", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            onPressed: () => _triggerLocalAssetDownload(context, "backend/core_kernel.ipynb"),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: CinemaMeshTheme.primaryNeonRed,
              side: const BorderSide(color: CinemaMeshTheme.primaryNeonRed),
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            ),
            icon: const Icon(Icons.storage_outlined, size: 16),
            label: const Text("Download TMDB Dataset Vector Base", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            onPressed: () => _triggerLocalAssetDownload(context, "backend/database/tmdb_movie_recommender.db"),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            ),
            icon: const Icon(Icons.open_in_new, color: Colors.white, size: 16),
            label: const Text("Open Kaggle Console Panel", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            onPressed: _openKaggleConsoleExternal,
          ),
        ],
      ),
    );
  }
}
