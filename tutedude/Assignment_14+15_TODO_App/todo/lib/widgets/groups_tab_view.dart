import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/group_model.dart';

class GroupsTabView extends StatefulWidget {
  final ValueChanged<String?> onGroupSelected;
  const GroupsTabView({super.key, required this.onGroupSelected});

  @override
  State<GroupsTabView> createState() => _GroupsTabViewState();
}

class _GroupsTabViewState extends State<GroupsTabView> {
  final DatabaseService _dbService = DatabaseService();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add_box),
                label: const Text('Create New Group'),
                onPressed: _showCreateDialog,
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.link),
                label: const Text('Join Group by Token ID'),
                onPressed: _showJoinDialog,
              ),
            ],
          ),
          const Divider(height: 40),
          const Text('My Enrolled Groups', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<List<GroupModel>>(
              stream: _dbService.myGroups,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final groups = snapshot.data ?? [];
                if (groups.isEmpty) {
                  return const Center(child: Text('You are not currently enrolled in any workspace group.'));
                }

                return ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, idx) {
                    final group = groups[idx];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.folder_shared, color: Colors.deepPurple),
                        title: Text(group.name),
                        subtitle: Text('ID Token: ${group.id}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () => widget.onGroupSelected(group.id),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Workspace'),
        content: TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Group Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.trim().isNotEmpty) {
                _dbService.createGroup(_nameController.text);
                Navigator.pop(context);
                _nameController.clear();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showJoinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Private Workspace'),
        content: TextField(controller: _idController, decoration: const InputDecoration(labelText: 'Secret Group ID Token')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_idController.text.trim().isNotEmpty) {
                _dbService.applyToGroup(_idController.text);
                Navigator.pop(context);
                _idController.clear();
              }
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
