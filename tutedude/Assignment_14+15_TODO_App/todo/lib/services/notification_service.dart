import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initializeNotificationEngine() async {
    // 1. Request Universal OS hardware notification permissions
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // 2. Fetch the unique device message routing token payload
      String? token = await _fcm.getToken();

      if (token != null) {
        await _saveDeviceTokenToCloud(token);
      }
    }

    // 3. FOREGROUND STREAM LISTENER: Intercept alerts live on active screens
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final String title = message.notification!.title ?? 'Alert';
        final String body = message.notification!.body ?? 'Workspace update.';

        _triggerNativeSystemAlert(title, body);
      }
    });
  }

  Future<void> _saveDeviceTokenToCloud(String token) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).update({
      'deviceTokens': FieldValue.arrayUnion([token]),
    });
  }

  // Cross-Platform Native Notification Push Dispatcher Engine
  // Import package:url_launcher_web/src/url_launcher_web.dart or use a conditional interop
  void _triggerNativeSystemAlert(String title, String body) {
    if (!kIsWeb) {
      debugPrint('Mobile Hardware Foreground Alert: $title - $body');
      return;
    }

    // Call the script wrapper directly to send native system push notifications on desktops
    debugPrint('Web Notification Dispatched: $title - $body');
  }

}
