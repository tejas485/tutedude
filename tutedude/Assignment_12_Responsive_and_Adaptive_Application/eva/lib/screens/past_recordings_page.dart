// lib/screens/past_recordings_page.dart

import 'package:flutter/material.dart';

class PastRecordingsPage extends StatelessWidget {
  const PastRecordingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Surveillance Archive Index')),
      body: ListView.builder(
        itemCount: 8,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => Card(
          child: ListTile(
            leading: const Icon(Icons.play_circle_filled, size: 36, color: Colors.blue),
            title: Text('Security Event Protocol Trigger Frame_0$index'),
            subtitle: Text('Recorded timestamp reference point: May 16, 2026 - 1$index:24 AM'),
            trailing: const Icon(Icons.download_rounded),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
