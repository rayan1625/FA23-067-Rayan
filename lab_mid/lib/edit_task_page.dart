import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'task_model.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final DBHelper _dbHelper = DBHelper();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _dueDate;
  late bool _isRepeated;
  late double _progress;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _dueDate = widget.task.dueDate;
    _isRepeated = widget.task.isRepeated == 1;
    _progress = widget.task.progress;
  }

  Future<void> _updateTask() async {
    widget.task.title = _titleController.text;
    widget.task.description = _descController.text;
    widget.task.dueDate = _dueDate;
    widget.task.isRepeated = _isRepeated ? 1 : 0;
    widget.task.progress = _progress;

    await _dbHelper.updateTask(widget.task);

    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _pickDate() async {
    DateTime initialDate = DateTime.tryParse(_dueDate) ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dueDate = picked.toIso8601String().split('T').first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text("Due Date: $_dueDate"),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text("Repeat Task"),
              value: _isRepeated,
              onChanged: (val) => setState(() => _isRepeated = val),
            ),
            const SizedBox(height: 20),
            Text("Progress: ${(_progress * 100).toInt()}%"),
            Slider(
              value: _progress,
              onChanged: (val) => setState(() => _progress = val),
              divisions: 10,
              label: "${(_progress * 100).toInt()}%",
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _updateTask,
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
