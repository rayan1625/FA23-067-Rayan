import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/patient.dart';
import '../models/visit.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'dr_assistant.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patients(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        dateOfBirth TEXT NOT NULL,
        gender TEXT NOT NULL,
        address TEXT NOT NULL,
        notes TEXT,
        imagePath TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE visits(
        id TEXT PRIMARY KEY,
        patientId TEXT NOT NULL,
        patientName TEXT NOT NULL,
        date TEXT NOT NULL,
        symptoms TEXT NOT NULL,
        diagnosis TEXT NOT NULL,
        treatment TEXT,
        notes TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (patientId) REFERENCES patients (id)
      )
    ''');
  }

  // PATIENTS
  Future<int> insertPatient(Patient patient) async {
    final db = await database;
    return await db.insert('patients', patient.toJson());
  }

  Future<List<Patient>> getAllPatients() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('patients');
    return List.generate(maps.length, (i) => Patient.fromJson(maps[i]));
  }

  // VISITS
  Future<int> insertVisit(Visit visit) async {
    final db = await database;
    return await db.insert('visits', visit.toJson());
  }

  Future<List<Visit>> getVisitsByPatient(String patientId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'visits',
      where: 'patientId = ?',
      whereArgs: [patientId],
    );
    return List.generate(maps.length, (i) => Visit.fromJson(maps[i]));
  }

  Future<List<Visit>> getAllVisits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('visits');
    return List.generate(maps.length, (i) => Visit.fromJson(maps[i]));
  }

  // EXPORT JSON
  Future<Map<String, dynamic>> exportData() async {
    final patients = await getAllPatients();
    final visits = await getAllVisits();
    return {
      'patients': patients.map((p) => p.toJson()).toList(),
      'visits': visits.map((v) => v.toJson()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  // CLEAR ALL
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('visits');
    await db.delete('patients');
    }
}
