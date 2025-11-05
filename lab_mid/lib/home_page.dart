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
  List<Task> tasks = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await _dbHelper.getTasks();
    setState(() => tasks = data);
  }

  void _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    _loadTasks();
  }

  void _toggleComplete(Task t) async {
    t.isCompleted = t.isCompleted == 0 ? 1 : 0;
    await _dbHelper.updateTask(t);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = tasks;
    final completedTasks = tasks.where((t) => t.isCompleted == 1).toList();
    final pendingTasks = tasks.where((t) => t.isCompleted == 0).toList();
    final repeatedTasks = tasks.where((t) => t.isRepeated == 1).toList();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
              Tab(text: "Completed"),
              Tab(text: "Pending"),
              Tab(text: "Repeated"),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTaskList(allTasks),
              _buildTaskList(completedTasks),
              _buildTaskList(pendingTasks),
              _buildTaskList(repeatedTasks),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTaskPage()),
            );
            _loadTasks();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No tasks found.'));
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final t = list[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              t.title,
              style: TextStyle(
                decoration: t.isCompleted == 1 ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.description),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14),
                    const SizedBox(width: 4),
                    Text(t.dueDate),
                  ],
                ),
                const SizedBox(height: 4),
                Text("📊 Progress: ${(t.progress * 100).toInt()}%"),
              ],
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTaskPage(task: t),
                      ),
                    );
                    _loadTasks(); // Refresh after edit
                  },
                ),
                Checkbox(
                  value: t.isCompleted == 1,
                  onChanged: (v) => _toggleComplete(t),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(t.id!),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
