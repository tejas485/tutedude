// lib/services/kaggle_browser_automator.dart
import 'dart:convert';
import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'kaggle_storage_service.dart';

class KaggleBrowserAutomator {
  static const String automationScript = """
    (async function() {
      try {
        let buttons = Array.from(document.querySelectorAll('button, text, a, span'));
        let targetButton = buttons.find(el => 
          el.innerText && (
            el.innerText.includes("Create New Token") || 
            el.innerText.includes("Generate New Token") ||
            el.innerText.includes("Expires any existing legacy keys")
          )
        );
        if (targetButton) {
          targetButton.scrollIntoView({ behavior: 'smooth', block: 'center' });
          setTimeout(() => { targetButton.click(); }, 800);
          return "BUTTON_FOUND_AND_CLICKED";
        }
      } catch (err) { return "ERROR: " + err.toString(); }
      return "SEARCHING_FOR_LEGACY_ELEMENTS";
    })();
  """;

  static void processUrlRoutingEngine(InAppWebViewController controller, String urlString) async {
    final cleanUrl = urlString.toLowerCase();
    if (cleanUrl == "https://kaggle.com" ||
        cleanUrl == "https://kaggle.com/" ||
        (cleanUrl.contains("kaggle.com") && cleanUrl.endsWith("/home"))) {

      // FIXED LINT NOTICE: Swapped out 'print' statement for debugPrint compliance
      debugPrint("🎯 [CINE_MESH LOG] User cleared login. Forcing redirect to Settings...");
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri("https://kaggle.com/settings")),
      );
    }
  }

  static void attachAutomationBridge(InAppWebViewController controller, void Function() onSyncComplete) {
    controller.addJavaScriptHandler(
      handlerName: 'OnKaggleTokenCaptured',
      callback: (args) async {
        if (args.isNotEmpty) {
          try {
            final Map<String, dynamic> tokenData = jsonDecode(args.first.toString());
            final String u = tokenData["username"] ?? "";
            final String k = tokenData["key"] ?? "";
            if (u.isNotEmpty && k.isNotEmpty) {
              await KaggleStorageService.saveCredentials(u, k);
              onSyncComplete();
            }
          } catch (_) {}
        }
      },
    );
  }
}
