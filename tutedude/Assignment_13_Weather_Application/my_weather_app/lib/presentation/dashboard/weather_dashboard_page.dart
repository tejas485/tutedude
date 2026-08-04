import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../../services/weather_setup_service.dart';
import 'widgets/primary_card.dart';
import 'widgets/metrics_grid.dart';
import 'widgets/search_bar.dart';

class WeatherDashboardPage extends StatefulWidget {
  final String apiKey;
  const WeatherDashboardPage({super.key, required this.apiKey});

  @override
  State<WeatherDashboardPage> createState() => _WeatherDashboardPageState();
}

class _WeatherDashboardPageState extends State<WeatherDashboardPage> {
  final WeatherSetupService _setupService = WeatherSetupService();
  final TextEditingController _cityController = TextEditingController();

  bool _isLoading = false;
  Map<String, dynamic>? _weatherData;
  String _infoMessage = '';
  bool _isLocationFeatureAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadInitialLocalWeather();
  }

  Future<void> _loadInitialLocalWeather() async {
    setState(() {
      _isLoading = true;
      _infoMessage = 'Locating your current device...';
    });

    bool hardwareOn = await _setupService.isLocationHardwareOn();
    if (!hardwareOn) {
      setState(() {
        _isLoading = false;
        _isLocationFeatureAvailable = false;
        _infoMessage = "Location service is off. Turn on GPS settings to view local weather automatically.";
      });
      return;
    }

    Position? pos = await _setupService.getCurrentCoordinates();
    if (pos == null) {
      setState(() {
        _isLoading = false;
        _isLocationFeatureAvailable = false;
        _infoMessage = "Location access was not granted. Use the search bar above to look up conditions manually.";
      });
      return;
    }

    final Map<String, String> queryParameters = {
      'lat': pos.latitude.toString(),
      'lon': pos.longitude.toString(),
      'units': 'metric',
      'appid': widget.apiKey,
    };
    await _executeWeatherRequest(Uri.https('api.openweathermap.org', '/data/2.5/weather', queryParameters));
  }

  Future<void> _searchCityWeather(String cityName) async {
    if (cityName.isEmpty) return;
    setState(() {
      _isLoading = true;
      _infoMessage = 'Searching details for $cityName...';
    });

    final Map<String, String> queryParameters = {
      'q': cityName,
      'units': 'metric',
      'appid': widget.apiKey,
    };
    await _executeWeatherRequest(Uri.https('api.openweathermap.org', '/data/2.5/weather', queryParameters));
  }

  Future<void> _executeWeatherRequest(Uri url) async {
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        setState(() {
          _weatherData = jsonDecode(response.body);
          _infoMessage = '';
          _isLocationFeatureAvailable = true;
        });
      } else {
        setState(() {
          _weatherData = null;
          _infoMessage = 'We couldn\'t find that city. Please verify your spelling and try again.';
        });
      }
    } catch (e) {
      setState(() {
        _weatherData = null;
        _infoMessage = 'Connection failed. Please check your data signal and try again.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWide = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Weather Monitor'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: "Use Current Location",
            onPressed: _loadInitialLocalWeather,
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CustomSearchBar(
                  controller: _cityController,
                  onSearch: () => _searchCityWeather(_cityController.text.trim()),
                  wideLayout: isWide,
                ),
                const SizedBox(height: 24),

                if (_infoMessage.isNotEmpty && !_isLoading)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: _isLocationFeatureAvailable ? Colors.blue.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _isLocationFeatureAvailable ? Colors.blue.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3)),
                    ),
                    child: Text(_infoMessage, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                  ),

                if (_isLoading) const Expanded(child: Center(child: CircularProgressIndicator())),

                if (_weatherData != null && !_isLoading)
                  Expanded(
                    child: isWide
                        ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: PrimaryCard(data: _weatherData!)),
                        const SizedBox(width: 24),
                        Expanded(flex: 3, child: MetricsGrid(data: _weatherData!, crossAxisCount: 2)),
                      ],
                    )
                        : ListView(
                      children: [
                        PrimaryCard(data: _weatherData!),
                        const SizedBox(height: 24),
                        MetricsGrid(data: _weatherData!, crossAxisCount: screenWidth > 500 ? 2 : 1),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
