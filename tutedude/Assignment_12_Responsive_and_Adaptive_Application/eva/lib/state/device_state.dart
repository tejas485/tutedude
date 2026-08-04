// lib/state/device_state.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DeviceType { light, climate, lock, camera }

class SmartDevice {
  final String id;
  final String name;
  final DeviceType type;
  final bool isSwitchedOn;
  final String statusDetail;

  SmartDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.isSwitchedOn,
    required this.statusDetail,
  });

  SmartDevice copyWith({bool? isSwitchedOn, String? statusDetail}) {
    return SmartDevice(
      id: id,
      name: name,
      type: type,
      isSwitchedOn: isSwitchedOn ?? this.isSwitchedOn,
      statusDetail: statusDetail ?? this.statusDetail,
    );
  }
}

/// FIX: Extends standard Notifier instead of StateNotifier to prevent inheritance compilation errors
class DeviceListNotifier extends Notifier<List<SmartDevice>> {
  @override
  List<SmartDevice> build() {
    // Standard initialization of the state array
    return [
      SmartDevice(id: '1', name: 'Living Room Light', type: DeviceType.light, isSwitchedOn: true, statusDetail: '80% Brightness'),
      SmartDevice(id: '2', name: 'Smart Thermostat', type: DeviceType.climate, isSwitchedOn: true, statusDetail: '71°F - Cooling'),
      SmartDevice(id: '3', name: 'Front Door Lock', type: DeviceType.lock, isSwitchedOn: false, statusDetail: 'Unlocked'),
      SmartDevice(id: '4', name: 'Driveway Camera', type: DeviceType.camera, isSwitchedOn: true, statusDetail: 'Live Feed Online'),
      SmartDevice(id: '5', name: 'Kitchen Light', type: DeviceType.light, isSwitchedOn: false, statusDetail: 'Off'),
    ];
  }

  void toggleDevice(String id) {
    // Modifies state cleanly
    state = [
      for (final device in state)
        if (device.id == id)
          device.copyWith(
            isSwitchedOn: !device.isSwitchedOn,
            statusDetail: !device.isSwitchedOn
                ? (device.type == DeviceType.lock ? 'Locked' : 'On')
                : (device.type == DeviceType.lock ? 'Unlocked' : 'Off'),
          )
        else
          device,
    ];
  }
}

/// FIX: Standardized cleanly to NotifierProvider
final deviceListProvider = NotifierProvider<DeviceListNotifier, List<SmartDevice>>(() {
  return DeviceListNotifier();
});
