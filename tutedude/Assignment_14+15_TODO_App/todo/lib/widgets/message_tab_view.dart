import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/group_model.dart';
import '../screens/fullscreen_chat_theater.dart';

class MessageTabView extends StatelessWidget {
  const MessageTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService dbService = DatabaseService();

    return StreamBuilder<List<GroupModel>>(
      stream: dbService.myGroups,
      builder: (context, snapshot) {
        final groups = snapshot.data ?? [];

        // Fixed Linter Info: Enclosed single-line conditional check inside structured braces
        if (groups.isEmpty) {
          return const Center(child: Text('No communication streams mapped.'));
        }

        return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, idx) {
            final group = groups[idx];

            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.forum)),
              title: Text(group.name),
              trailing: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                child: const Text(
                  '2',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullscreenChatTheater(currentGroupId: group.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
