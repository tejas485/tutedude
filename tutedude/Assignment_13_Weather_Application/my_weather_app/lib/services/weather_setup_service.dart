import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class WeatherSetupService {
  Future<bool> requestInitialPermissions() async {
    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return true;
    }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    return statuses[Permission.location] == PermissionStatus.granted;
  }

  Future<bool> isNetworkConnected() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        return true;
      }
      if (kIsWeb) return false;
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isLocationHardwareOn() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<Position?> getCurrentCoordinates() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> launchApiKeyGenerationWebsite() async {
    final Uri url = Uri.parse('https://openweathermap.org');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch OpenWeather setup URL');
    }
  }

  Future<bool> validateApiKey(String apiKey) async {
    final url = Uri.parse('https://openweathermap.org');
    try {
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
