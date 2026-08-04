// lib/screens/components/session/web_assistant_card.dart
import 'package:flutter/material.dart';
import '../../../config/theme_config.dart';

class WebAssistantCard extends StatefulWidget {
  final String localTunnelUrl;
  final Function(String verifiedUrl) onSyncComplete;

  const WebAssistantCard({
    super.key,
    required this.localTunnelUrl,
    required this.onSyncComplete,
  });

  @override
  State<WebAssistantCard> createState() => _WebAssistantCardState();
}

class _WebAssistantCardState extends State<WebAssistantCard> {
  final _formKey = GlobalKey<FormState>();
  final _tunnelInputController = TextEditingController();
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _tunnelInputController.text = widget.localTunnelUrl;
  }

  @override
  void dispose() {
    _tunnelInputController.dispose();
    super.dispose();
  }

  void _processTunnelParsingHandshake() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isConnecting = true);
    String inputLink = _tunnelInputController.text.trim();

    if (inputLink.toLowerCase().contains("your url is:")) {
      final int httpIndex = inputLink.toLowerCase().indexOf("http");
      if (httpIndex != -1) {
        inputLink = inputLink.substring(httpIndex);
      }
    }
    inputLink = inputLink.trim();

    while (inputLink.endsWith('/') || inputLink.endsWith('\\')) {
      inputLink = inputLink.substring(0, inputLink.length - 1);
    }

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isConnecting = false);
      widget.onSyncComplete(inputLink);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── REMOVED THE DUPLICATE ACCIDENTAL WORKSPACE ACTION CARD ENTIRELY FROM HERE ───
            const Text(
              "Localtunnel Ingestion Block",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tunnelInputController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13),
              decoration: InputDecoration(
                hintText: "Paste your live https://loca.lt url...",
                filled: true,
                fillColor: isDark ? Colors.black12 : Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) return "Please paste your active proxy tunnel URL string.";
                if (!val.contains("http://") && !val.contains("https://")) return "Invalid format. URL must start with http/https.";
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CinemaMeshTheme.emeraldGreen,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _isConnecting ? null : _processTunnelParsingHandshake,
              child: _isConnecting
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Text(
                "Establish Active Recommender Handshake",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
