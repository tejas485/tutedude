import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/todo_controller.dart';
import '../models/comment_model.dart';
import '../models/todo_model.dart';

class CommentsSheet extends StatefulWidget {
  final TodoModel todo;
  const CommentsSheet({super.key, required this.todo});

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final _commentController = TextEditingController();

  void _postComment() {
    if (_commentController.text.trim().isEmpty) return;

    final currentUsername = Provider.of<AuthController>(context, listen: false).currentUsername;
    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: currentUsername,
      text: _commentController.text.trim(),
      timestamp: DateTime.now(),
    );

    setState(() {
      widget.todo.comments.add(newComment);
    });

    Provider.of<TodoController>(context, listen: false).saveTodo(widget.todo);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          const Text('Progress Log Threads 💬', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: widget.todo.comments.isEmpty
                ? const Center(child: Text('No comments or status logs added yet. Add an update down below!'))
                : ListView.builder(
              itemCount: widget.todo.comments.length,
              itemBuilder: (context, i) {
                final c = widget.todo.comments[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 16, child: Text(c.username.substring(0,1).toUpperCase())),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(text: '@${c.username} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: c.text),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(c.timestamp.toString().substring(11,16), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(hintText: 'Add an update note or milestone log...', border: InputBorder.none),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send_rounded), onPressed: _postComment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
