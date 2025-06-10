import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:reporting/models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        time TEXT NOT NULL,
        date TEXT NOT NULL,
        status TEXT NOT NULL,
        type TEXT
      )
    ''');
  }

  Future<void> insertTask(Task task) async {
    final db = await instance.database;
    await db.insert('tasks', {
      'id': task.id,
      'title': task.title,
      'time': task.time,
      'date': task.date.toIso8601String(),
      'status': task.status.toString().split('.').last,
      'type': task.type,
    });
  }

  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');

    return result.map((json) {
      return Task(
        id: json['id'] as String,
        title: json['title'] as String,
        time: json['time'] as String,
        date: DateTime.parse(json['date'] as String),
        status: TaskStatus.values.firstWhere(
          (e) => e.toString() == 'TaskStatus.${json['status']}',
        ),
        tags: [], // Tags need to be handled separately
        type: json['type'] as String?,
      );
    }).toList();
  }
}
