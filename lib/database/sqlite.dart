import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../model/user_model.dart';

class SQLiteHelper {
  SQLiteHelper._privateConstructor();
  static final SQLiteHelper instance = SQLiteHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'easy_management.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE TbUsers (
            id INTEGER PRIMARY KEY,
            email VARCHAR(200) UNIQUE NOT NULL,
            password VARCHAR(200) NOT NULL,
            limit DECIMAL(15, 2),
            verificationCode VARCHAR(300) NOT NULL,
            verified INTEGER NOT NULL
        );
      ''');

    await db.execute(''']
    CREATE TABLE TbExpenses (
            id INTEGER PRIMARY KEY,
            userId INTEGER,
            period VARCHAR(8) NOT NULL,
            date DATETIME NOT NULL,
            value DECIMAL(15, 2) NOT NULL,

            FOREIGN KEY(userId) REFERENCES User(userId)
        );
    ''');
  }

  Future<List<UserModel>> getUsers() async {
    Database db = await instance.database;
    var users = await db.query('TbUsers', orderBy: 'id');
    List<UserModel> usersList =
        users.isNotEmpty ? users.map((c) => UserModel.fromMap(c)).toList() : [];
    return usersList;
  }

  Future<List<UserModel>> getUserByEmail(String email) async {
    Database db = await instance.database;
    var users =
        await db.rawQuery('SELECT * FROM TbUsers WHERE email=?', [email]);
    List<UserModel> usersList =
        users.isNotEmpty ? users.map((c) => UserModel.fromMap(c)).toList() : [];
    return usersList;
  }

  Future<bool> insertUser(
      String email, String password, String verificationCode) async {
    Database db = await instance.database;
    try {
      await db.rawQuery(
          'INSERT INTO TbUsers (email, password, limit, verificationCode, verified) VALUES (\'?\', \'?\', 0, \'?\', 0)',
          [email, password, verificationCode]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<UserModel>> loginUser(String email, String password) async {
    Database db = await instance.database;
    var users = await db.rawQuery(
        'SELECT * FROM TbUsers WHERE email=\'?\' AND password=\'?\'',
        [email, password]);
    List<UserModel> usersList =
        users.isNotEmpty ? users.map((c) => UserModel.fromMap(c)).toList() : [];
    return usersList;
  }

  // https://youtu.be/noi6aYsP7Go?t=460
  Future<bool> authUser(String email) async {
    Database db = await instance.database;
    try {
      await db
          .rawQuery('UPDATE TbUsers SET verified=1 WHERE email=\'?\'', [email]);
      return true;
    } catch (e) {
      return false;
    }
  }
}
