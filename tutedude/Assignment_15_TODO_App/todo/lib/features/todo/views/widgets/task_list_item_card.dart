import 'package:flutter/material.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../models/todo_model.dart';
import '../comments_sheet.dart';
import '../todo_form_screen.dart';

class TaskListItemCard extends StatelessWidget {
  final TodoModel item;
  final ThemeController themeCtrl;
  final Color priorityColor;
  final VoidCallback onAdjustProgress;

  const TaskListItemCard({
    super.key,
    required this.item,
    required this.themeCtrl,
    required this.priorityColor,
    required this.onAdjustProgress,
  });

  @override
  Widget build(BuildContext context) {
    final double singleCompletion = item.progressPercent / 100.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: themeCtrl.getTintedSurface(context, strength: 0.05),
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        boxShadow: themeCtrl.getNeumorphicShadow(context),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: singleCompletion,
              strokeWidth: 4,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation(priorityColor),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: priorityColor),
            ),
          ],
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          'Due: ${item.deadline.toString().substring(0, 16)}\nProgress: ${item.progressPercent}% completed',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.forum_outlined, color: themeCtrl.currentSeedColor),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => FractionallySizedBox(
                    heightFactor: 0.7,
                    child: CommentsSheet(todo: item),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.incomplete_circle_rounded, color: themeCtrl.currentSeedColor),
              onPressed: onAdjustProgress,
            ),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TodoFormScreen(todo: item)),
        ),
      ),
    );
  }
}
