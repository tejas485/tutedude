// lib/dashboard/components/dashboard_sheet_triggers.dart
import 'package:standalone_cine_mesh/dashboard/dashboard_imports.dart';

class DashboardSheetTriggers {
  static void openWatchLater(BuildContext context, Color accent, List<Map<String, dynamic>> watchLaterData, VoidCallback onUpdate) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final messenger = ScaffoldMessenger.of(context);
        return WatchLaterDrawerOverlay(
          watchLaterData: watchLaterData, accentColor: accent,
          onRemoveMovie: (m) => CinemaUiDialogs.showActionConfirmation(
              context: context, title: "Remove Watch Later", message: "Delete this movie item from local view cache?", confirmLabel: "Remove",
              onConfirm: () { watchLaterData.remove(m); onUpdate(); }
          ),
          onTriggerReminder: (m) async {
            Navigator.pop(ctx);
            bool s = await MeshNetworkService.dispatchWatchLaterFcmSignal(m["title"].toString(), FirebaseAuth.instance.currentUser?.uid ?? "");
            messenger.showSnackBar(SnackBar(backgroundColor: s ? CinemaMeshTheme.emeraldGreen : CinemaMeshTheme.errorCrimson, content: Text(s ? "Refreshed Watch Later Push!" : "FCM target sync failure.")));
          },
        );
      },
    );
  }

  static void openHistory({
    required BuildContext context,
    required Color accent,
    required TextEditingController input,
    required List<Map<String, dynamic>> logData,
    required List<Map<String, dynamic>> chatHistory,
    required List<Map<String, dynamic>> localWatchLater,
    required String uid,
    required VoidCallback onClear,
    required VoidCallback onUpdate,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => HistoryDrawerOverlay(
        rawHistoryObjects: logData, accentColor: accent, inputController: input,
        // ─── FIXED PASSTHROUGH HANDLER: MAKES ALL ACTIONS INSIDE RECOMMENDED LIST DRAWER RESPONSIVE EXECUTIONS ───
        onMovieAction: (k, id, v) => DashboardActionsHandler.routeMovieInteraction(
          context: context,
          key: k,
          id: id,
          dataValue: v,
          chatHistory: chatHistory,
          localWatchLater: localWatchLater,
          userUid: uid,
          onUpdate: onUpdate,
        ),
        onClearAllHistory: () => CinemaUiDialogs.showActionConfirmation(context: context, title: "Wipe Cloud Logs", message: "This will permanently drop your historical recommendation analytics from Firestore. Proceed?", confirmLabel: "Purge", onConfirm: onClear),
      ),
    );
  }

  static void openFavorites(BuildContext context, Color accent, List<Map<String, dynamic>> favoritesData, String uid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => FavoritesDrawerOverlay(favoritesData: favoritesData, accentColor: accent, userUid: uid),
    );
  }
}
