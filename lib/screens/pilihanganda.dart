import 'package:flutter/material.dart';
import 'dart:async';
import 'skor.dart';
import 'package:quizdb/database/quiz_command.dart';
import 'package:quizdb/database/question_command.dart';

class Pilihanganda extends StatefulWidget {
  final int quizId;
  Pilihanganda({required this.quizId});

  @override
  _PilihangandaState createState() => _PilihangandaState();
}

class _PilihangandaState extends State<Pilihanganda> {
  int score = 0;
  int timeLeft = 20; // This will be updated from the databasea
  Timer? timer;
  double nilai = 0;
  String? subject; // To store the subject obtained from the database
  List<Map<String, dynamic>> questionSet = [];
  int currentQuestion = 0;
  final QuizCommand quizCommand = QuizCommand();
  final QuestionCommand questionCommand = QuestionCommand();
  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  Future<void> _initializeQuiz() async {
    // Fetch quiz data from the database
    var quizData = await QuizCommand().getQuizById(widget.quizId);
    if (quizData != null) {
      setState(() {
        timeLeft = quizData['timer'] as int; // Ensure the data type is correct
        subject = quizData['subject'] as String; // Ensure the data type is correct
      });

      // Fetch all questions, options, and correct answers based on quizId
      final questions = await QuestionCommand().getQuestionsByQuizId(widget.quizId);
      setState(() {
        questionSet = questions.map((question) {
          return {
            'question_id': question.questionId,
            'content': question.content,
            'option_a': question.optionA,
            'option_b': question.optionB,
            'option_c': question.optionC,
            'option_d': question.optionD,
            'answer': question.answer,
          };
        }).toList();
      });
      print(questionSet); // Log to verify data
      startTimer();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        _showResultPage();
      }
    });
  }

  void handleAnswer(String selectedAnswer) {
    if (questionSet[currentQuestion]['answer'] == selectedAnswer) {
      setState(() {
        score++;
      });
    }

    setState(() {
      if (currentQuestion < questionSet.length - 1) {
        currentQuestion++;
      } else {
        _showResultPage();
        timer?.cancel();
      }
    });
  }

  void _showResultPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(
          currentScore: (score / questionSet.length) * 100,
          subject: subject ?? "Quiz",
          quizId: widget.quizId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3B547A),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Color(0xFF3B547A),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(12),
                child: Text(
                  '$timeLeft',
                  style: TextStyle(
                    color: Color(0xFF0D47A1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Image.asset(
                'images/lightbulb.png',
                height: 150,
              ),
              SizedBox(height: 20),
              if (questionSet.isNotEmpty)
                buildQuestion(
                  'Pertanyaan ${currentQuestion + 1} dari ${questionSet.length}',
                  questionSet[currentQuestion]['content'],
                  [
                    questionSet[currentQuestion]['option_a'],
                    questionSet[currentQuestion]['option_b'],
                    questionSet[currentQuestion]['option_c'],
                    questionSet[currentQuestion]['option_d'],
                  ],
                ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestion(
      String questionTitle, String questionText, List<String> answers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                questionTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                questionText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        for (var answer in answers)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: buildAnswerButton(answer),
          ),
      ],
    );
  }

  Widget buildAnswerButton(String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            handleAnswer(answer);
          },
          child: Text(
            answer,
            style: TextStyle(
              color: Color(0xFF0D47A1),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
