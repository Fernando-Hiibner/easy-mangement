import 'dart:io';
import 'package:easy_management/model/expenses_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:uuid/uuid.dart';

import '../model/user_model.dart';

class Email {
  String _username = "";
  var smtpServer;

  Email(String username, String password) {
    _username = username;
    // ignore: deprecated_member_use
    smtpServer = gmail(_username, password);
  }

  Future<bool> sendMessage(
      String mensagem, String destinatario, String assunto) async {
    //Configurar a mensagem
    final message = Message()
      ..from = Address(_username, 'Easy Management')
      ..recipients.add(destinatario)
      ..subject = assunto
      ..text = mensagem;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());

      return true;
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }
}

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
            maxlimit DECIMAL(15, 2),
            verificationCode VARCHAR(300) NOT NULL,
            verified INTEGER NOT NULL
        );
      ''');

    await db.execute('''
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
    try {
      Database db = await instance.database;
      var users =
          await db.rawQuery('SELECT * FROM TbUsers WHERE email=?', [email]);
      List<UserModel> usersList = users.isNotEmpty
          ? users.map((c) => UserModel.fromMap(c)).toList()
          : [];
      return usersList;
    } catch (e) {
      return [];
    }
  }

  /// UE - > Usu??rio existente
  /// E  - > Erro
  /// S  - > Sucesso
  Future<String> insertUser(String email, String password) async {
    Database db = await instance.database;
    try {
      // Se o usu??rio ja estiver no sistema tem que dar xabu
      var user = await getUserByEmail(email);
      if (user.isNotEmpty) {
        return "UE";
      }

      var uuid = const Uuid();
      String verificationCode = uuid.v1();

      await db.rawQuery(
          'INSERT INTO TbUsers (email, password, maxlimit, verificationCode, verified) VALUES (?, ?, 0.0, ?, 0.0)',
          [email, password, verificationCode]);

      return "S";

      // Valida????o de conta foi de saboia por precisar de um token do firebase pra enviar email
      // var emailSender = Email('onglinkdev@gmail.com', 'Developer123');

      // return await emailSender.sendMessage(
      //     'Your verification code:\n' + verificationCode,
      //     email,
      //     'Easy Management Verification Code');
    } catch (e) {
      return "EE";
    }
  }

  Future<bool> loginUser(String email, String password) async {
    Database db = await instance.database;
    var users = await db.rawQuery(
        'SELECT * FROM TbUsers WHERE email=? AND password=?',
        [email, password]);
    return users.isNotEmpty;
  }

  Future<bool> authUser(String email) async {
    Database db = await instance.database;
    try {
      await db.rawQuery('UPDATE TbUsers SET verified=1 WHERE email=?', [email]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateMaxlimit(String email, double newLimit) async {
    Database db = await instance.database;
    try {
      await db.rawQuery(
          'UPDATE TbUsers SET maxlimit=? WHERE email=?', [newLimit, email]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<ExpensesModel>> getExpenses(int userId) async {
    Database db = await instance.database;
    var expenses = await db.rawQuery(
        'SELECT * FROM TbExpenses WHERE userId=? ORDER BY date DESC', [userId]);
    List<ExpensesModel> expensesList = expenses.isNotEmpty
        ? expenses.map((c) => ExpensesModel.fromMap(c)).toList()
        : [];
    return expensesList;
  }

  Future<bool> insertExpenses(String email, double value, DateTime date) async {
    Database db = await instance.database;
    try {
      String period = date.month.toString() + "/" + date.year.toString();
      var user = await getUserByEmail(email);

      if (user.isEmpty) return false;

      await db.rawQuery(
          'INSERT INTO TbExpenses (userId, period, date, value) VALUES (?, ?, ?, ?)',
          [user.first.id, period, date.toIso8601String(), value]);
      return true;
    } catch (e) {
      return false;
    }
  }
}
