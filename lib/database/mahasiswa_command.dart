import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/mahasiswa_model.dart';

class MahasiswaCommand {
  final DatabaseHelper dbHelper = DatabaseHelper(); //GUNAKAN INSTANCE
//dapat data mahasiswa
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await dbHelper.database; //AKSES DATABASE dari databasehelper
    return await db.query('Mahasiswa');
  }

//insert mahasiswa
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await dbHelper.database;
    return await db.insert('Mahasiswa', user); // insert data ke tabel mahasiswa
  }

//update mahasiswaa
  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await dbHelper.database;
    return await db.update(
      'Mahasiswa',
      user,
      where: 'user_id = ?',
      whereArgs: [user['user_id']], // kondisi berdasarkan user_id
    );
  }

//delete mahasiswa
  Future<int> deleteUser(int userId) async {
    final db = await dbHelper.database;
    return await db.delete(
      'Mahasiswa',
      where: 'user_id = ?',
      whereArgs: [userId], //kondisi berdasarkan user id
    );
  }
}
