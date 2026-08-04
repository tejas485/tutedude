import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/database_service.dart';
import '../../models/group_model.dart';
import '../user_search_delegate.dart';

class OfficialDrawerHub extends StatelessWidget {
  final String? selectedGroupId;
  final ValueChanged<String?> onGroupChanged;
  final ValueChanged<String> onTabChanged;
  final VoidCallback onLogoutTap;
  final DatabaseService _dbService = DatabaseService();

  OfficialDrawerHub({
    super.key,
    required this.selectedGroupId,
    required this.onGroupChanged,
    required this.onTabChanged,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 330,
      child: StreamBuilder<List<GroupModel>>(
        stream: _dbService.myGroups,
        builder: (context, snapshot) {
          final groups = snapshot.data ?? [];

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Control Panel Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepPurple)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Close Side Panel',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const Text('Active Workspace Filters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: const Text('My Private Space'),
                        selected: selectedGroupId == null,
                        onTap: () {
                          onGroupChanged(null);
                          Navigator.pop(context);
                        },
                      ),
                      ...groups.map((g) => ListTile(
                        leading: const Icon(Icons.folder_shared, color: Colors.amber),
                        title: Text(g.name),
                        selected: selectedGroupId == g.id,
                        trailing: selectedGroupId == g.id
                            ? IconButton(
                          icon: const Icon(Icons.copy, size: 16, color: Colors.blue),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: g.id));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Group ID token copied to clipboard!')),
                            );
                          },
                        )
                            : null,
                        onTap: () {
                          onGroupChanged(g.id);
                          Navigator.pop(context);
                        },
                      )),
                      const Divider(height: 32),
                      const UserSearchDelegate(),
                      const SizedBox(height: 24),
                      const Text('Application Navigation Links', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      ListTile(leading: const Icon(Icons.playlist_add_check), title: const Text('Tasks Stream Deck'), onTap: () { onTabChanged('tasks'); Navigator.pop(context); }),
                      ListTile(leading: const Icon(Icons.group_add), title: const Text('Manage Groups Tab'), onTap: () { onTabChanged('groups'); Navigator.pop(context); }),
                      ListTile(leading: const Icon(Icons.forum), title: const Text('Messages Theater Room'), onTap: () { onTabChanged('messages'); Navigator.pop(context); }),
                      ListTile(leading: const Icon(Icons.manage_accounts), title: const Text('My Profile Options'), onTap: () { onTabChanged('profile'); Navigator.pop(context); }),
                      const Divider(height: 32),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app, color: Colors.red),
                        title: const Text('Logout Session', style: TextStyle(color: Colors.red)),
                        onTap: onLogoutTap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
