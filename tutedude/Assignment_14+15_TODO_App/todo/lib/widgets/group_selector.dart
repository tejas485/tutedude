import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/database_service.dart';
import '../models/group_model.dart';

class GroupSelector extends StatelessWidget {
  final String? selectedGroupId;
  final ValueChanged<String?> onGroupChanged;
  final DatabaseService _dbService = DatabaseService();

  GroupSelector({
    super.key,
    required this.selectedGroupId,
    required this.onGroupChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GroupModel>>(
      stream: _dbService.myGroups,
      builder: (context, snapshot) {
        final groups = snapshot.data ?? [];
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('Private Space'),
                selected: selectedGroupId == null,
                onSelected: (val) => onGroupChanged(null),
              ),
              ...groups.map((GroupModel g) => Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChoiceChip(
                      label: Text(g.name),
                      selected: selectedGroupId == g.id,
                      onSelected: (val) => onGroupChanged(g.id),
                    ),
                    if (selectedGroupId == g.id)
                      IconButton(
                        icon: const Icon(Icons.copy, size: 16),
                        onPressed: () => Clipboard.setData(ClipboardData(text: g.id)),
                      ),
                  ],
                ),
              )),
            ],
          ),
        );
      },
    );
  }
}
