import 'database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:quizdb/models/user.dart';

class UserCommand {
  Future<int> insertUser(User user) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Database db = await dbHelper.database;
    return await db.insert('user', user.toMap());
  }

  Future<User?> signIn(String email, String password) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db.query('user',
        where: 'username = ? AND password = ?', whereArgs: [email, password]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Database db = await dbHelper.database;
    return await db.update('user', user.toMap(),
        where: 'userid = ?', whereArgs: [user.userid]);
  }

  Future<List<User>> getUser() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> allUser = await db.query('user');
    List<User> users = allUser.map((user) => User.fromMap(user)).toList();
    return users;
  }
}