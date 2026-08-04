import 'package:flutter/material.dart';

class CommentDialog extends StatefulWidget {
  final Function(String commentary) onAddComment;

  const CommentDialog({super.key, required this.onAddComment});

  static void show(BuildContext context, Function(String commentary) onAddComment) {
    showDialog(
      context: context,
      builder: (context) => CommentDialog(onAddComment: onAddComment),
    );
  }

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task Comment'),
      content: TextField(
        controller: _commentCtrl,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Type your message or task note update...',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_commentCtrl.text.trim().isNotEmpty) {
              widget.onAddComment(_commentCtrl.text.trim());
              Navigator.pop(context);
            }
          },
          child: const Text('Post Comment'),
        ),
      ],
    );
  }
}
