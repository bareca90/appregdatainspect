// core/services/local_db_service.dart
import 'package:appregdatainspect/models/reference_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDbService {
  static const String _dbName = 'inspection_db.db';
  static const int _dbVersion = 1;
  static const String _tableName =
      'inspection_references'; // Cambiado de 'references'

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        reference INTEGER PRIMARY KEY,
        client TEXT,
        containerNumber TEXT,
        loadingArea TEXT,
        releaseStartDate TEXT,
        releaseStartTime TEXT,
        releaseFinishDate TEXT,
        releaseFinishTime TEXT,
        sampleStartDate TEXT,
        sampleStartTime TEXT,
        sampleFinishDate TEXT,
        sampleFinishTime TEXT,
        stampedDate TEXT,
        stampedTime TEXT,
        releaseTemperature REAL,
        sampleTemperature REAL,
        stampedTemperature REAL,
        isSynced INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> saveReferences(List<Reference> references) async {
    final db = await database;
    final batch = db.batch();

    for (final ref in references) {
      batch.insert(
        _tableName,
        ref.toJson()..['isSynced'] = ref.isSynced ? 1 : 0,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  Future<List<Reference>> getReferences() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Reference(
        reference: maps[i]['reference'],
        client: maps[i]['client'],
        containerNumber: maps[i]['containerNumber'],
        loadingArea: maps[i]['loadingArea'],
        releaseStartDate: maps[i]['releaseStartDate'] != null
            ? DateTime.parse(maps[i]['releaseStartDate'])
            : null,
        releaseStartTime: maps[i]['releaseStartTime'],
        releaseFinishDate: maps[i]['releaseFinishDate'] != null
            ? DateTime.parse(maps[i]['releaseFinishDate'])
            : null,
        releaseFinishTime: maps[i]['releaseFinishTime'],
        sampleStartDate: maps[i]['sampleStartDate'] != null
            ? DateTime.parse(maps[i]['sampleStartDate'])
            : null,
        sampleStartTime: maps[i]['sampleStartTime'],
        sampleFinishDate: maps[i]['sampleFinishDate'] != null
            ? DateTime.parse(maps[i]['sampleFinishDate'])
            : null,
        sampleFinishTime: maps[i]['sampleFinishTime'],
        stampedDate: maps[i]['stampedDate'] != null
            ? DateTime.parse(maps[i]['stampedDate'])
            : null,
        stampedTime: maps[i]['stampedTime'],
        releaseTemperature: maps[i]['releaseTemperature']?.toDouble(),
        sampleTemperature: maps[i]['sampleTemperature']?.toDouble(),
        stampedTemperature: maps[i]['stampedTemperature']?.toDouble(),
        isSynced: maps[i]['isSynced'] == 1,
      );
    });
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
