import 'package:flutter/material.dart';

class MetricsGrid extends StatelessWidget {
  final Map<String, dynamic> data;
  final int crossAxisCount;

  const MetricsGrid({super.key, required this.data, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    String humidity = data['main']?['humidity']?.toString() ?? '--';
    String windSpeed = data['wind']?['speed']?.toString() ?? '--';
    String pressure = data['main']?['pressure']?.toString() ?? '--';
    String visibility = data['visibility'] != null ? (data['visibility'] / 1000).toStringAsFixed(1) : '--';

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.5,
      children: [
        _buildTile('Air Humidity', '$humidity%', Icons.water_drop, Colors.blue),
        _buildTile('Wind Velocity', '$windSpeed m/s', Icons.air, Colors.teal),
        _buildTile('Barometric Pressure', '$pressure hPa', Icons.compress, Colors.orange),
        _buildTile('Horizontal Visibility', '$visibility km', Icons.visibility, Colors.purple),
      ],
    );
  }

  Widget _buildTile(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
