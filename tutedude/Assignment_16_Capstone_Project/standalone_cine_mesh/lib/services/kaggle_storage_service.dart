// lib/services/kaggle_storage_service.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'crypto_service.dart';
import 'kaggle_automation_provisioner.dart';

class KaggleStorageService {
  static const String _storageUserKey = "enc_secured_kgl_user";
  static const String _storageTokenKey = "enc_secured_kgl_token";
  static const String _localSecureSalt = "CINE_MESH_HARDWARE_SALT_2026";

  static Future<void> saveCredentials(String username, String apiKey) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageUserKey, username);
      await prefs.setString(_storageTokenKey, apiKey);
      return;
    }

    // ─── THE FIXED BLOCK: ENFORCES NON-NULLABLE STRINGS VIA COALESCING OPERATORS ───
    final String encryptedUser = MeshCryptoService.encryptClientPayload(username, _localSecureSalt)["ciphertext"] ?? "";
    final String encryptedToken = MeshCryptoService.encryptClientPayload(apiKey, _localSecureSalt)["ciphertext"] ?? "";

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageUserKey, encryptedUser);
    await prefs.setString(_storageTokenKey, encryptedToken);
  }

  static Future<Map<String, String>> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    final String userRaw = prefs.getString(_storageUserKey) ?? "";
    final String tokenRaw = prefs.getString(_storageTokenKey) ?? "";

    if (userRaw.isEmpty || tokenRaw.isEmpty) {
      return {"username": "", "key": ""};
    }

    if (kIsWeb) {
      return {"username": userRaw, "key": tokenRaw};
    }

    try {
      final String clearUser = MeshCryptoService.decryptServerPayload(userRaw, "0000000000000000000000==", _localSecureSalt);
      final String clearToken = MeshCryptoService.decryptServerPayload(tokenRaw, "0000000000000000000000==", _localSecureSalt);
      return {"username": clearUser, "key": clearToken};
    } catch (_) {
      return {"username": "", "key": ""};
    }
  }

  static Future<void> attemptHeadlessClusterAutoResumption() async {
    if (kIsWeb) return;

    final credentials = await getCredentials();
    final String user = credentials["username"] ?? "";
    final String token = credentials["key"] ?? "";

    if (user.isNotEmpty && token.isNotEmpty) {
      await KaggleAutomationProvisioner.provisionUserCluster(
        username: user,
        apiKey: token,
        onStatusChange: (String currentPhase, double progressTrackValue) {
          // Headless worker loop background update channel
        },
      );
    }
  }

  static Future<void> shredLocalCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageUserKey);
    await prefs.remove(_storageTokenKey);
  }
}
