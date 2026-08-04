import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import '../models/group_model.dart';
import '../models/chat_message_model.dart';

class FullscreenChatTheater extends StatefulWidget {
  final String currentGroupId;
  const FullscreenChatTheater({super.key, required this.currentGroupId});

  @override
  State<FullscreenChatTheater> createState() => _FullscreenChatTheaterState();
}

class _FullscreenChatTheaterState extends State<FullscreenChatTheater> with SingleTickerProviderStateMixin {
  final DatabaseService _dbService = DatabaseService();
  final _msgController = TextEditingController();
  late TabController _tabController;

  bool _isGroupChatSelected = true;
  String? _activePeerUid;
  String _activeTargetName = 'Workspace Channel General';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _dispatchMessage(String role) async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    if (_isGroupChatSelected) {
      await _dbService.sendGroupChatMessage(widget.currentGroupId, text, role);
    } else if (_activePeerUid != null) {
      await _dbService.sendDirectChatMessage(_activePeerUid!, text, role);
    }
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chat Workspace Hub'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
      ),
      body: StreamBuilder<List<GroupModel>>(
        stream: _dbService.myGroups,
        builder: (context, snapshot) {
          final group = (snapshot.data ?? []).firstWhere(
                (g) => g.id == widget.currentGroupId,
            orElse: () => GroupModel(id: '', name: '', founder: '', admins: [], coordinators: [], members: [], pendingApplications: {}),
          );

          String myRole = 'Member';
          if (group.founder == currentUid) myRole = 'Founder';
          if (group.admins.contains(currentUid) && group.founder != currentUid) myRole = 'Admin';
          if (group.coordinators.contains(currentUid)) myRole = 'Coordinator';

          return Row(
            children: [
              // Left Column Sidebar - Conversation Selectors Panel
              Container(
                width: 320,
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.black12, width: 1)),
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: const [Tab(text: 'Group Spaces'), Tab(text: 'Team Members')],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          ListView(
                            children: [
                              ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.groups)),
                                title: Text(group.name.isEmpty ? 'General Room' : group.name),
                                subtitle: const Text('Global task and team chat feed'),
                                selected: _isGroupChatSelected,
                                onTap: () => setState(() {
                                  _isGroupChatSelected = true;
                                  _activePeerUid = null;
                                  _activeTargetName = group.name;
                                }),
                              )
                            ],
                          ),
                          ListView(
                            children: group.members.map((mUid) {
                              if (mUid == currentUid) return const SizedBox();
                              return ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.person)),
                                title: Text('User ${mUid.substring(0, 5)}...'),
                                subtitle: const Text('Tap to secure direct P2P chat'),
                                selected: !_isGroupChatSelected && _activePeerUid == mUid,
                                onTap: () => setState(() {
                                  _isGroupChatSelected = false;
                                  _activePeerUid = mUid;
                                  _activeTargetName = 'Direct Chat User (${mUid.substring(0, 5)})';
                                }),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              // Right Column Dashboard - Main WhatsApp-Style Message Box Screen
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey.withValues(alpha: 0.05),
                      child: Text(_activeTargetName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Expanded(
                      child: StreamBuilder<List<ChatMessageModel>>(
                        stream: _isGroupChatSelected
                            ? _dbService.watchGroupChatFeed(widget.currentGroupId)
                            : _dbService.watchDirectChatFeed(_dbService.getPeerRoomId(_activePeerUid ?? '')),
                        builder: (context, msgSnapshot) {
                          final logs = msgSnapshot.data ?? [];
                          if (logs.isEmpty) {
                            return const Center(child: Text('Thread Empty. Initialize discussion below.', style: TextStyle(color: Colors.grey)));
                          }

                          return ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.all(16),
                            itemCount: logs.length,
                            itemBuilder: (context, idx) {
                              final msg = logs[idx];
                              final bool isMe = msg.senderId == currentUid;

                              return Align(
                                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isMe ? Colors.deepPurple.withValues(alpha: 0.12) : Colors.black12,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      Text('${msg.senderName} [${msg.senderRole}]', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                                      const SizedBox(height: 4),
                                      Text(msg.text, style: const TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _msgController,
                              decoration: const InputDecoration(hintText: 'Type a workspace message update...', border: OutlineInputBorder()),
                              onSubmitted: (_) => _dispatchMessage(myRole),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.deepPurple, size: 28),
                            onPressed: () => _dispatchMessage(myRole),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
