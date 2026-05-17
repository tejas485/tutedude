// lib/screens/desktop_dashboard.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'energy_analysis_page.dart';
import 'settings_page.dart';
import 'camera_feed_page.dart';
import '../state/device_state.dart';
import '../widgets/iot_device_card.dart';
import '../widgets/circular_load_widget.dart';

class DesktopDashboard extends ConsumerStatefulWidget {
  const DesktopDashboard({super.key});

  @override
  ConsumerState<DesktopDashboard> createState() => _DesktopDashboardState();
}

class _DesktopDashboardState extends ConsumerState<DesktopDashboard> {
  int _selectedIndex = 0;
  bool _isSidebarOpen = true;

  @override
  Widget build(BuildContext context) {
    final devices = ref.watch(deviceListProvider);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    // Ordered catalog mapping the workspace tab route panels cleanly
    final List<Widget> pages = [
      _buildMainGridHome(devices),
      const EnergyAnalysisPage(),
      const CameraFeedPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecosystem Matrix Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(_isSidebarOpen ? Icons.close : Icons.menu),
          tooltip: 'Toggle Navigation Control Sidebar Panel',
          onPressed: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
        ),
      ),
      body: Row(
        children: [
          // Collapsible Smooth Sliding Animation Navigation Drawer Sidebar Panel
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: _isSidebarOpen ? (isMobile ? screenWidth * 0.7 : 260) : 0,
            curve: Curves.easeInOut,
            child: ClipRect(
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: ListView(
                  children: [
                    _buildNavTile(0, Icons.dashboard, 'Main Dashboard Workspace'),
                    _buildNavTile(1, Icons.analytics, 'Energy Load Matrix'),
                    _buildNavTile(2, Icons.text_snippet, 'Live Perimeter Camera Feeds'),
                    _buildNavTile(3, Icons.security, 'System Protection Settings'),
                  ],
                ),
              ),
            ),
          ),

          // Scrim overlay shield factor strictly matching smartphone viewing aspect ratios
          if (_isSidebarOpen && isMobile)
            GestureDetector(
              onTap: () => setState(() => _isSidebarOpen = false),
              child: Container(
                width: screenWidth * 0.3,
                color: Colors.black.withValues(alpha: 0.25),
              ),
            ),

          // Primary View Router Execution Panel Canvas Box Frame
          Expanded(
            child: SafeArea(
              child: IndexedStack(
                index: _selectedIndex,
                children: pages,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual uniform sidebar options item listings cleanly
  Widget _buildNavTile(int index, IconData icon, String title) {
    final bool isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : null),
      title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedIndex = index;
          // Auto collapse drawer navigation on small phones to maximize active site workspace area
          if (MediaQuery.of(context).size.width < 600) _isSidebarOpen = false;
        });
      },
    );
  }

  /// STEP 3 IMPLEMENTATION: Houses the primary hardware catalog grid layout with an overlapping,
  /// floating real-time color power consumption gauge wheel absolute-anchored at the bottom-right.
  Widget _buildMainGridHome(List<SmartDevice> devices) {
    return Stack(
      children: [
        // Base Layer: Responsive Matrix Layout Framework mapping active appliances
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Active Grid Hardware Map', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: devices.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 1.15,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) => IoTDeviceCard(device: devices[index]),
                ),
              ),
            ],
          ),
        ),

        // Floating Overlay Layer: Solid circle power readout locked securely at the bottom right corner with margin buffers
        const Positioned(
          bottom: 24, // Exact spacing away from base screen edge floor
          right: 24,  // Exact protective spacing away from the side frame wall edge
          child: CircularLoadWidget(currentLoad: 1.432),
        ),
      ],
    );
  }
}
