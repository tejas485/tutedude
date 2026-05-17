// lib/screens/energy_analysis_page.dart

import 'package:flutter/material.dart';

class EnergyAnalysisPage extends StatelessWidget {
  const EnergyAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> usageData = [
      {'device': 'Living Climate AC', 'usage': '4.8 kW/h', 'percentage': 0.65, 'color': Colors.blue},
      {'device': 'Driveway Camera Arrays', 'usage': '1.2 kW/h', 'percentage': 0.20, 'color': Colors.purple},
      {'device': 'Ecosystem Lighting', 'usage': '0.9 kW/h', 'percentage': 0.15, 'color': Colors.amber},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text('Analytical Matrix Matrix Logs', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Fake Rendered Mock Line Grid Chart Node
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Daily Allocation Cycle Graph', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (index) {
                      final heights = [60.0, 90.0, 140.0, 110.0, 75.0, 130.0, 105.0];
                      return Column(
                        children: [
                          Container(
                            width: 24,
                            height: heights[index],
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(['M', 'T', 'W', 'T', 'F', 'S', 'S'][index]),
                        ],
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text('Hardware Allocation Breakdowns', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // Generate isolated rows with strict width layout boundaries to avoid overflows
          ...usageData.map((data) => Card(
            child: ListTile(
              leading: Icon(Icons.pie_chart, color: data['color'] as Color),
              title: Text(data['device'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: LinearProgressIndicator(
                value: data['percentage'] as double,
                color: data['color'] as Color,
                backgroundColor: Colors.grey.shade200,
              ),
              trailing: Text(data['usage'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          )),
        ],
      ),
    );
  }
}
