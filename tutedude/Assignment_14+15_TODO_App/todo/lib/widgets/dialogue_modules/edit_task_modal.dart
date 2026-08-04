import 'package:flutter/material.dart';
import '../../models/todo_model.dart';
import '../../encryption/crypto_service.dart';
import 'confirmation_dialog.dart';

class EditTaskModal extends StatefulWidget {
  final TodoModel todo;
  final Function(String title, String? location, DateTime? startTime, DateTime? endTime, String priority) onUpdate;

  const EditTaskModal({super.key, required this.todo, required this.onUpdate});

  static void show(
      BuildContext context, TodoModel todo,
      Function(String title, String? location, DateTime? startTime, DateTime? endTime, String priority) onUpdate,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditTaskModal(todo: todo, onUpdate: onUpdate),
    );
  }

  @override
  State<EditTaskModal> createState() => _EditTaskModalState();
}

class _EditTaskModalState extends State<EditTaskModal> {
  late TextEditingController _titleCtrl;
  late TextEditingController _locCtrl;
  DateTime? _start;
  DateTime? _end;
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: CryptoService.decrypt(widget.todo.title));
    _locCtrl = TextEditingController(text: CryptoService.decrypt(widget.todo.location ?? ''));
    _start = widget.todo.startTime;
    _end = widget.todo.endTime;
    _selectedPriority = widget.todo.priority;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Modify Assignment Attributes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          const SizedBox(height: 12),
          TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Task Title *', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _locCtrl, decoration: const InputDecoration(labelText: 'Location (Optional)', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            // FIXED: Replaced deprecated 'value' parameter with modern 'initialValue'
            initialValue: _selectedPriority,
            decoration: const InputDecoration(labelText: 'Priority Level', border: OutlineInputBorder()),
            items: ['High', 'Medium', 'Low'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (val) => setState(() => _selectedPriority = val ?? 'Medium'),
          ),
          ListTile(
            title: Text(_start == null ? 'Set Start Time' : 'Starts: ${_start.toString().substring(0, 16)}'),
            trailing: const Icon(Icons.calendar_month),
            onTap: () async {
              final date = await showDatePicker(context: context, initialDate: _start ?? DateTime.now(), firstDate: DateTime.now().subtract(const Duration(days: 30)), lastDate: DateTime.now().add(const Duration(days: 365)));
              if (date != null && context.mounted) {
                final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_start ?? DateTime.now()));
                if (time != null && context.mounted) {
                  setState(() => _start = DateTime(date.year, date.month, date.day, time.hour, time.minute));
                }
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_titleCtrl.text.trim().isNotEmpty) {
                bool confirm = await ConfirmationDialog.show(context, "Confirm Update", "Commit adjustments and synchronize this data across the cloud database?");
                if (confirm && context.mounted) {
                  widget.onUpdate(_titleCtrl.text.trim(), _locCtrl.text.trim(), _start, _end, _selectedPriority);
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Save Adjustments'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
