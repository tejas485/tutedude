import 'package:flutter/material.dart';

class PrimaryCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const PrimaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    String cityName = data['name'] ?? 'Unknown';
    String temp = data['main']?['temp']?.toStringAsFixed(1) ?? '--';

    List<dynamic> weatherList = data['weather'] ?? [];
    String condition = 'Clear';
    String iconCode = '01d';

    if (weatherList.isNotEmpty && weatherList.first is Map) {
      final Map<String, dynamic> firstWeatherItem = weatherList.first as Map<String, dynamic>;
      condition = firstWeatherItem['main'] ?? 'Clear';
      iconCode = firstWeatherItem['icon'] ?? '01d';
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(cityName, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            Image.network(
              'https://openweathermap.org',
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.wb_sunny, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text('$temp°C', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 16),
            Text(condition.toUpperCase(), style: const TextStyle(fontSize: 20, letterSpacing: 2, color: Colors.white70, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
