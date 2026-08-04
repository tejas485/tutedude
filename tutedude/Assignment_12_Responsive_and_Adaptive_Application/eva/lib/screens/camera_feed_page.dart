// lib/screens/camera_feed_page.dart

import 'package:flutter/material.dart';
import 'past_recordings_page.dart';

class CameraFeedPage extends StatelessWidget {
  const CameraFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Breakpoint condition for compact mobile viewports
    final bool isCompact = screenWidth < 600;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Flex structural block adapts column-wise for mobile, row-wise for TVs/Desktops
          Flex(
            direction: isCompact ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: isCompact ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
            children: [
              const Text(
                'Active Surveillance Feeds',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              if (isCompact) const SizedBox(height: 12), // Vertical spacing padding for mobile stack

              // Ergonomic container that stretches horizontally on mobile to double the tap area width,
              // but scales normally on larger displays based on available space.
              SizedBox(
                width: isCompact ? double.infinity : null,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    // Increases vertical padding on mobile for optimal thumb-tap target sizes
                    padding: EdgeInsets.symmetric(
                      vertical: isCompact ? 24 : 12,
                      horizontal: 20,
                    ),
                  ),
                  icon: const Icon(Icons.history, size: 24),
                  // Renamed label text to fulfill structural design requirements
                  label: const Text(
                    'Old Recording',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PastRecordingsPage()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Dynamically sets columns based on current viewport landscape profile
                int crossAxisCount = constraints.maxWidth > 800 ? 2 : 1;
                return GridView.builder(
                  itemCount: 4,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.6,
                  ),
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: Icon(Icons.videocam_off, color: Colors.grey.shade600, size: 40),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            color: Colors.black54,
                            child: Text(
                              'CAMERA CHANNEL 0${index + 1}',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 12,
                          right: 12,
                          child: Row(
                            children: [
                              CircleAvatar(radius: 4, backgroundColor: Colors.red),
                              SizedBox(width: 6),
                              Text('LIVE STREAM FEED', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
