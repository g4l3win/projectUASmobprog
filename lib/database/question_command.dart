import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/question_model.dart';
class QuestionCommand {
  final DatabaseHelper dbHelper = DatabaseHelper();

// CRUD for Question (multiple choice)a
  Future<int> insertQuestion(Question question) async {
    final db = await dbHelper.database;
    return await db.insert('Question', question.toMap());
  }

  Future<List<Question>> getQuestionsByQuizId(int quizId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Question',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );
    return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
  }

  Future<int> updateQuestion(Question question) async {
    final db = await dbHelper.database;
    return await db.update(
      'Question',
      question.toMap(),
      where: 'question_id = ?',
      whereArgs: [question.questionId],
    );
  }

  Future<int> deleteQuestion(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'Question',
      where: 'question_id = ?',
      whereArgs: [id],
    );
  }
}