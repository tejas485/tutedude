import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';

class MiniChatBox extends StatefulWidget {
  final String groupId;
  final String candidateUid;
  final String currentSenderRole;

  const MiniChatBox({
    super.key,
    required this.groupId,
    required this.candidateUid,
    required this.currentSenderRole,
  });

  @override
  State<MiniChatBox> createState() => _MiniChatBoxState();
}

class _MiniChatBoxState extends State<MiniChatBox> {
  final DatabaseService _dbService = DatabaseService();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      _dbService.sendLiveChatMessage(
        groupId: widget.groupId,
        candidateUid: widget.candidateUid,
        messageText: _textController.text.trim(),
        senderRole: widget.currentSenderRole,
      );
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _dbService.watchLiveChatFeed(widget.groupId, widget.candidateUid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Type below to chat.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final bool isMe = data['senderId'] == currentUid;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.deepPurple.withValues(alpha: 0.1) : Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          // Fixed: Corrected alignment identity name token here
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data['senderName']} (${data['senderRole']})',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                            ),
                            const SizedBox(height: 2),
                            Text(data['text'] ?? '', style: const TextStyle(fontSize: 13)),
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
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a reply...',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple, size: 20),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}