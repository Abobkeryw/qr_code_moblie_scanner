import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'qr_codes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE qr_codes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        value TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // Insert a new QR code
  Future<int> insertQrCode(String value, String timestamp) async {
    final db = await database;
    return await db.insert('qr_codes', {
      'value': value,
      'timestamp': timestamp,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Get all QR codes ordered by timestamp (newest first)
  Future<List<Map<String, dynamic>>> getAllQrCodes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'qr_codes',
      orderBy: 'timestamp DESC',
    );
    return maps;
  }

  // Delete a QR code by ID
  Future<int> deleteQrCode(int id) async {
    final db = await database;
    return await db.delete(
      'qr_codes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all QR codes
  Future<int> deleteAllQrCodes() async {
    final db = await database;
    return await db.delete('qr_codes');
  }

  // Get QR code by ID
  Future<Map<String, dynamic>?> getQrCodeById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'qr_codes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? maps.first : null;
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
} 