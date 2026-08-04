import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Fixed: Explicitly imported authentication classes
import '../encryption/crypto_service.dart';

class NotificationOverlay extends StatelessWidget {
  const NotificationOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(currentUid).collection('notifications').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];
        final activeAlerts = docs.where((d) {
          final data = d.data() as Map<String, dynamic>? ?? {};
          return data['isStale'] == false;
        }).length;

        return IconButton(
          icon: Badge(
            label: Text('$activeAlerts'),
            isLabelVisible: activeAlerts > 0,
            child: const Icon(Icons.notifications),
          ),
          onPressed: () => _showNotificationHistoryTray(context, docs),
        );
      },
    );
  }

  void _showNotificationHistoryTray(BuildContext context, List<DocumentSnapshot> docs) {
    showModalBottomSheet(
      context: context,
      builder: (context) => DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(tabs: [Tab(text: 'Active Alerts'), Tab(text: 'History Log (Stale)')]),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(docs.where((d) {
                    final data = d.data() as Map<String, dynamic>? ?? {};
                    return data['isStale'] == false;
                  }).toList()),
                  _buildList(docs.where((d) {
                    final data = d.data() as Map<String, dynamic>? ?? {};
                    return data['isStale'] == true;
                  }).toList()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<DocumentSnapshot> targetDocs) {
    if (targetDocs.isEmpty) return const Center(child: Text('No records logged.'));
    return ListView.builder(
      itemCount: targetDocs.length,
      itemBuilder: (context, idx) {
        final data = targetDocs[idx].data() as Map<String, dynamic>;
        return ListTile(
          leading: const Icon(Icons.info_outline, color: Colors.blue),
          title: Text(CryptoService.decrypt(data['message'] ?? '')),
        );
      },
    );
  }
}
