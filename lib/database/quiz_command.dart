import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/quiz_model.dart';

class QuizCommand {
  final DatabaseHelper dbHelper = DatabaseHelper();

// CRUD for Quiz tablea
  Future<int> insertQuiz(Quiz quiz) async {
    final db = await dbHelper.database;
    return await db.insert('Quiz', quiz.toMap());
  }

  Future<List<Quiz>> getAllQuizzes() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Quiz');
    return List.generate(maps.length, (i) => Quiz.fromMap(maps[i]));
  }

  Future<Map<String, Object?>?> getQuizById(int quizId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'Quiz',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
      limit: 1, // Membatasi hasil hanya satu data
    );
    return result.isNotEmpty ? result.first : null;
  }


  Future<int> updateQuiz(Quiz quiz) async {
    final db = await dbHelper.database;
    return await db.update(
      'Quiz',
      quiz.toMap(),
      where: 'quiz_id = ?',
      whereArgs: [quiz.quizId],
    );
  }

  Future<int> deleteQuiz(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'Quiz',
      where: 'quiz_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllQuizzes() async {
    final db = await dbHelper.database;
    await db.delete('Quiz'); // Delete all quizzes
  }

  Future<Map<String, dynamic>> getQuizWithQuestions(int quizId) async {
    final db = await dbHelper.database;

    // Join Quiz and Question tables
    final quizData = await db.rawQuery('''
    SELECT * FROM Quiz WHERE quiz_id = ?
  ''', [quizId]);

    if (quizData.isEmpty) {
      return {}; // If no quiz data, return an empty map
    }

    // Get the associated questions
    final questionsData = await db.rawQuery('''
    SELECT * FROM Question WHERE quiz_id = ?
  ''', [quizId]);

    // Return the quiz and questions as a map
    return {
      'quiz': quizData.first,
      'questions': questionsData,
    };
  }


  Future<List<String>> getQuizByTypeAndSubject(String type,
      String subject) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM Quiz WHERE type = ? AND subject = ?
    ''', [type, subject]);

    return List<String>.from(maps.map((map) => map['title']));
  }
}