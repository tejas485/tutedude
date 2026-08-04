// lib/dashboard/dashboard_screen.dart
import 'dashboard_imports.dart';
import 'dashboard_telemetry.dart';
import 'package:standalone_cine_mesh/dashboard/components/dashboard_app_bar.dart';
import 'package:standalone_cine_mesh/dashboard/components/dashboard_sheet_triggers.dart';

class CinemaOrchestrationDashboard extends StatefulWidget {
  final User user;
  const CinemaOrchestrationDashboard({super.key, required this.user});

  @override
  State<CinemaOrchestrationDashboard> createState() => _CinemaOrchestrationDashboardState();
}

class _CinemaOrchestrationDashboardState extends State<CinemaOrchestrationDashboard> with DashboardTelemetryMixin {
  final List<Map<String, dynamic>> _chatHistory = [];
  final _input = TextEditingController();
  bool _networkPending = false;
  double _ratingThreshold = 0.0;

  final List<Map<String, dynamic>> _rawHistoryLogs = [];
  final List<Map<String, dynamic>> _localSavedFavorites = [];
  final List<Map<String, dynamic>> _localWatchLater = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    initializeTelemetryPipeline(
      userUid: widget.user.uid,
      rawHistoryLogs: _rawHistoryLogs,
      localSavedFavorites: _localSavedFavorites,
      onSyncComplete: () => setState(() {}),
    );

    CinemaNotificationService.initializeUnifiedNotificationPipeline(
      widget.user.uid,
          (String trayInputReplyText) {
        if (mounted && trayInputReplyText.isNotEmpty) {
          setState(() {
            _input.text = trayInputReplyText;
            _dispatchSecureChatMessage();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    terminateTelemetryPipeline();
    _input.dispose();
    super.dispose();
  }

  void _displayTunnelFailureModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.portable_wifi_off_rounded, color: CinemaMeshTheme.errorCrimson, size: 24),
            SizedBox(width: 8),
            Text("Kaggle Tunnel Dropped", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
            "The proxy link became unreachable or timed out while processing your GPU token shapes.\n\n"
                "1. Verify Kaggle cell is still running.\n"
                "2. Ensure the URL matches your input.\n"
                "3. Try sending your message again.",
            style: TextStyle(fontSize: 13, color: CinemaMeshTheme.mutedSubtleGrey)
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                DashboardActionsHandler.pasteAndApplyKaggleTunnel(context, () => setState(() {}));
              },
              child: const Text("Paste New Link")
          ),
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Dismiss", style: TextStyle(color: Colors.grey))
          )
        ],
      ),
    );
  }

  void _executeCloudHistoryPurge() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await FirebaseFirestore.instance.collection('cinema_users').doc(widget.user.uid).update({'search_history': FieldValue.delete()});
      setState(() => _rawHistoryLogs.clear());
      messenger.showSnackBar(const SnackBar(backgroundColor: CinemaMeshTheme.errorCrimson, content: Text("Cloud search log records purged.")));
    } catch (e) {
      messenger.showSnackBar(SnackBar(backgroundColor: CinemaMeshTheme.errorCrimson, content: Text("Purge failed: $e")));
    }
  }

  void _dispatchSecureChatMessage() async {
    final txt = _input.text.trim();
    if (txt.isEmpty) return;
    _input.clear();

    setState(() => _networkPending = true);

    final Map<String, dynamic> userLogNode = {
      "sender": "user",
      "query": txt,
      "timestamp": DateTime.now().toIso8601String()
    };

    setState(() {
      _chatHistory.add({"role": "user", "msg": txt, "movies": <Map<String, dynamic>>[]});
      _rawHistoryLogs.add(userLogNode);
    });

    try {
      await FirebaseFirestore.instance.collection('cinema_users').doc(widget.user.uid).set({
        'search_history': FieldValue.arrayUnion([userLogNode])
      }, SetOptions(merge: true));
    } catch (_) {}

    final payload = await MeshNetworkService.dispatchSecurePayload(txt, widget.user.uid);

    if (!mounted) return;

    if (payload != null) {
      List<Map<String, dynamic>> attached = payload["movies"] != null
          ? List<Map<String, dynamic>>.from(payload["movies"])
          : [];

      if (_ratingThreshold > 0.0) {
        attached = attached.where((m) => ((m["vote_average"] is num)
            ? (m["vote_average"] as num).toDouble()
            : 0.0) >= _ratingThreshold).toList();
      }

      final Map<String, dynamic> aiLogNode = {
        "sender": "cinemesh_ai",
        "query": payload["ai_response"],
        "timestamp": DateTime.now().toIso8601String(),
        "attached_movies_json": jsonEncode(attached)
      };

      setState(() {
        _chatHistory.add({"role": "gemini", "msg": payload["ai_response"], "movies": attached});
        _rawHistoryLogs.add(aiLogNode);
        _networkPending = false;
      });

      try {
        await FirebaseFirestore.instance.collection('cinema_users').doc(widget.user.uid).set({
          'search_history': FieldValue.arrayUnion([aiLogNode])
        }, SetOptions(merge: true));
      } catch (_) {}
    } else {
      setState(() => _networkPending = false);
      _displayTunnelFailureModal();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<Color>(
      valueListenable: accentColorNotifier,
      builder: (context, currentAccent, _) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: DashboardAppBar(currentAccent: currentAccent, isDark: isDark, onStateRefresh: () => setState(() {})),
          endDrawer: ThemeConfigurationDrawer(currentAccent: currentAccent, isDark: isDark, onAccentColorChanged: (c) => accentColorNotifier.value = c),
          body: MeshChatPanel(
            chatHistory: _chatHistory,
            inputController: _input,
            pending: _networkPending,
            currentAccent: currentAccent,
            onSend: _dispatchSecureChatMessage,
            onRatingThresholdChanged: (val) => setState(() => _ratingThreshold = val),
            onViewWatchLater: () => DashboardSheetTriggers.openWatchLater(context, currentAccent, _localWatchLater, () => setState(() {})),
            onViewHistory: () => DashboardSheetTriggers.openHistory(
              context: context,
              accent: currentAccent,
              input: _input,
              logData: _rawHistoryLogs,
              chatHistory: _chatHistory,
              localWatchLater: _localWatchLater,
              uid: widget.user.uid,
              onClear: _executeCloudHistoryPurge,
              onUpdate: () => setState(() {}),
            ),
            onViewFavorites: () => DashboardSheetTriggers.openFavorites(context, currentAccent, _localSavedFavorites, widget.user.uid),
            onMovieAction: (key, id, val) => DashboardActionsHandler.routeMovieInteraction(
              context: context,
              key: key,
              id: id,
              dataValue: val,
              chatHistory: _chatHistory,
              localWatchLater: _localWatchLater,
              userUid: widget.user.uid,
              onUpdate: () => setState(() {}),
            ),
          ),
        );
      },
    );
  }
}
