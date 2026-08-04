import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_controller.dart';

class NotificationHistoryScreen extends StatefulWidget {
  const NotificationHistoryScreen({super.key});

  @override
  State<NotificationHistoryScreen> createState() => _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  List<PendingNotificationRequest> _pendingAlerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchActivePendingAlerts();
  }

  Future<void> _fetchActivePendingAlerts() async {
    try {
      final List<PendingNotificationRequest> requests = await _notificationsPlugin.pendingNotificationRequests();
      setState(() {
        _pendingAlerts = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Provider.of<ThemeController>(context);
    final isDark = themeCtrl.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Reminders Logs'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingAlerts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📭', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'No upcoming automated reminders scheduled.',
              style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingAlerts.length,
        itemBuilder: (context, index) {
          final alert = _pendingAlerts[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: themeCtrl.getTintedSurface(context, strength: 0.05),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              boxShadow: themeCtrl.getNeumorphicShadow(context),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: themeCtrl.currentSeedColor,
                child: const Icon(Icons.alarm, color: Colors.white),
              ),
              title: Text(alert.title ?? 'Task Reminder', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(alert.body ?? 'Milestone interval notification update alert.'),
              trailing: Text('ID: ${alert.id}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          );
        },
      ),
    );
  }
}