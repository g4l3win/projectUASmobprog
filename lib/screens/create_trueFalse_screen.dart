import 'package:flutter/material.dart';
import 'package:quizdb/database/database_helper.dart';
import 'package:quizdb/models/questionBenarSalah_model.dart';
import 'package:quizdb/screens/truefalse_final_screen.dart'; // Screen to navigate after saving

class CreateTrueFalseScreen extends StatefulWidget {
  @override
  _CreateTrueFalseScreenState createState() => _CreateTrueFalseScreenState();
}

class _CreateTrueFalseScreenState extends State<CreateTrueFalseScreen> {
  int? selectedQuizId; // To store the selected quiz ID
  String questionContent = ''; // To store the question content
  String answer = ''; // To store the correct answer (either "true" or "false")
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
    final trueFalseQuizzes = allQuizzes.where((quiz) => quiz.type == "Benar/Salah").toList();
    setState(() {
      quizzes = trueFalseQuizzes.map((quiz) {
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
    if (selectedQuizId == null || questionContent.isEmpty || answer.isEmpty) {
      return false;
    }
    return true;
  }

  // Insert the true/false question into the database
  Future<void> _insertTrueFalseQuestion() async {
    try {
      final dbHelper = DatabaseHelper();

      // Create a QuestionBenarSalah object and convert it to map
      final questionBenarSalah = QuestionBenarSalah(
        quizId: selectedQuizId!,
        content: questionContent,
        answer: answer,
      );

      await dbHelper.insertQuestionBenarSalah(questionBenarSalah.toMap()); // Insert question into database

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Soal benar/salah berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print("Error inserting true/false question: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal menambahkan soal benar/salah!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buat Soal Benar/Salah',
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

              // Display the true/false question input
              Text("Soal Benar/Salah"),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Masukkan soal benar/salah',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {
                    questionContent = text;
                  });
                },
              ),
              SizedBox(height: 10),

              // Display radio buttons for selecting the answer
              Text("Jawaban yang benar"),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text("Benar"),
                      value: 'Benar',
                      groupValue: answer,
                      onChanged: (value) {
                        setState(() {
                          answer = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text("Salah"),
                      value: 'Salah',
                      groupValue: answer,
                      onChanged: (value) {
                        setState(() {
                          answer = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Button to create the true/false question
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (validateInput()) {
                      await _insertTrueFalseQuestion(); // Insert the true/false question into the database
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
                  child: Text("Buat Soal Benar/Salah", style: TextStyle(color: Colors.white)),
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
