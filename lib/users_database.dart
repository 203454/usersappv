import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:usersappv/features/users/data/models/user_model.dart';
import 'package:usersappv/features/users/domain/entities/user.dart';

class UsersDatabase {
  static final UsersDatabase instance = UsersDatabase._init();
  static Database? _database;

  UsersDatabase._init();

  final String tableUsers = 'tableUsers';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableUsers(
    id INTEGER PRIMARY KEY,
    name TEXT,
    username TEXT,
    last_name TEXT,
    email TEXT
    )
    ''');
  }

  Future<void> insert(UserModel item) async {
    final db = await instance.database;
    await db.insert(tableUsers, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertDataFromApi(List<UserModel> userList) async {
    final db = await instance.database;
    final batch = db.batch();
    for (final user in userList) {
      batch.insert(tableUsers, user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit();
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableUsers);

    return List.generate(maps.length, (i) {
      return UserModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        email: maps[i]['email'],
        lastName: maps[i]['last_name'],
        username: maps[i]['username'],
      );
    });
  }
}
