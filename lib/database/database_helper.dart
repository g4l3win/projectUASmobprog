import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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
    // Insert initial data into Quiz Tablea
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
}
