import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'task_model.dart';
import 'add_task_page.dart';
import 'edit_task_page.dart';

class HomePage extends StatefulWidget {
  final bool isDark;
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.isDark, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final DBHelper _dbHelper = DBHelper();
  List<Task> _tasks = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadTasks();
    _tabController.addListener(() {
      // optional: refresh when tab changes
      if (_tabController.indexIsChanging == false) {
        setState(() {});
      }
    });
  }

  Future<void> _loadTasks() async {
    final data = await _dbHelper.getTasks();
    setState(() {
      _tasks = data;
    });
  }

  Future<void> _goToAddTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    );
    await _loadTasks();
  }

  Future<void> _goToEditTask(Task t) async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTaskPage(task: t)),
    );
    // EditTaskPage returns true after successful update (if implemented)
    if (res == true) await _loadTasks();
  }

  void _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    await _loadTasks();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task deleted')));
  }

  void _toggleComplete(Task t) async {
    t.isCompleted = t.isCompleted == 1 ? 0 : 1;
    // optional: when marking complete, set progress = 1.0
    if (t.isCompleted == 1) {
      t.progress = 1.0;
    } else {
      // keep existing progress or set to 0.0 as desired
      if (t.progress == 1.0) t.progress = 0.0;
    }
    await _dbHelper.updateTask(t);
    await _loadTasks();
  }

  // helper to format today in same format as saved dates (dd-mm-yyyy)
  String _todayString() {
    final now = DateTime.now();
    return "${now.day}-${now.month}-${now.year}";
  }

  Color _priorityColor(String p) {
    switch (p.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'low':
        return Colors.green;
      default:
        return Colors.orange; // medium
    }
  }

  List<Task> get _allTasks => _tasks;
  List<Task> get _todayTasks =>
      _tasks.where((t) => (t.dueDate.trim().isNotEmpty && t.dueDate == _todayString())).toList();
  List<Task> get _completedTasks => _tasks.where((t) => t.isCompleted == 1).toList();
  List<Task> get _repeatedTasks => _tasks.where((t) => t.isRepeated == 1).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Today"),
            Tab(text: "Completed"),
            Tab(text: "Repeated"),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTaskList(_allTasks),
            _buildTaskList(_todayTasks),
            _buildTaskList(_completedTasks),
            _buildTaskList(_repeatedTasks),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(List<Task> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No tasks found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final t = list[index];

        final percent = (t.progress * 100).toInt();
        final priority = (t.priority.isEmpty) ? 'Medium' : t.priority;

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Left: main content (expanded)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // title + priority dot
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              t.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: t.isCompleted == 1 ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // priority dot
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _priorityColor(priority),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                priority,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),
                      // description
                      if (t.description.isNotEmpty)
                        Text(
                          t.description,
                          style: const TextStyle(fontSize: 13),
                        ),

                      const SizedBox(height: 8),
                      // date + progress %
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            t.dueDate.isEmpty ? 'No date' : t.dueDate,
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "📊 $percent%",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      // visual progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: t.progress.clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            t.progress >= 1.0
                                ? Colors.green
                                : (t.progress >= 0.5 ? Colors.orange : Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right: actions
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _goToEditTask(t),
                    ),
                    Checkbox(
                      value: t.isCompleted == 1,
                      onChanged: (_) => _toggleComplete(t),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(t),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(Task t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${t.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteTask(t.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
