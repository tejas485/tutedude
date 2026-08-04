import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class GroupActionsPanel extends StatefulWidget {
  const GroupActionsPanel({super.key});

  @override
  State<GroupActionsPanel> createState() => _GroupActionsPanelState();
}

class _GroupActionsPanelState extends State<GroupActionsPanel> {
  final DatabaseService _dbService = DatabaseService();
  final _groupNameController = TextEditingController();
  final _joinGroupIdController = TextEditingController();

  @override
  void dispose() {
    _groupNameController.dispose();
    _joinGroupIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _groupNameController,
          decoration: const InputDecoration(
            labelText: 'New Group Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (_groupNameController.text.trim().isNotEmpty) {
                await _dbService.createGroup(_groupNameController.text.trim());
                _groupNameController.clear();
              }
            },
            child: const Text('Create Team'),
          ),
        ),
        const Divider(height: 32),
        TextField(
          controller: _joinGroupIdController,
          decoration: const InputDecoration(
            labelText: 'Apply Group Token ID',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (_joinGroupIdController.text.trim().isNotEmpty) {
                await _dbService.applyToGroup(_joinGroupIdController.text.trim());
                _joinGroupIdController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit Access Application'),
          ),
        ),
      ],
    );
  }
}
