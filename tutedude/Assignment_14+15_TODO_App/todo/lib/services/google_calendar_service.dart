import 'package:url_launcher/url_launcher.dart';
import '../models/todo_model.dart';
import '../encryption/crypto_service.dart';

class GoogleCalendarService {
  static Future<void> launchGoogleCalendarWebIntent(TodoModel todo) async {
    final String decryptedTitle = CryptoService.decrypt(todo.title);
    final String decryptedLocation = CryptoService.decrypt(todo.location ?? '');
    final String decryptedCreator = CryptoService.decrypt(todo.createdByName);

    final DateTime start = todo.startTime ?? DateTime.now();
    final DateTime end = todo.endTime ?? start.add(const Duration(hours: 1));

    final String startTimeStr = '${start.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';
    final String endTimeStr = '${end.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';

    final String titleEncoded = Uri.encodeComponent(decryptedTitle);
    final String detailsEncoded = Uri.encodeComponent('Workspace Allocation. Assigned By: $decryptedCreator. Managed via Secure Cloud TODO UI.');
    final String locationEncoded = Uri.encodeComponent(decryptedLocation.isEmpty ? 'Workspace Digital Hub' : decryptedLocation);

    // FIXED: Removed extra forward slashes to ensure native Android intents map perfectly
    final String googleCalendarUrl =
        'https://google.com'
        '&text=$titleEncoded'
        '&dates=$startTimeStr/$endTimeStr'
        '&details=$detailsEncoded'
        '&location=$locationEncoded';

    final Uri parsedUri = Uri.parse(googleCalendarUrl);

    // Fallback Execution: Launches external application or system web browser tab instantly
    if (await canLaunchUrl(parsedUri)) {
      await launchUrl(parsedUri, mode: LaunchMode.externalApplication);
    } else {
      // Direct Web Launcher Fallback to prevent hard app drops if intent rules match tightly
      await launchUrl(parsedUri, mode: LaunchMode.platformDefault);
    }
  }
}
