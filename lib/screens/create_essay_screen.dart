import 'package:flutter/material.dart';
import 'package:quizdb/database/database_helper.dart';
import 'package:quizdb/models/questionEsai_model.dart'; // This should be used for the QuestionEsai class
import 'package:quizdb/models/quiz_model.dart';
import 'package:quizdb/screens/truefalse_final_screen.dart'; // This should be used for Quiz data if needed

class CreateEssayScreen extends StatefulWidget {
  @override
  _CreateEssayScreenState createState() => _CreateEssayScreenState();
}

class _CreateEssayScreenState extends State<CreateEssayScreen> {
  int? selectedQuizId; // To store the selected quiz ID
  String question = ''; // To store the question content
  String answer = ''; // To store the correct answer
  List<Map<String, dynamic>> quizzes = []; // Store quizzes from the database

  @override
  void initState() {
    super.initState();
    _fetchQuizzes(); // Fetch quizzes from the database when the screen is initialized
  }

  // Fetch all quizzes from the database
  Future<void> _fetchQuizzes() async {
    final dbHelper = DatabaseHelper();
    final allQuizzes = await dbHelper.getAllQuizzes(); // Fetch all quizzes
    final essayQuizzes = allQuizzes.where((quiz) => quiz.type == "Esai").toList();

    setState(() {
      quizzes = essayQuizzes.map((quiz) {
        return {
          'quiz_id': quiz.quizId,
          'title': quiz.title,
          'subject': quiz.subject,
        };
      }).toList();
    });
  }

  // Validate the input fields before saving
  bool validateInput() {
    if (selectedQuizId == null || question.isEmpty || answer.isEmpty) {
      return false;
    }
    return true;
  }

  // Insert the essay question into the database
  Future<void> _insertEssayQuestion() async {
    try {
      final dbHelper = DatabaseHelper();

      // Create a QuestionEsai object and convert it to map
      final questionEsai = QuestionEsai(
        quizId: selectedQuizId!,
        content: question,
        answer: answer,
      );

      await dbHelper.insertQuestionEsai(questionEsai); // Insert question into database

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Soal esai berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print("Error inserting essay question: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal menambahkan soal esai!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buat Soal Esai',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF00B1C2),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown menu for selecting quiz
              DropdownButtonFormField<int>(
                value: selectedQuizId,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedQuizId = newValue;
                  });
                },
                items: [
                  DropdownMenuItem<int>(
                    value: null,
                    child: Text('Pilih Quiz'),
                  ),
                  ...quizzes.map((quiz) {
                    return DropdownMenuItem<int>(
                      value: quiz['quiz_id'],
                      child: Text('${quiz['title']} - ${quiz['subject']}'),
                    );
                  }).toList(),
                ],
                decoration: InputDecoration(
                  labelText: 'Pilih Quiz',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Display the essay question input
              Text("Soal Esai"),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Masukkan soal esai',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {
                    question = text;
                  });
                },
              ),
              SizedBox(height: 10),

              // Display the correct answer input
              Text("Jawaban Esai"),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Masukkan jawaban esai',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {
                    answer = text;
                  });
                },
              ),
              SizedBox(height: 30),

              // Button to create the essay question
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (validateInput()) {
                      await _insertEssayQuestion(); // Insert the essay question into the database
                      Navigator.pop(context); // Go back to the previous screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TruefalseFinalScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Harap isi semua field!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text("Buat Soal Esai", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Color(0xFF00B1C2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
