import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/questionEsai_model.dart';

class QuestionEsaiCommand {
  final DatabaseHelper dbHelper = DatabaseHelper();

  // CRUD for QuestionEsai (Esaia)
  Future<void> insertQuestionEsai(QuestionEsai questionEsai) async {
    final db = await dbHelper.database;
    try {
      await db.insert(
        'QuestionEsai',
        questionEsai.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting QuestionEsai: $e");
    }
  }

  Future<List<QuestionEsai>> getQuestionsEsaiByQuizId(int quizId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'QuestionEsai',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );

    // Ubah ke List<QuestionEsai>
    return List.generate(maps.length, (i) => QuestionEsai.fromMap(maps[i]));
  }


  Future<int> updateQuestionEsai(Map<String, dynamic> questionEsai,
      int questionId) async {
    final db = await dbHelper.database;
    return await db.update(
      'QuestionEsai',
      questionEsai,
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  Future<int> deleteQuestionEsai(int questionId) async {
    final db = await dbHelper.database;
    return await db.delete(
      'QuestionEsai',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

}