import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';

final String tableName = 'users';
final String colId = 'id';
final String colName = 'name';
final String colPhone = 'phone';
final String colEmail = 'email';

class DatabaseHandler {
  static final _databaseName = 'user_database.db';
  static final _databaseVersion = 1;

  // Make this a Singleton class because we only want one single instance of
  // this class for the whole application
  DatabaseHandler._privateConstructor();
  static final DatabaseHandler instance = DatabaseHandler._privateConstructor();

  // Allow only a single connection to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    final String? _path = await getDatabasesPath();
    if (_path == null) return Future.error('Couldn\'t get the default database location');

    return openDatabase(
      join(_path, _databaseName),
      onCreate: _onCreate,
      version: _databaseVersion,
    );
  }

  // Create the table with the necessary columns when a database is created
  Future<void> _onCreate(Database db, int version) async {
    return db.execute(
      'CREATE TABLE $tableName ($colId INTEGER PRIMARY KEY, $colName TEXT NOT NULL, $colEmail TEXT NOT NULL, $colPhone TEXT NOT NULL)',
    );
  }

  // Get a particular user based on the query
  Future<User?> getUser({required String queryColName, required dynamic queryValue}) async {
    final Database db = await database;
    List<Map<String, dynamic>> userMaps = await db.query(
      tableName,
      columns: [colId, colName, colEmail, colPhone],
      where: '$queryColName = ?',
      whereArgs: [queryValue],
    );

    if (userMaps.isEmpty)
      return null;
    else
      return User.fromJson(userMaps.first);
  }

  // Get list of all users in the database
  Future<List<User>> getUsers() async {
    final Database db = await database;
    List<Map<String, dynamic>> userMaps = await db.query(tableName);

    return List.generate(
      userMaps.length,
      (i) => User.fromJson(userMaps[i]),
    );
  }

  // Insert a new user to the table 
  Future<int> insert(User user) async {
    final Database db = await database;
    return await db.insert(
      tableName,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update an existing user in the table
  Future<int> update({required User user, String? whereColName, dynamic? argument}) async {
    final Database db = await database;
    return await db.update(
      tableName,
      user.toJson(),
      where: whereColName != null ? '$whereColName = ?' : null,
      whereArgs: argument != null ? [argument] : null,
    );
  }

  // Delete a user from the table based on the query 
  Future delete({String? whereColName, dynamic? argument}) async {
    final Database db = await database;
    return await db.delete(
      tableName,
      where: whereColName != null ? '$whereColName = ?' : null,
      whereArgs: argument != null ? [argument] : null,
    );
  }
}
