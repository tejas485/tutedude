import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import '../models/todo_model.dart';
import '../encryption/crypto_service.dart';
import 'task_dialogs.dart';

class TaskStreamView extends StatefulWidget {
  final String? selectedGroupId;
  final String searchKeyword;

  const TaskStreamView({super.key, required this.selectedGroupId, required this.searchKeyword});

  @override
  State<TaskStreamView> createState() => _TaskStreamViewState();
}

class _TaskStreamViewState extends State<TaskStreamView> {
  final DatabaseService _dbService = DatabaseService();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _computeLiveTickerString(DateTime? startTime) {
    if (startTime == null) return "Indefinite Schedule";
    final now = DateTime.now();
    final difference = startTime.difference(now);

    if (difference.isNegative) {
      return "🏃 Task In Progress (${difference.abs().inMinutes}m ago)";
    }

    final int days = difference.inDays;
    final int hours = difference.inHours % 24;
    final int minutes = difference.inMinutes % 60;
    final int seconds = difference.inSeconds % 60;

    if (days > 0) return "⏳ T-Minus $days days, ${hours}h";
    return "⏳ T-Minus ${hours}h ${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    final Stream<List<TodoModel>> taskStream = widget.searchKeyword.trim().isNotEmpty
        ? _dbService.searchTasksLocally(widget.selectedGroupId, widget.searchKeyword)
        : (widget.selectedGroupId == null ? _dbService.privateTodos : _dbService.groupTodos(widget.selectedGroupId!));

    return StreamBuilder<List<TodoModel>>(
      stream: taskStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final tasks = snapshot.data ?? [];
        if (tasks.isEmpty) {
          return const Center(child: Text('No allocations found matching filters.'));
        }

        final double width = MediaQuery.of(context).size.width;
        int crossAxisCount = 1;
        if (width >= 768 && width < 1200) crossAxisCount = 2;
        if (width >= 1200) crossAxisCount = 3;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 12,
            mainAxisExtent: 220,
          ),
          itemCount: tasks.length,
          itemBuilder: (context, idx) {
            final todo = tasks[idx];
            _dbService.evaluateMilestoneTriggers(todo);
            return _buildDynamicTaskTileCard(todo);
          },
        );
      },
    );
  }

  Widget _buildDynamicTaskTileCard(TodoModel todo) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final bool isOwner = todo.createdBy == currentUid;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: todo.priority == 'High' ? Colors.redAccent.withValues(alpha: 0.1) : Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(todo.priority, style: TextStyle(color: todo.priority == 'High' ? Colors.red : Colors.orange, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
                if (isOwner)
                  IconButton(
                    icon: const Icon(Icons.edit_note, color: Colors.deepPurple, size: 24),
                    tooltip: 'Modify Task Attributes (Owner Privilege)',
                    onPressed: () {
                      TaskDialogs.showEditTaskModal(context, todo, (title, loc, start, end, priority) {
                        _dbService.editTaskDetails(todoId: todo.id, newTitle: title, newLocation: loc, newStart: start, newEnd: end, newPriority: priority);
                      });
                    },
                  )
                else
                  const Tooltip(
                    message: 'Read-only parameter assignment: restricted to allocation creator.',
                    child: Icon(Icons.lock_person, size: 18, color: Colors.grey),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              CryptoService.decrypt(todo.title),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text('📍 ${CryptoService.decrypt(todo.location ?? "Digital Hub")}', style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1),
            const Spacer(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _computeLiveTickerString(todo.startTime),
                    // FIXED: Replaced invalid w640 with standard FontWeight.w600
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.deepPurple),
                  ),
                ),
                if (isOwner)
                  IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.redAccent, size: 20),
                    onPressed: () async {
                      bool confirm = await TaskDialogs.confirmAction(context, "Confirm Delete", "Remove this task from team workspaces permanently?");
                      if (confirm) _dbService.deleteTodo(todo.id);
                    },
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}