import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'task_model.dart';

class DBHelper {
  static Database? _database;
  static const String DB_NAME = 'tasks.db';
  static const String TABLE_NAME = 'tasks';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, DB_NAME);

    return await openDatabase(
      path,
      version: 3, // ✅ updated version number
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $TABLE_NAME (
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
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE $TABLE_NAME ADD COLUMN isRepeated INTEGER DEFAULT 0');
          await db.execute('ALTER TABLE $TABLE_NAME ADD COLUMN progress REAL DEFAULT 0.0');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE $TABLE_NAME ADD COLUMN priority TEXT DEFAULT "Medium"');
        }
      },
    );
  }

  // ✅ Insert task
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(TABLE_NAME, task.toMap());
  }

  // ✅ Get all tasks
  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  // ✅ Update task
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      TABLE_NAME,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // ✅ Delete task
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      TABLE_NAME,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
