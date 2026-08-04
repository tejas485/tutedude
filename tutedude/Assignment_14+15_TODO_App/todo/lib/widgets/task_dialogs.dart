import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import 'dialogue_modules/confirmation_dialog.dart';
import 'dialogue_modules/comment_dialog.dart';
import 'dialogue_modules/add_task_modal.dart';
import 'dialogue_modules/edit_task_modal.dart';

class TaskDialogs {
  static Future<bool> confirmAction(BuildContext context, String title, String content) async =>
      await ConfirmationDialog.show(context, title, content);

  static void showAddTaskModal(BuildContext context, Function(String title, String? location, DateTime? startTime, DateTime? endTime, String priority) onSave) =>
      AddTaskModal.show(context, onSave);

  static void showEditTaskModal(BuildContext context, TodoModel todo, Function(String title, String? location, DateTime? startTime, DateTime? endTime, String priority) onUpdate) =>
      EditTaskModal.show(context, todo, onUpdate);

  static void showCommentDialog(BuildContext context, Function(String commentary) onAddComment) =>
      CommentDialog.show(context, onAddComment);
}
