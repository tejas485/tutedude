// lib/dashboard/dashboard_telemetry.dart
import 'dart:async';
import 'dashboard_imports.dart';

mixin DashboardTelemetryMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _telemetrySubscription;

  /// Attaches real-time listeners straight to user accounts in Firestore
  void initializeTelemetryPipeline({
    required String userUid,
    required List<Map<String, dynamic>> rawHistoryLogs,
    required List<Map<String, dynamic>> localSavedFavorites,
    required VoidCallback onSyncComplete,
  }) {
    _telemetrySubscription = FirebaseFirestore.instance
        .collection('cinema_users')
        .doc(userUid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;

        if (data['search_history'] != null) {
          rawHistoryLogs.clear();
          for (var item in data['search_history']) {
            rawHistoryLogs.add(Map<String, dynamic>.from(item));
          }
        }
        if (data['bookmarks'] != null) {
          localSavedFavorites.clear();
          for (var item in data['bookmarks']) {
            localSavedFavorites.add(Map<String, dynamic>.from(item));
          }
        }
        onSyncComplete();
      }
    });
  }

  /// Force-kills long-running telemetry hooks to prevent memory cycle drift leak hazards
  void terminateTelemetryPipeline() {
    _telemetrySubscription?.cancel();
  }
}
