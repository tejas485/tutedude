import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/database_service.dart';
import '../../models/group_model.dart';
import '../task_dialogs.dart';

class TeamRolesManager extends StatelessWidget {
  final GroupModel group;
  final DatabaseService _dbService = DatabaseService();

  TeamRolesManager({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (!group.admins.contains(currentUid)) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        const Text(
          'Manage Team Roles',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
        const SizedBox(height: 8),
        ...group.members.map((memberUid) {
          if (memberUid == currentUid) {
            return const SizedBox();
          }
          String roleTitle = 'Member';
          if (group.admins.contains(memberUid)) roleTitle = 'Admin';
          if (group.coordinators.contains(memberUid)) roleTitle = 'Coordinator';
          if (group.founder == memberUid) roleTitle = 'Founder 🎖️';

          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(memberUid.length > 8 ? '${memberUid.substring(0, 8)}...' : memberUid),
            subtitle: Text('Current: $roleTitle', style: const TextStyle(fontSize: 12)),
            trailing: group.founder == currentUid
                ? PopupMenuButton<String>(
              onSelected: (action) async {
                // Confirmation: Role Clearance Interceptor
                bool proceed = await TaskDialogs.confirmAction(
                  context,
                  "Confirm Update",
                  "Are you sure you want to alter this teammate's authorization clearance parameters inside this group?",
                );

                if (proceed) {
                  if (action == 'admin') _dbService.promoteToAdmin(group.id, memberUid);
                  if (action == 'coord') _dbService.promoteToCoordinator(group.id, memberUid);
                  if (action == 'member') _dbService.demoteToMember(group.id, memberUid);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'admin', child: Text('Make Admin')),
                const PopupMenuItem(value: 'coord', child: Text('Make Coordinator')),
                const PopupMenuItem(value: 'member', child: Text('Demote to Regular')),
              ],
            )
                : null,
          );
        }),
      ],
    );
  }
}
