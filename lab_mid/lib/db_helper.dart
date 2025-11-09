import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'task_model.dart';

class DBHelper {
  static Database? _db;
  static const String dbName = 'task_manager.db';

  // Table Names
  static const String tableTask = 'tasks';
  static const String tableSubTask = 'subtasks';

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableTask (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            dueDate TEXT,
            isCompleted INTEGER,
            isRepeated INTEGER,
            progress REAL,
            priority TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE $tableSubTask (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            taskId INTEGER,
            title TEXT,
            isDone INTEGER,
            FOREIGN KEY (taskId) REFERENCES $tableTask (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // ================= TASK CRUD ===================

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(tableTask, task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(tableTask);
    List<Task> tasks = result.map((e) => Task.fromMap(e)).toList();

    // Calculate updated progress from subtasks
    for (var task in tasks) {
      double progress = await calculateProgress(task.id!);
      task.progress = progress;
    }
    return tasks;
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      tableTask,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(tableTask, where: 'id = ?', whereArgs: [id]);
    await db.delete(tableSubTask, where: 'taskId = ?', whereArgs: [id]);
  }

  // ================= SUBTASK CRUD ===================

  Future<int> addSubTask(int taskId, String title) async {
    final db = await database;
    return await db.insert(tableSubTask, {
      'taskId': taskId,
      'title': title,
      'isDone': 0,
    });
  }

  Future<List<Map<String, dynamic>>> getSubTasks(int taskId) async {
    final db = await database;
    return await db.query(
      tableSubTask,
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
  }

  Future<void> toggleSubTask(int id, bool isDone) async {
    final db = await database;
    await db.update(
      tableSubTask,
      {'isDone': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteSubTask(int id) async {
    final db = await database;
    await db.delete(tableSubTask, where: 'id = ?', whereArgs: [id]);
  }

  // ================= PROGRESS CALCULATION ===================

  Future<double> calculateProgress(int taskId) async {
    final db = await database;
    final total = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $tableSubTask WHERE taskId = ?', [taskId]));
    if (total == 0) return 0.0;

    final done = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $tableSubTask WHERE taskId = ? AND isDone = 1',
        [taskId]));
    return done! / total!;
  }
}
