import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/questionEsai_model.dart';
import 'package:quizdb/models/questionBenarSalah_model.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../models/result_model.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quiz_database.db');
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Quiz table
    await db.execute('''
    CREATE TABLE Quiz (
      quiz_id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      subject TEXT,
      type TEXT,
      timer INTEGER
    )
    ''');
    // Insert initial data into Quiz Table
    await db.execute('''
      INSERT INTO Quiz (title, subject, type, timer) VALUES 
      ('KuisPGWeb','Web Programming','Pilihan Ganda',15),
      ('KuisEsaiWeb','Web Programming','Esai',15),
      ('kuisBSweb','Web Programming','Benar/Salah',15),
      ('kuispgmoprog','Mobile Programming','Pilihan Ganda',15),
      ('kuisEsaimob','Mobile Programming','Esai',30),
      ('kuisBSmoprog','Mobile Programming','Benar/Salah',15),
      ('kuisPGalgo','Algorithm','Pilihan Ganda',15),
      ('kuisEsaialgo','Algorithm','Esai',15),
      ('kuisBSAlgo','Algorithm','Benar/Salah',30),
      ('kuisPGDB','Database Systems','Pilihan Ganda',15),
      ('kuisEsaiDB','Database Systems','Esai',15),
      ('kuisBSDB','Database Systems','Benar/Salah',30)
    ''');

    // Create Question table (multiple choice)
    await db.execute('''
    CREATE TABLE Question (
      question_id INTEGER PRIMARY KEY AUTOINCREMENT,
      quiz_id INTEGER,
      content TEXT,
      option_a TEXT,
      option_b TEXT,
      option_c TEXT,
      option_d TEXT,
      answer TEXT,
      FOREIGN KEY (quiz_id) REFERENCES Quiz (quiz_id) ON DELETE CASCADE
    )
    ''');

    // Insert initial data into Question Table
    await db.execute('''
      INSERT INTO Question (quiz_id, content, option_a, option_b, option_c, option_d, answer) VALUES
      (1,'Apa tag HTML untuk hyperlink?','<link>','<a>','<href>','<url>','<a>'),
      (1,'Apa yang digunakan untuk menerapkan gaya CSS ke HTML','<style>','<script>','<link>','<css>','<style>'),
      (1,'Apa ekstensi file PHP?','.html','.css','.php','.js','.php'),
      (4,'Apa yang dimaksud dengan widget?','komponen menyimpan data','komponen membangun UI','untuk tes aplikasi','untuk animasi','komponen membangun UI'),
      (4,'Manfaat dari menggunakan Flutter?','khusus untuk android app','framework lambat','dapat mengembangkan app di berbagai platform','tidak bisa untuk app di desktop','dapat mengembangkan app di berbagai platform'),
      (4,'Fitur yang memungkinkan pengembang untuk melihat perubahan kode secara langsung?','hot swap','hot reload','live reload','instant run','hot reload')
    ''');

    // Create Result table
    await db.execute('''
    CREATE TABLE Result (
      result_id INTEGER PRIMARY KEY AUTOINCREMENT,
      quiz_id INTEGER,
      user_id INTEGER,
      score REAL,
      FOREIGN KEY (quiz_id) REFERENCES Quiz (quiz_id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES Mahasiswa (user_id) ON DELETE CASCADE
    )
    ''');

    // Insert sample data into Result table
    await db.execute('''
      INSERT INTO Result (quiz_id, user_id, score) VALUES
      (1, 82501, 100),
      (1, 82502, 66),
      (1, 82503, 33),
      (2, 82506, 100),
      (2, 82507, 100),
      (2, 82508, 66),
      (3, 82501, 0),
      (3, 82503, 66),
      (3, 82505, 0),
      (4, 82502, 33),
      (4, 82504, 66),
      (4, 82506, 100),
      (5, 82501, 66),
      (5, 82502, 66),
      (5, 82505, 33),
      (6, 82502, 100),
      (6, 82506, 66),
      (6, 82507, 100)
    ''');

    // Create Mahasiswa (Student) table
    await db.execute('''
    CREATE TABLE Mahasiswa (
      user_id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )
    ''');

    await db.execute(
        "INSERT INTO Mahasiswa (user_id, name) VALUES (82501, 'Rudi');");
    await db.execute(
        "INSERT INTO Mahasiswa (user_id, name) VALUES (82502, 'Siti');");
    await db.execute(
        "INSERT INTO Mahasiswa (user_id, name) VALUES (82503, 'Andi');");
    await db.execute(
        "INSERT INTO Mahasiswa (user_id, name) VALUES (82504, 'Dewi');");
    await db.execute(
        "INSERT INTO Mahasiswa (user_id, name) VALUES (82505, 'Budi');");
    await db.execute(
        "INSERT INTO Mahasiswa (user_id, name) VALUES (82506, 'Fitri');");
    await db.execute(
        "INSERT INTO Mahasiswa (user_id, name) VALUES (82507, 'Joko');");
    await db.execute(
        "INSERT INTO Mahasiswa (user_id, name) VALUES (82508, 'Nina');");
    await db.execute(
        "INSERT INTO Mahasiswa (user_id, name) VALUES (82509, 'Tono');");
    await db.execute(
        "INSERT INTO Mahasiswa (user_id, name) VALUES (82510, 'Lina');");

    // Create QuestionEsai (Essay Question) table
    await db.execute('''
    CREATE TABLE QuestionEsai (
      question_id INTEGER PRIMARY KEY AUTOINCREMENT,
      quiz_id INTEGER,
      content TEXT,
      answer TEXT,
      FOREIGN KEY (quiz_id) REFERENCES Quiz (quiz_id) ON DELETE CASCADE
    )
    ''');

    // Insert initial data into QuestionEsai Table
    await db.execute('''
      INSERT INTO QuestionEsai (quiz_id, content, answer) VALUES
      (2,'Apa singkatan dari HyperText Markup Language?','HTML'),
      (2,'Fungsi untuk menampilkan output di PHP','echo'),
      (2,'Untuk mengakhiri sebuah baris perintah di PHP, kita menggunakan simbol',';'),
      (5,'Apa bahasa pemrograman yang digunakan untuk Flutter?','dart'),
      (5,'Apa widget yang digunakan untuk menampilkan teks?','text'),
      (5,'Apa nama alat untuk mengembangkan aplikasi Flutter?','flutter sdk')
    ''');

    // Create QuestionBenarSalah (True/False Question) table
    await db.execute('''
    CREATE TABLE QuestionBenarSalah (
      question_id INTEGER PRIMARY KEY AUTOINCREMENT,
      quiz_id INTEGER,
      content TEXT,
      answer TEXT,
      FOREIGN KEY (quiz_id) REFERENCES Quiz (quiz_id) ON DELETE CASCADE
    )
    ''');

    // Insert initial data into QuestionBenarSalah Table
    await db.execute('''
      INSERT INTO QuestionBenarSalah (quiz_id, content, answer) VALUES
      (3,'jawabannya benar','Benar'),
      (3,'jawabannya salah','Salah'),
      (6,'hot reload sangat mudah digunakan','Benar'),
      (6,'widget adalah elemen untuk membangun UI.','Benar'),
      (6,'Flutter adalah framework untuk aplikasi Android.','Salah')
    ''');


      await db.execute(
          'CREATE TABLE user('
              'userid INTEGER PRIMARY KEY AUTOINCREMENT, '
              'username TEXT NOT NULL, '
              'password TEXT NOT NULL);');
  }

  // CRUD for Quiz table
  Future<int> insertQuiz(Quiz quiz) async {
    final db = await database;
    return await db.insert('Quiz', quiz.toMap());
  }

  Future<List<Quiz>> getAllQuizzes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Quiz');
    return List.generate(maps.length, (i) => Quiz.fromMap(maps[i]));
  }

  Future<Map<String, Object?>?> getQuizById(int quizId) async {
    final db = await database;
    final result = await db.query(
      'Quiz',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
      limit: 1, // Membatasi hasil hanya satu data
    );
    return result.isNotEmpty ? result.first : null;
  }
  

  Future<int> updateQuiz(Quiz quiz) async {
    final db = await database;
    return await db.update(
      'Quiz',
      quiz.toMap(),
      where: 'quiz_id = ?',
      whereArgs: [quiz.quizId],
    );
  }

  Future<int> deleteQuiz(int id) async {
    final db = await database;
    return await db.delete(
      'Quiz',
      where: 'quiz_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllQuizzes() async {
    final db = await database;
    await db.delete('Quiz'); // Delete all quizzes
  }

  // CRUD for Question (multiple choice)
  Future<int> insertQuestion(Question question) async {
    final db = await database;
    return await db.insert('Question', question.toMap());
  }

  Future<List<Question>> getQuestionsByQuizId(int quizId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Question',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );
    return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
  }

  Future<int> updateQuestion(Question question) async {
    final db = await database;
    return await db.update(
      'Question',
      question.toMap(),
      where: 'question_id = ?',
      whereArgs: [question.questionId],
    );
  }

  Future<int> deleteQuestion(int id) async {
    final db = await database;
    return await db.delete(
      'Question',
      where: 'question_id = ?',
      whereArgs: [id],
    );
  }

  // CRUD for QuestionBenarSalah (True/False)
  Future<int> insertQuestionBenarSalah(Map<String, dynamic> question) async {
    final db = await database;
    return await db.insert('QuestionBenarSalah', question);
  }

  Future<List<QuestionBenarSalah>> getQuestionsBenarSalahByQuizId(int quizId) async {
    final db = await database;
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
    final db = await database;
    return await db.update(
      'QuestionBenarSalah',
      question,
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  Future<int> deleteQuestionBenarSalah(int questionId) async {
    final db = await database;
    return await db.delete(
      'QuestionBenarSalah',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  // CRUD for QuestionEsai (Essay)
  Future<void> insertQuestionEsai(QuestionEsai questionEsai) async {
    final db = await database;
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
    final db = await database;
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
    final db = await database;
    return await db.update(
      'QuestionEsai',
      questionEsai,
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  Future<int> deleteQuestionEsai(int questionId) async {
    final db = await database;
    return await db.delete(
      'QuestionEsai',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  // CRUD for Result table
  Future<int> insertResult(Result result) async {
    final db = await database;
    return await db.insert('Result', result.toMap());
  }

  Future<List<Result>> getResultsByQuizId(int quizId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Result',
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );
    return List.generate(maps.length, (i) => Result.fromMap(maps[i]));
  }

  Future<int> updateResult(Result result) async {
    final db = await database;
    return await db.update(
      'Result',
      result.toMap(),
      where: 'result_id = ?',
      whereArgs: [result.resultId],
    );
  }

  Future<int> deleteResult(int id) async {
    final db = await database;
    return await db.delete(
      'Result',
      where: 'result_id = ?',
      whereArgs: [id],
    );
  }


  Future<Map<String, dynamic>> getQuizWithQuestions(int quizId) async {
    final db = await database;

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

  //dapat data mahasiswa
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('Mahasiswa');
  }


  Future<List<String>> getQuizByTypeAndSubject(String type,
      String subject) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM Quiz WHERE type = ? AND subject = ?
    ''', [type, subject]);

    return List<String>.from(maps.map((map) => map['title']));
  }

  // Mendapatkan list score berdasarkan quiz_id dari tabel Result
  Future<List<int>> getScoresByQuizId(int quizId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT Result.score FROM Result
    WHERE Result.quiz_id = ?
  ''', [quizId]);

    // Convert each score to an integer
    return List<int>.from(maps.map((map) => (map['score'] as num).toInt()));
  }

// Mendapatkan total jumlah siswa per quiz_id
  Future<int> getTotalStudentsByQuizId(int quizId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT COUNT(DISTINCT user_id) as total_students FROM Result
    WHERE quiz_id = ? 
  ''', [quizId]);

    return maps.first['total_students'] as int;
  }

}
