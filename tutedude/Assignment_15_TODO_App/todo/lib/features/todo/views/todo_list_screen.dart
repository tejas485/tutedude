import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';
import 'todo_form_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  String _searchFilter = '';
  String _priorityFilter = 'All'; // Handled dynamically via ChoiceChips

  Color _getPriorityColor(String priority) {
    if (priority == 'High') return AppColors.highPriority;
    if (priority == 'Medium') return AppColors.mediumPriority;
    return AppColors.lowPriority;
  }

  @override
  Widget build(BuildContext context) {
    final todoCtrl = Provider.of<TodoController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detailed Task Archive 📂')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: TextField(
                  decoration: const InputDecoration(hintText: 'Search tasks...', border: InputBorder.none, icon: Icon(Icons.search_rounded)),
                  onChanged: (text) => setState(() => _searchFilter = text.toLowerCase()),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Horizontal Tag Filter List updating our non-final variable field
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Low', 'Medium', 'High'].map((level) {
                  final isSelected = _priorityFilter == level;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: ChoiceChip(
                      label: Text('$level Priority'),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _priorityFilter = level);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<List<TodoModel>>(
                stream: todoCtrl.streamTodos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: MindfulLoader());
                  }

                  final filteredList = todoCtrl.todos.where((task) {
                    final matchesSearch = task.title.toLowerCase().contains(_searchFilter);
                    final matchesPriority = _priorityFilter == 'All' || task.priority == _priorityFilter;
                    return matchesSearch && matchesPriority;
                  }).toList();

                  if (filteredList.isEmpty) {
                    return const Center(child: Text('No items match your active search filters. 🤔'));
                  }

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(backgroundColor: _getPriorityColor(item.priority), radius: 10),
                          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Due: ${item.deadline.toString().substring(0, 16)}'),
                          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TodoFormScreen(todo: item))),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MindfulLoader extends StatelessWidget {
  const MindfulLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Provider.of<ThemeController>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 75,
              height: 75,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(themeCtrl.currentSeedColor),
              ),
            ),
            Icon(Icons.lock_outline_rounded, size: 28, color: themeCtrl.currentSeedColor),
          ],
        ),
      ],
    );
  }
}
