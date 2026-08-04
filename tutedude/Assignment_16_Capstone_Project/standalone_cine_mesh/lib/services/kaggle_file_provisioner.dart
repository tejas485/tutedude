// lib/services/kaggle_file_provisioner.dart
import 'dart:convert';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'kaggle_storage_service.dart';
import 'kaggle_automation_provisioner.dart';

class KaggleFileProvisioner {
  static Future<Map<String, dynamic>> pickAndProcessKaggleJson({
    required Function(String taskPhase, double fractionalProgress) onProgressUpdate,
  }) async {
    try {
      onProgressUpdate("Awaiting file selector payload choice...", 0.05);

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return {"status": "CANCELLED", "msg": "File choice aborted by user."};
      }

      PlatformFile pickedFile = result.files.first;
      String rawJsonText = "";

      if (kIsWeb) {
        if (pickedFile.bytes != null) {
          rawJsonText = utf8.decode(pickedFile.bytes!);
        }
      } else {
        if (pickedFile.path != null) {
          final File localFile = File(pickedFile.path!);
          rawJsonText = await localFile.readAsString();
        }
      }

      if (rawJsonText.isEmpty) {
        return {"status": "ERROR", "msg": "Validation Blocked: Chosen file contains zero data."};
      }

      final Map<String, dynamic> tokenMap = jsonDecode(rawJsonText);
      final String username = (tokenMap["username"] ?? "").toString().trim();
      final String apiKey = (tokenMap["key"] ?? "").toString().trim();

      if (username.isEmpty || apiKey.isEmpty) { // ◄── FIX APPLIED: REMOVED .apiKey TYPO HERE
        return {"status": "ERROR", "msg": "Parsing Defect: 'username' or 'key' fields are missing inside file."};
      }

      if (!kIsWeb && pickedFile.path != null) {
        final File targetWipeFile = File(pickedFile.path!);
        if (await targetWipeFile.exists()) {
          await targetWipeFile.writeAsString("0000000000000000000000");
          await targetWipeFile.delete();
        }
      }

      await KaggleStorageService.saveCredentials(username, apiKey);

      onProgressUpdate("Decrypting system assets directly within volatile RAM disk variables...", 0.20);

      final provisioningResult = await KaggleAutomationProvisioner.provisionUserCluster(
        username: username,
        apiKey: apiKey,
        onStatusChange: onProgressUpdate,
      );

      return provisioningResult;
    } catch (e) {
      return {"status": "ERROR", "msg": "Unexpected setup execution fault: $e"};
    }
  }
}
