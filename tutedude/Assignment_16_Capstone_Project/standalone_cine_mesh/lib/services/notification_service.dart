// lib/services/notification_service.dart
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'network_service.dart'; // ◄── INJECTED FOR DISPATCHING REPLIES

class CinemaNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static const String channelId = "cinemesh_interactive_channel";

  static Future<void> initializeUnifiedNotificationPipeline(
      String userUid, Function(String typedReply) onDirectNotificationReply) async {
    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return;
    }

    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    String? fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      await FirebaseFirestore.instance.collection('cinema_users').doc(userUid).set({
        'fcm_device_token': fcmToken,
        'last_token_sync': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    }

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // ─── HOOK ACTIVE INPUT EVENT: INTERCEPTS TEXT TYPED IN LOCK SCREEN TRAY ───
        if (response.actionId == "action_reply" && response.input != null && response.input!.isNotEmpty) {
          final String typedText = response.input!;

          // Execute immediate standalone async server routing handoff in background
          onDirectNotificationReply(typedText);
          await MeshNetworkService.dispatchTrayResponsePayload(typedText, userUid);
        }
      },
    );
  }

  static Future<void> displayLocalRetentionPing() async {
    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return;
    }

    final AndroidNotificationAction replyAction = AndroidNotificationAction(
      'action_reply',
      'Reply from Tray',
      contextual: true,
      showsUserInterface: false, // ◄── CRITICAL: Runs headlessly without opening the app window
      inputs: [
        const AndroidNotificationActionInput(
          choices: [],
          allowFreeFormInput: true, // ◄── CRITICAL: Unlocks free-form typing layout container
          label: 'Type message to CineMesh...',
        )
      ],
    );

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      'Interactive Chat Channels',
      channelDescription: 'Handles background conversations on local level',
      importance: Importance.max,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[replyAction],
    );

    await _localNotifications.show(
      id: 999,
      title: "🍿 CineMesh Concierge Lounge",
      body: "Are you still in the conversation, or should we talk later?",
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }
}
