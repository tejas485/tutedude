// lib/screens/components/session/download_helper_web.dart
import 'package:web/web.dart' as web;

void executeWebAssetDownload(String assetSubPath) {
  final String webAssetUrl = "assets/$assetSubPath";
  final String filename = assetSubPath.split('/').last;

  // Build modern browser DOM anchors compatible across modern multi-compilers
  final web.HTMLAnchorElement virtualDownloadAnchor = web.document.createElement('a') as web.HTMLAnchorElement;
  virtualDownloadAnchor.href = webAssetUrl;
  virtualDownloadAnchor.setAttribute("download", filename);
  virtualDownloadAnchor.style.display = 'none';

  // Safely latch and fire virtual elements onto the active web browser frame
  web.document.body?.appendChild(virtualDownloadAnchor);
  virtualDownloadAnchor.click();
  virtualDownloadAnchor.remove();
}
