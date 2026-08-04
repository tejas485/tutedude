import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as mobile_cal;
import '../models/todo_model.dart';
import '../encryption/crypto_service.dart';

class LocalCalendarService {
  static Future<void> exportToDeviceCalendar(TodoModel todo) async {
    final DateTime start = todo.startTime ?? DateTime.now();
    final DateTime end = todo.endTime ?? start.add(const Duration(hours: 1));

    final String decryptedTitle = CryptoService.decrypt(todo.title);
    final String decryptedLocation = CryptoService.decrypt(todo.location ?? 'Workspace Space');
    final String decryptedCreator = CryptoService.decrypt(todo.createdByName);

    // --- STRATEGY BRANCH A: FLUTTER WEB ENVIRONMENT ---
    if (kIsWeb) {
      final String startTimeStr = '${start.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';
      final String endTimeStr = '${end.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';

      final String icsContent =
          'BEGIN:VCALENDAR\n'
          'VERSION:2.0\n'
          'PRODID:-//Secure Todo Workspace//EN\n'
          'BEGIN:VEVENT\n'
          'SUMMARY:$decryptedTitle\n'
          'DTSTART:$startTimeStr\n'
          'DTEND:$endTimeStr\n'
          'LOCATION:$decryptedLocation\n'
          'DESCRIPTION:Task managed via Secure Cloud Todo. Assigned By: $decryptedCreator\n'
          'END:VEVENT\n'
          'END:VCALENDAR';

      final String encodedContent = Uri.encodeComponent(icsContent);
      final String downloadDataUri = 'data:text/calendar;charset=utf-8,$encodedContent';
      final Uri parsedUri = Uri.parse(downloadDataUri);

      if (await canLaunchUrl(parsedUri)) {
        await launchUrl(parsedUri, mode: LaunchMode.externalApplication);
      }
      return;
    }

    // --- STRATEGY BRANCH B: NATIVE MOBILE ENVIRONMENTS (ANDROID & iOS) ---
    final mobile_cal.Event event = mobile_cal.Event(
      title: decryptedTitle,
      description: 'Task assignment managed via Secure Cloud Architecture. Assigned By: $decryptedCreator',
      location: decryptedLocation.isEmpty ? 'Workspace Group Digital Desk' : decryptedLocation,
      startDate: start,
      endDate: end,
      allDay: false,
    );

    await mobile_cal.Add2Calendar.addEvent2Cal(event);
  }
}
