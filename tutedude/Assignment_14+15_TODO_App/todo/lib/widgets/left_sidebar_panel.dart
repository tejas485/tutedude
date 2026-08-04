import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import '../models/group_model.dart';
import '../screens/fullscreen_chat_theater.dart';
import 'sidebar_modules/group_actions_panel.dart';
import 'sidebar_modules/governance_chat_list.dart';
import 'sidebar_modules/team_roles_manager.dart';

class LeftSidebarPanel extends StatefulWidget {
  final String? selectedGroupId;
  final ValueChanged<String?> onGroupChanged;
  final bool showCloseButton;
  final VoidCallback onCloseTap;

  const LeftSidebarPanel({
    super.key,
    required this.selectedGroupId,
    required this.onGroupChanged,
    required this.showCloseButton,
    required this.onCloseTap,
  });

  @override
  State<LeftSidebarPanel> createState() => _LeftSidebarPanelState();
}

class _LeftSidebarPanelState extends State<LeftSidebarPanel> {
  final DatabaseService _dbService = DatabaseService();
  final _welcomeNoteController = TextEditingController();

  @override
  void dispose() {
    _welcomeNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: StreamBuilder<List<GroupModel>>(
            stream: _dbService.myGroups,
            builder: (context, snapshot) {
              final group = (snapshot.data ?? []).firstWhere(
                    (g) => g.id == widget.selectedGroupId,
                orElse: () => GroupModel(
                  id: '',
                  name: '',
                  founder: '',
                  admins: [],
                  coordinators: [],
                  members: [],
                  pendingApplications: {},
                ),
              );

              // FIXED: Changed ListView to a standard SingleChildScrollView layout column wrapper, allowing internal module list items to expand safely without bounds issues.
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Collaboration Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          if (widget.showCloseButton)
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              tooltip: 'Close Drawer Panel',
                              onPressed: widget.onCloseTap,
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const GroupActionsPanel(),
                      if (widget.selectedGroupId != null) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.fullscreen),
                            label: const Text('Open Fullscreen Chat'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullscreenChatTheater(currentGroupId: widget.selectedGroupId!),
                                ),
                              );
                            },
                          ),
                        ),
                        _buildWelcomeNoteCustomizer(group),
                        GovernanceChatList(group: group),
                        TeamRolesManager(group: group),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }


  Widget _buildWelcomeNoteCustomizer(GroupModel group) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (!group.admins.contains(currentUid)) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        const Text('Custom Automated Note', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 8),
        TextField(controller: _welcomeNoteController, decoration: const InputDecoration(hintText: 'Add custom introductory mail note...', border: OutlineInputBorder())),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _dbService.updateCustomWelcomeNote(group.id, _welcomeNoteController.text);
              _welcomeNoteController.clear();
            },
            child: const Text('Update Template'),
          ),
        ),
      ],
    );
  }
}
