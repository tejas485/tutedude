import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/database_service.dart';
import '../../models/group_model.dart';
import '../mini_chat_box.dart';
import '../task_dialogs.dart';

class GovernanceChatList extends StatelessWidget {
  final GroupModel group;
  final DatabaseService _dbService = DatabaseService();

  GovernanceChatList({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    bool isAdmin = group.admins.contains(currentUid);
    bool isCoord = group.coordinators.contains(currentUid);

    if ((!isAdmin && !isCoord) || group.pendingApplications.isEmpty) {
      return const SizedBox();
    }

    String senderRole = isCoord ? 'Coordinator' : 'Admin';
    if (group.founder == currentUid) senderRole = 'Founder';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        const Text(
          'Pending Approvals & Chat',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
        ),
        const SizedBox(height: 8),
        ...group.pendingApplications.entries.map((entry) {
          final candidateId = entry.key;
          final data = entry.value as Map<String, dynamic>;
          final candidateLabel = data['displayName'] ?? data['email'] ?? 'Unknown applicant';

          return Card(
            color: Colors.amber.withValues(alpha: 0.05),
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(candidateLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Confirmation: Applicant Admission Safeguard
                          bool proceed = await TaskDialogs.confirmAction(
                            context,
                            "Confirm Update",
                            "Grant full workspace access clearance to this applicant and add them to the team directory?",
                          );
                          if (proceed) {
                            _dbService.instantApproveUser(group.id, candidateId);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Approve', style: TextStyle(fontSize: 11)),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  MiniChatBox(
                    groupId: group.id,
                    candidateUid: candidateId,
                    currentSenderRole: senderRole,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
