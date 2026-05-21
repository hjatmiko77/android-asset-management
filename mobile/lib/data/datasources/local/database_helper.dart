import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'asset_management.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        fullname TEXT,
        role TEXT DEFAULT 'user',
        is_active INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Assets table
    await db.execute('''
      CREATE TABLE assets (
        id INTEGER PRIMARY KEY,
        organization TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        location TEXT,
        building TEXT,
        systems TEXT,
        sub_systems TEXT,
        asset_code_lv5 TEXT,
        desc_lv5 TEXT,
        asset_code_lv6 TEXT,
        desc_lv6 TEXT,
        asset_code_lv7 TEXT,
        desc_lv7 TEXT,
        kode_aset TEXT UNIQUE NOT NULL,
        asset_category TEXT,
        merk TEXT,
        serial_number TEXT,
        model TEXT,
        installed_date TEXT,
        warranty_date TEXT,
        capex_opex TEXT,
        kepemilikan TEXT,
        kondisi TEXT,
        detail_kondisi TEXT,
        fungsi_utama TEXT,
        photo_asset TEXT,
        photo_label TEXT,
        created_by INTEGER,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        is_deleted INTEGER DEFAULT 0,
        sync_status TEXT DEFAULT 'pending'
      )
    ''');

    // Sync queue table
    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY,
        action TEXT NOT NULL,
        resource TEXT NOT NULL,
        resource_id INTEGER,
        payload TEXT,
        status TEXT DEFAULT 'pending',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        synced_at TEXT
      )
    ''');
  }

  // Asset operations
  Future<int> insertAsset(Map<String, dynamic> asset) async {
    final db = await database;
    return await db.insert('assets', asset);
  }

  Future<List<Map<String, dynamic>>> getAssets({String? search}) async {
    final db = await database;
    if (search != null && search.isNotEmpty) {
      return await db.query(
        'assets',
        where: 'is_deleted = 0 AND (kode_aset LIKE ? OR merk LIKE ? OR serial_number LIKE ?)',
        whereArgs: ['%$search%', '%$search%', '%$search%'],
      );
    }
    return await db.query('assets', where: 'is_deleted = 0');
  }

  Future<Map<String, dynamic>?> getAssetById(int id) async {
    final db = await database;
    final result = await db.query('assets', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getAssetBySerialNumber(String serialNumber) async {
    final db = await database;
    final result = await db.query(
      'assets',
      where: 'serial_number = ? AND is_deleted = 0',
      whereArgs: [serialNumber],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateAsset(int id, Map<String, dynamic> asset) async {
    final db = await database;
    asset['updated_at'] = DateTime.now().toIso8601String();
    return await db.update('assets', asset, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAsset(int id) async {
    final db = await database;
    return await db.update(
      'assets',
      {'is_deleted': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Sync queue operations
  Future<int> insertSyncQueue(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('sync_queue', item);
  }

  Future<List<Map<String, dynamic>>> getPendingSyncItems() async {
    final db = await database;
    return await db.query('sync_queue', where: 'status = ?', whereArgs: ['pending']);
  }

  Future<int> updateSyncStatus(int id, String status) async {
    final db = await database;
    return await db.update(
      'sync_queue',
      {'status': status, 'synced_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('assets');
    await db.delete('sync_queue');
  }
}
