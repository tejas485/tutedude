import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';

class CandidateView extends StatelessWidget {
  final String groupId;
  final DatabaseService _dbService = DatabaseService();

  CandidateView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Portal'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _dbService.watchApplicationStatus(groupId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text('Workspace Group could not be located.');
            }

            final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
            final pending = data['pendingApplications'] ?? {};
            final candidateData = pending[uid] ?? {};
            final oneWayMessage = candidateData['oneWayMessage'] ?? 'Your application is currently pending executive authority review.';

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  width: 450,
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.hourglass_top, size: 64, color: Colors.deepOrange),
                      const SizedBox(height: 24),
                      Text(
                        'Join Request Lodged',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Group Name: ${data['name'] ?? "Unnamed workspace"}',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const Divider(height: 40),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Secure Broadcast Stream:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          oneWayMessage,
                          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
