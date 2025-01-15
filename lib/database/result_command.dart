import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/result_model.dart';

class ResultCommand {
  final DatabaseHelper dbHelper = DatabaseHelper();
  // CRUD for Result table
  Future<int> insertResult(Result result) async {
    final db = await dbHelper.database;
    return await db.insert('Result', result.toMap());
  }

  Future<List<Result>> getResultsByQuizId(int quizId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Result',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );
    return List.generate(maps.length, (i) => Result.fromMap(maps[i]));
  }

  Future<int> updateResult(Result result) async {
    final db = await dbHelper.database;
    return await db.update(
      'Result',
      result.toMap(),
      where: 'result_id = ?',
      whereArgs: [result.resultId],
    );
  }

  Future<int> deleteResult(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'Result',
      where: 'result_id = ?',
      whereArgs: [id],
    );
  }

  // Mendapatkan list score berdasarkan quiz_id dari tabel Result
  Future<List<int>> getScoresByQuizId(int quizId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT Result.score FROM Result
    WHERE Result.quiz_id = ?
  ''', [quizId]);

    // Convert each score to an integer
    return List<int>.from(maps.map((map) => (map['score'] as num).toInt()));
  }

// Mendapatkan total jumlah siswa per quiz_id
  Future<int> getTotalStudentsByQuizId(int quizId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT COUNT(DISTINCT user_id) as total_students FROM Result
    WHERE quiz_id = ? 
  ''', [quizId]);

    return maps.first['total_students'] as int;
  }
}