// lib/services/network_service.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'crypto_service.dart';

class MeshNetworkService {
  static const String _storageKey = "cached_cine_mesh_tunnel_url";
  static Timer? _keepAliveTimer;

  static String kaggleUrl = const String.fromEnvironment(
    'CINE_MESH_KAGGLE_URL',
    defaultValue: "https://loca.lt",
  );

  static const String clientID = "client_node_tejas_01";
  static const String token = "CINE_MESH_R7Q/7925MN";
  static const String aesKey = "CINE_MESH_SECURE_PHRASE_2026";

  static Future<void> loadSavedTunnelAddress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedUrl = prefs.getString(_storageKey);
      if (savedUrl != null && savedUrl.isNotEmpty) {
        kaggleUrl = savedUrl;
        startTunnelKeepAliveLoop();
      }
    } catch (_) {}
  }

  static Future<void> updateLocalTunnelUrl(String newUrl) async {
    String cleanedUrl = newUrl.trim();
    if (cleanedUrl.toLowerCase().contains("your url is:")) {
      cleanedUrl = cleanedUrl.substring(cleanedUrl.toLowerCase().indexOf("http"));
    }
    cleanedUrl = cleanedUrl.trim();
    while (cleanedUrl.endsWith('/') || cleanedUrl.endsWith('\\')) {
      cleanedUrl = cleanedUrl.substring(0, cleanedUrl.length - 1);
    }
    kaggleUrl = cleanedUrl;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, kaggleUrl);
      startTunnelKeepAliveLoop();
    } catch (_) {}
  }

  static void startTunnelKeepAliveLoop() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(const Duration(seconds: 35), (timer) async {
      try {
        final targetUri = Uri.parse("$kaggleUrl/api/v3/mesh-chat");
        await http.get(
          targetUri,
          headers: {
            "X-Client-ID": clientID,
            "X-Access-Token": token,
            "Bypass-Tunnel-Reminder": "true",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
          },
        ).timeout(const Duration(seconds: 6));
      } catch (_) {}
    });
  }

  static void stopTunnelKeepAliveLoop() {
    _keepAliveTimer?.cancel();
  }

  // lib/services/network_service.dart (Replace this function block inside your file)
  static Future<bool> verifyTunnelLiveness() async {
    try {
      final targetUri = Uri.parse("$kaggleUrl/api/v3/mesh-chat");

      final response = await http.get(
        targetUri,
        headers: {
          "X-Client-ID": clientID,
          "X-Access-Token": token,
          // ─── THE BYPASS MATRIX: SHUTS DOWN THE INTERSTITIAL PASSWORD LANDING PAGE ───
          "Bypass-Tunnel-Reminder": "true",
          // ─── THE PROTOCOL FIX: MASQUERADES TRAFFIC SECURELY AS A CLASSIC DESKTOP BROWSER ───
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        },
      ).timeout(const Duration(seconds: 12));

      // Any structural response confirmation code from your FastAPI core engine means the pipeline is unblocked
      if (response.statusCode == 200 || response.statusCode == 401 || response.statusCode == 403) {
        return true;
      }
    } catch (e) {
      debugPrint("⚠️ Live validation handshake intercepted dropout: $e");
    }
    return false;
  }


  static Future<Map<String, dynamic>?> dispatchSecurePayload(String textQuery, String userUid) async {
    try {
      final Map<String, dynamic> rawMap = {"user_query": textQuery, "user_uid": userUid};
      final plainJson = jsonEncode(rawMap);
      final encryptedPacket = MeshCryptoService.encryptClientPayload(plainJson, aesKey);
      final targetUri = Uri.parse("$kaggleUrl/api/v3/mesh-chat");

      final User? currentUser = FirebaseAuth.instance.currentUser;
      String? firebaseIdToken;
      try {
        firebaseIdToken = await currentUser?.getIdToken(true);
      } catch (_) {}

      final response = await http.post(
        targetUri,
        headers: {
          "X-Client-ID": clientID,
          "X-Access-Token": token,
          "X-Firebase-User-Token": firebaseIdToken ?? "",
          "X-Scope-Permission": "plot",
          "Bypass-Tunnel-Reminder": "true",
          "Content-Type": "application/json",
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        },
        body: jsonEncode(encryptedPacket),
      ).timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'] ?? '';
        final bodyText = response.body.trim();

        if (contentType.contains('text/html')) {
          return {
            "ai_response": "The proxy node returned an identity verification block. Please resubmit your message.",
            "movies": <Map<String, dynamic>>[]
          };
        }

        try {
          final jsonEnvelope = jsonDecode(bodyText);
          if (jsonEnvelope is Map && jsonEnvelope.containsKey("ciphertext") && jsonEnvelope.containsKey("iv")) {
            final clearText = MeshCryptoService.decryptServerPayload(
              jsonEnvelope["ciphertext"].toString(),
              jsonEnvelope["iv"].toString(),
              aesKey,
            );
            final dynamic parsedData = jsonDecode(clearText);
            if (parsedData is Map<String, dynamic>) {
              return parsedData;
            }
          }
        } catch (_) {
          return {
            "ai_response": "The response text stream was interrupted by proxy server anomalies. Please retry.",
            "movies": <Map<String, dynamic>>[]
          };
        }
      }
    } catch (e) {
      debugPrint("❌ Transaction pipeline failure: $e");
    }
    return null;
  }

  /// 📳 NEW INTERACTIVE HEADLESS NOTIFICATION FORWARDER
  /// Encrypts and passes system notification replies back upstream.
  static Future<void> dispatchTrayResponsePayload(String userText, String uid) async {
    try {
      final Map<String, dynamic> rawMap = {"user_query": userText, "user_uid": uid};
      final String plainJson = jsonEncode(rawMap);

      final encryptedPacket = MeshCryptoService.encryptClientPayload(plainJson, aesKey);
      final targetUri = Uri.parse("$kaggleUrl/api/v3/interactive-tray-reply");

      await http.post(
        targetUri,
        headers: {
          "X-Client-ID": clientID,
          "X-Access-Token": token,
          "Bypass-Tunnel-Reminder": "true",
          "Content-Type": "application/json",
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        },
        body: jsonEncode(encryptedPacket),
      ).timeout(const Duration(seconds: 40));
    } catch (e) {
      debugPrint("⚠️ Background tray response route execution dropped: $e");
    }
  }

  static Future<bool> dispatchWatchLaterFcmSignal(String movieTitle, String userUid) async {
    try {
      final targetUri = Uri.parse("$kaggleUrl/api/v3/watch-later-notify");
      final response = await http.post(
        targetUri,
        headers: {
          "X-Client-ID": clientID,
          "X-Access-Token": token,
          "Bypass-Tunnel-Reminder": "true",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"user_uid": userUid, "movie_title": movieTitle}),
      ).timeout(const Duration(seconds: 12));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static int min(int a, int b) => math.min(a, b);
}
