import 'package:flutter/material.dart';
import 'package:quizdb/database/database_helper.dart';

import 'pilihanganda.dart';
import 'benarsalah.dart';
import 'isian.dart';

class QuizHomePage extends StatefulWidget {
  final String subject; // Receives subject from the previous page

  QuizHomePage({required this.subject});

  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  List<Map<String, dynamic>> quizList = [];

  @override
  void initState() {
    super.initState();
    _fetchQuizzesBySubject();
  }

  // Fetch quizzes based on the selected subject
  Future<void> _fetchQuizzesBySubject() async {
    final dbHelper = DatabaseHelper();
    final quizzes = await dbHelper.getAllQuizzes();
    final subjectQuizzes = quizzes.where((quiz) => quiz.subject == widget.subject).toList();

    setState(() {
      quizList = subjectQuizzes.map((quiz) {
        return {
          'quiz_id': quiz.quizId,
          'title': quiz.title,
          'type': quiz.type,
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00B1C2),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                "Quizzes for ${widget.subject}",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // List of buttons for each quiz title
              ...quizList.map((quiz) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate based on quiz type
                        if (quiz['type'] == 'Pilihan Ganda') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Pilihanganda(quizId: quiz['quiz_id'])
                            ),
                          );
                        } else if (quiz['type'] == 'Benar/Salah') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrueFalseQuiz(
                                quizId: quiz['quiz_id'],
                              ),
                            ),
                          );
                        } else if (quiz['type'] == 'Esai') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EssayQuiz(
                                quizId: quiz['quiz_id'],
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3B547A),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        quiz['title'],
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFFFD801),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "${widget.subject} Quizzes",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF3B547A),
      ),
    );
  }
}