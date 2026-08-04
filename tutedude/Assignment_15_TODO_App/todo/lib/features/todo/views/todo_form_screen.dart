import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';

class TodoFormScreen extends StatefulWidget {
  final TodoModel? todo;
  const TodoFormScreen({super.key, this.todo});

  @override
  State<TodoFormScreen> createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _priority;
  late DateTime _start;
  late DateTime _deadline;

  @override
  void initState() {
    super.initState();
    _title = widget.todo?.title ?? '';
    _description = widget.todo?.description ?? '';
    _priority = widget.todo?.priority ?? 'Low';
    _start = widget.todo?.startTime ?? DateTime.now();
    _deadline = widget.todo?.deadline ?? DateTime.now().add(const Duration(days: 1));
  }

  // RESTORED: Material Date & Time calculation selection loops crucial for notification engine mapping vectors
  void _pickDateTime(bool isStart) async {
    DateTime? day = await showDatePicker(
      context: context,
      initialDate: isStart ? _start : _deadline,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (day == null) return;

    if (mounted) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStart ? _start : _deadline),
      );
      if (time == null) return;

      setState(() {
        final mergedDate = DateTime(day.year, day.month, day.day, time.hour, time.minute);
        if (isStart) {
          _start = mergedDate;
        } else {
          _deadline = mergedDate;
        }
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final item = TodoModel(
      id: widget.todo?.id ?? '',
      title: _title,
      description: _description,
      startTime: _start,
      deadline: _deadline,
      priority: _priority,
      progressPercent: widget.todo?.progressPercent ?? 0,
      comments: widget.todo?.comments ?? [],
    );

    Provider.of<TodoController>(context, listen: false).saveTodo(item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Provider.of<ThemeController>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.todo == null ? 'Draft New Task' : 'Modify Task Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Short Headline Title', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                onSaved: (val) => _title = val ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Detailed Description Info Text', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                onSaved: (val) => _description = val ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _priority,
                decoration: const InputDecoration(labelText: 'Set Task Urgency Priority', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                items: ['Low', 'Medium', 'High'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (val) => setState(() => _priority = val ?? 'Low'),
              ),
              const SizedBox(height: 16),
              // Restored visual interface configuration boxes
              Container(
                decoration: BoxDecoration(color: themeCtrl.getTintedSurface(context, strength: 0.08), borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Start Date-Time Setting', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(_start.toString().substring(0, 16)),
                      trailing: IconButton(icon: Icon(Icons.calendar_month, color: themeCtrl.currentSeedColor), onPressed: () => _pickDateTime(true)),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Hard Deadline Target Window', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(_deadline.toString().substring(0, 16)),
                      trailing: IconButton(icon: Icon(Icons.alarm, color: themeCtrl.currentSeedColor), onPressed: () => _pickDateTime(false)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(backgroundColor: themeCtrl.currentSeedColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
                child: const Text('Confirm & Sync Record Safely', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
