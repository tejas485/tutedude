// lib/widgets/iot_device_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/device_state.dart';

/// A self-contained, responsive grid-tile representation for an IoT appliance.
class IoTDeviceCard extends ConsumerWidget {
  final SmartDevice device;

  const IoTDeviceCard({super.key, required this.device});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dynamically fetch the correct icon according to device enum type
    final IconData iconData = _getDeviceIcon(device.type);

    // Switch styling accent colors dynamically based on power state status
    final Color activeColor = device.isSwitchedOn ? Colors.blue : Colors.grey.shade400;

    return Card(
      elevation: device.isSwitchedOn ? 4 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        // Instantly updates state globally when clicking anywhere on the card tile
        onTap: () => ref.read(deviceListProvider.notifier).toggleDevice(device.id),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Status Icon and the Adaptive Toggle Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: activeColor.withValues(alpha: 0.1),
                    child: Icon(iconData, color: activeColor),
                  ),
                  // A secondary precise switch target that updates the same provider
                  Switch.adaptive(
                    value: device.isSwitchedOn,
                    onChanged: (_) => ref.read(deviceListProvider.notifier).toggleDevice(device.id),
                  ),
                ],
              ),

              // Bottom Section: Descriptive Labels and Real-time Status Data
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    device.statusDetail,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Maps device enum types to clear Material design symbols.
  /// Uses a modern Dart 3 switch expression to eliminate layout syntax errors.
  IconData _getDeviceIcon(DeviceType type) {
    return switch (type) {
      DeviceType.light => Icons.lightbulb_outline,
      DeviceType.climate => Icons.thermostat,
      DeviceType.lock => Icons.lock_open,
      DeviceType.camera => Icons.videocam,
    };
  }
}
