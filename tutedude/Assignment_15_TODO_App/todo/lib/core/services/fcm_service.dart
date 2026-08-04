import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Configures push capabilities for server broadcast tokens across Web & Native
  static Future<void> init() async {
    // FIXED: Removed any reference to 'dart:html' to achieve 100% native mobile compilation safety
    try {
      // Request notification clearance privileges from the active user profile
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kIsWeb) {
          try {
            // Replace with your real VAPID Key string derived from Firebase Cloud Messaging pane
            String? token = await _messaging.getToken(vapidKey: "YOUR_PUBLIC_VAPID_KEY_HERE");
            debugPrint("FCM Web Delivery Registration Token: $token");
          } catch (webError) {
            debugPrint("FCM Web Token retrieval skipped: ${webError.toString()}");
          }
        } else {
          String? token = await _messaging.getToken();
          debugPrint("FCM Native Mobile Token: $token");
        }
      }

      // Handles active foreground data messaging pipelines seamlessly
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint("Foreground message stream captured: ${message.notification?.title}");
      });
    } catch (e) {
      debugPrint("FCM Initialization gracefully handled fallback: ${e.toString()}");
    }
  }
}
