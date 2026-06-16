import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;

  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'feedback.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            uid TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            contact TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE feedback (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            device_owner TEXT NOT NULL,
            user_name TEXT NOT NULL,
            user_email TEXT NOT NULL,
            user_contact TEXT NOT NULL,
            bug_description TEXT NOT NULL,
            user_device TEXT NOT NULL,
            media_links TEXT,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // USER METHODS
  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    required String contact,
  }) async {
    final db = await database;
    await db.insert(
      'users',
      {'uid': uid, 'name': name, 'email': email, 'contact': contact},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final db = await database;
    final result = await db.query('users', where: 'uid = ?', whereArgs: [uid]);
    return result.isNotEmpty ? result.first : null;
  }

  // FEEDBACK METHODS
  Future<void> saveFeedback({
    required String deviceOwner,
    required String userName,
    required String userEmail,
    required String userContact,
    required String bugDescription,
    required String userDevice,
    String? mediaLinks,
  }) async {
    final db = await database;
    await db.insert('feedback', {
      'device_owner': deviceOwner,
      'user_name': userName,
      'user_email': userEmail,
      'user_contact': userContact,
      'bug_description': bugDescription,
      'user_device': userDevice,
      'media_links': mediaLinks ?? '',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllFeedback() async {
    final db = await database;
    return db.query('feedback', orderBy: 'created_at DESC');
  }
}