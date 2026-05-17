// lib/screens/settings_page.dart

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLockdownActive = false;
  double _loadLimitThreshold = 3.5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text('System Execution Variables', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Emergency Anti-Theft Security Lock Control Row
          Card(
            color: _isLockdownActive ? Colors.red.shade50 : null,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: _isLockdownActive ? Colors.red : Colors.transparent, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.gpp_bad, color: _isLockdownActive ? Colors.red : Colors.grey, size: 32),
                title: const Text('Intruder Emergency Lockdown', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Seals perimeter physical entry deadbolts instantly and isolates telemetry uplinks.'),
                trailing: Switch.adaptive(
                  activeTrackColor: Colors.red,
                  value: _isLockdownActive,
                  onChanged: (val) => setState(() => _isLockdownActive = val),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Adaptive Device Consumption Limit Slider Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.speed, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('System Grid Limiters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Automatically restricts appliances when usage parameters surpass set safety values.'),
                  Slider.adaptive(
                    min: 1.0,
                    max: 5.0,
                    divisions: 40,
                    label: '${_loadLimitThreshold.toStringAsFixed(2)} kW/h',
                    value: _loadLimitThreshold,
                    onChanged: (val) => setState(() => _loadLimitThreshold = val),
                  ),
                  Text(
                    'Threshold Action Parameter Target: ${_loadLimitThreshold.toStringAsFixed(2)} kW/h Max Safety Limit',
                    style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
