import 'package:flutter/material.dart';
import 'package:quizdb/database/database_helper.dart';
import 'truefalse_final_screen.dart';
import 'package:quizdb/models/question_model.dart';
import 'package:quizdb/database/question_command.dart';
import 'package:quizdb/database/quiz_command.dart';
class MultipleChoiceQuizScreen extends StatefulWidget {
  @override
  _MultipleChoiceQuizScreenState createState() =>
      _MultipleChoiceQuizScreenState();
}

class _MultipleChoiceQuizScreenState extends State<MultipleChoiceQuizScreen> {
  String OptionA = '';
  String OptionB = '';
  String OptionC = '';
  String OptionD = '';
  String question = ''; // Store one question input
  String correctAnswer = ''; // Store correct answer input
  int? selectedQuizId;
  List<Map<String, dynamic>> quizzes = []; // Store filtered quizzes from the database
  final QuizCommand quizCommand = QuizCommand();
  final QuestionCommand questionEsaiCommand = QuestionCommand();
  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  // Fetch only "Pilihan Ganda" quizzes from the database
  Future<void> _fetchQuizzes() async {
    final dbHelper = DatabaseHelper();
    final allQuizzes = await QuizCommand().getAllQuizzes();

    setState(() {
      quizzes = allQuizzes
          .where((quiz) => quiz.type == 'Pilihan Ganda') // Access `type` directly
          .map((quiz) => {
        'quiz_id': quiz.quizId, // Access properties directly
        'title': quiz.title,
        'subject': quiz.subject,
      })
          .toList();
    });
  }

  // Validate inputs before proceeding
  bool validateInput() {
    if (selectedQuizId == null) return false;
    if (question.isEmpty || correctAnswer.isEmpty) return false;
    if (OptionA.isEmpty || OptionB.isEmpty || OptionC.isEmpty || OptionD.isEmpty) return false;
    return true;
  }

  // Insert question to the databasea
  Future<void> _insertQuestion() async {
    try {

      final questionModel = Question(
        quiz_id: selectedQuizId!,
        content: question,
        optionA: OptionA,
        optionB: OptionB,
        optionC: OptionC,
        optionD: OptionD,
        answer: correctAnswer, // Save the correct answer input
      );

      await QuestionCommand().insertQuestion(questionModel);
    } catch (e) {
      print("Error inserting question: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kuis Pilihan Ganda',
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

              // Display the single question and options
              Text("Soal"),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Masukkan soal',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  question = text;
                },
              ),
              SizedBox(height: 10),

              // Display inputs for all options as text fields
              Text("Opsi A:"),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Masukkan opsi A',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {
                    OptionA = text;
                  });
                },
              ),
              SizedBox(height: 10),
              Text("Opsi B:"),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Masukkan opsi B',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {
                    OptionB = text;
                  });
                },
              ),
              SizedBox(height: 10),
              Text("Opsi C:"),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Masukkan opsi C',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {
                    OptionC = text;
                  });
                },
              ),
              SizedBox(height: 10),
              Text("Opsi D:"),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Masukkan opsi D',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {
                    OptionD = text;
                  });
                },
              ),
              SizedBox(height: 20),

              // Text field for correct answer
              Text("Jawaban yang benar:"),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Masukkan jawaban yang benar',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  setState(() {
                    correctAnswer = text;
                  });
                },
              ),
              SizedBox(height: 30),

              // Create Quiz button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (validateInput()) {
                      await _insertQuestion();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TruefalseFinalScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Harap isi semua opsi dan pilih jawaban untuk soal.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text("Buat Kuis", style: TextStyle(color: Colors.white)),
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


