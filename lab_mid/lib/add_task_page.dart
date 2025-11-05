import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'task_model.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DBHelper();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  bool _isRepeated = false;
  double _progress = 0.0;
  String _priority = 'Medium';

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
        "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      Task newTask = Task(
        title: _titleController.text,
        description: _descController.text,
        dueDate: _dateController.text,
        isRepeated: _isRepeated ? 1 : 0,
        progress: _progress,
        priority: _priority,
      );

      await _dbHelper.insertTask(newTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? 'Enter task title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? 'Select due date' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Repeat Task'),
                  Switch(
                    value: _isRepeated,
                    onChanged: (v) {
                      setState(() => _isRepeated = v);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: ['Low', 'Medium', 'High']
                    .map((p) =>
                    DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => _priority = v!),
              ),
              const SizedBox(height: 12),
              Text("Progress: ${(_progress * 100).toInt()}%"),
              Slider(
                value: _progress,
                onChanged: (v) => setState(() => _progress = v),
                divisions: 10,
                label: "${(_progress * 100).toInt()}%",
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveTask,
                icon: const Icon(Icons.save),
                label: const Text("Save Task"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
