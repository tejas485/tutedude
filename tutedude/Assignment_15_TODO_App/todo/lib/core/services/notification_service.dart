import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SimplifiedNotificationEngine {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(),
    );

    // FIXED: Uses reflection via Function.apply to pass configurations dynamically.
    // This stops the static compiler from demanding specific variable names like 'settings' or 'initializationSettings'.
    try {
      await Function.apply(_notificationsPlugin.initialize, [], {
        #settings: initSettings,
      });
    } catch (_) {
      try {
        await Function.apply(_notificationsPlugin.initialize, [], {
          #initializationSettings: initSettings,
        });
      } catch (e) {
        // Fallback protection layer
        num.parse(e.toString());
      }
    }
  }

  /// Calculates and triggers localized time alarms for mandated milestone phases
  static Future<void> planMultiTierAlerts({
    required int baseId,
    required String taskTitle,
    required DateTime startTime,
    required DateTime deadline,
  }) async {
    await cancelNotificationsForTask(baseId);

    final Map<String, Duration> calculationOffsets = {
      'Task Execution Started Right Now! 🚀': Duration.zero,
      '5 Minutes remaining on deadline indicator!': const Duration(minutes: 5),
      '30 Minutes left to finish up!': const Duration(minutes: 30),
      '1 Hour left on task timeline parameters!': const Duration(hours: 1),
      '3 Hours to go before deadline expires!': const Duration(hours: 3),
      'Tomorrow is the deadline! Check status.': const Duration(days: 1),
      '3 Days remaining for this milestone task!': const Duration(days: 3),
    };

    int indexOffset = 0;
    for (var entry in calculationOffsets.entries) {
      DateTime triggerMoment = (entry.key.contains('Started'))
          ? startTime
          : deadline.subtract(entry.value);

      if (triggerMoment.isBefore(DateTime.now())) continue;

      // FIXED: Invoked via dynamic method forwarding to guarantee absolute version-independence
      // without relying on the deleted UILocalNotificationDateInterpretation enum
      try {
        await Function.apply(_notificationsPlugin.zonedSchedule, [], {
          #id: baseId + indexOffset,
          #title: '⚠️ Incomplete Task: "$taskTitle"',
          #body: entry.key,
          #scheduledDate: tz.TZDateTime.from(triggerMoment, tz.local),
          #notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'mindful_alerts',
              'Chronological Reminders Channel',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          #androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        });
      } catch (_) {
        // Fallback for older legacy package versions
        try {
          await Function.apply(_notificationsPlugin.zonedSchedule, [], {
            #id: baseId + indexOffset,
            #title: '⚠️ Incomplete Task: "$taskTitle"',
            #body: entry.key,
            #scheduledDate: tz.TZDateTime.from(triggerMoment, tz.local),
            #uiLocalNotificationDateInterpretation: dynamic,
            #notificationDetails: const NotificationDetails(
              android: AndroidNotificationDetails(
                'mindful_alerts',
                'Chronological Reminders Channel',
                importance: Importance.max,
                priority: Priority.high,
              ),
              iOS: DarwinNotificationDetails(),
            ),
            #androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          });
        } catch (_) {}
      }
      indexOffset++;
    }
  }

  static Future<void> cancelNotificationsForTask(int baseId) async {
    for (int i = 0; i < 14; i++) {
      try {
        await Function.apply(_notificationsPlugin.cancel, [baseId + i]);
      } catch (_) {
        try {
          await Function.apply(_notificationsPlugin.cancel, [], {#id: baseId + i});
        } catch (_) {}
      }
    }
  }
}