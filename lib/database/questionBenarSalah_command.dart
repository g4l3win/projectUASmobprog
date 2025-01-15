import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/questionBenarSalah_model.dart';

class QuestionBenarSalahCommand {
  final DatabaseHelper dbHelper = DatabaseHelper();
// CRUD for QuestionBenarSalah (True/False)a
  Future<int> insertQuestionBenarSalah(Map<String, dynamic> question) async {
    final db = await dbHelper.database;
    return await db.insert('QuestionBenarSalah', question);
  }

  Future<List<QuestionBenarSalah>> getQuestionsBenarSalahByQuizId(int quizId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'QuestionBenarSalah',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );

    // Konversi hasil query menjadi List<QuestionBenarSalah>
    return List.generate(maps.length, (i) => QuestionBenarSalah.fromMap(maps[i]));
  }

  Future<int> updateQuestionBenarSalah(Map<String, dynamic> question,
      int questionId) async {
    final db = await dbHelper.database;
    return await db.update(
      'QuestionBenarSalah',
      question,
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  Future<int> deleteQuestionBenarSalah(int questionId) async {
    final db = await dbHelper.database;
    return await db.delete(
      'QuestionBenarSalah',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

}