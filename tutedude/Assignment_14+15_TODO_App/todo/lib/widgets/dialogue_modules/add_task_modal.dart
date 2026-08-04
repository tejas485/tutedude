import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';

class AddTaskModal extends StatefulWidget {
  final Function(String title, String? location, DateTime? startTime, DateTime? endTime, String priority) onSave;

  const AddTaskModal({super.key, required this.onSave});

  static void show(
      BuildContext context,
      Function(String title, String? location, DateTime? startTime, DateTime? endTime, String priority) onSave,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddTaskModal(onSave: onSave),
    );
  }

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _titleCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  DateTime? _start;
  DateTime? _end;
  String _selectedPriority = 'Medium';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Create New Task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Task Title *', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _locCtrl, decoration: const InputDecoration(labelText: 'Location (Optional)', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            // FIXED: Replaced deprecated 'value' with modern 'initialValue' parameter
            initialValue: _selectedPriority,
            decoration: const InputDecoration(labelText: 'Task Urgency Priority', border: OutlineInputBorder()),
            items: ['High', 'Medium', 'Low'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (val) => setState(() => _selectedPriority = val ?? 'Medium'),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: Text(_start == null ? 'Set Start Time' : 'Starts: ${_start.toString().substring(0, 16)}'),
            trailing: const Icon(Icons.calendar_month),
            onTap: () async {
              final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(const Duration(minutes: 5)), lastDate: DateTime.now().add(const Duration(days: 365)));
              if (date != null && context.mounted) {
                final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (time != null && context.mounted) {
                  bool confirmTime = await ConfirmationDialog.show(context, "Confirm Change Time", "Are you sure you want to set this start window timestamp execution marker?");
                  if (confirmTime) {
                    setState(() {
                      _start = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      if (_end != null && _end!.isBefore(_start!)) _end = null;
                    });
                  }
                }
              }
            },
          ),
          ListTile(
            title: Text(_end == null ? 'No Deadline (Indefinite)' : 'Ends: ${_end.toString().substring(0, 16)}'),
            trailing: const Icon(Icons.av_timer),
            onTap: _start == null ? null : () async {
              final date = await showDatePicker(context: context, initialDate: _start!, firstDate: _start!, lastDate: DateTime.now().add(const Duration(days: 365)));
              if (date != null && context.mounted) {
                final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_start!));
                if (time != null && context.mounted) {
                  bool confirmDeadline = await ConfirmationDialog.show(context, "Confirm Change Time", "Commit this target deadline window metric into state memory?");
                  if (confirmDeadline) {
                    final selectedEnd = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                    if (selectedEnd.isAfter(_start!)) {
                      setState(() => _end = selectedEnd);
                    }
                  }
                }
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_titleCtrl.text.trim().isNotEmpty) {
                bool confirmSubmit = await ConfirmationDialog.show(context, "Confirm Update", "Do you want to finalize and transmit this new assignment record entry into cloud archives?");
                if (confirmSubmit && context.mounted) {
                  widget.onSave(_titleCtrl.text.trim(), _locCtrl.text.trim(), _start, _end, _selectedPriority);
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Save Task'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
