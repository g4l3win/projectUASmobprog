import 'package:flutter/material.dart';
import 'dart:async';
import 'skor.dart';
import 'package:quizdb/database/quiz_command.dart';
import 'package:quizdb/database/questionEsai_command.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class EssayQuiz extends StatefulWidget {
  final int quizId;
  EssayQuiz({required this.quizId});

  @override
  _EssayQuizState createState() => _EssayQuizState();
}

class _EssayQuizState extends State<EssayQuiz> {
  int score = 0;
  int timeLeft = 20; // This can be updated based on data from the database
  Timer? timer;
  double nilai = 0;
  String? subject; // Store subject retrieved from database
  List<Map<String, dynamic>> questionSet = [];
  int currentQuestion = 0;
  TextEditingController answerController = TextEditingController();
  final QuizCommand quizCommand = QuizCommand();
  final QuestionEsaiCommand questionEsaiCommand = QuestionEsaiCommand();

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  Future<void> _initializeQuiz() async {
    // Fetch quiz data from the databasea
    var quizData = await QuizCommand().getQuizById(widget.quizId);
    if (quizData != null) {
      setState(() {
        timeLeft = quizData['timer'] as int; // Ensure the data type is correct
        subject =
            quizData['subject'] as String; // Ensure the data type is correct
      });

      // Fetch all questions, options, and correct answers based on quizId
      final questions =
          await QuestionEsaiCommand().getQuestionsEsaiByQuizId(widget.quizId);
      setState(() {
        questionSet = questions.map((question) {
          return {
            'question_id': question.questionId,
            'content': question.content,
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
    answerController.dispose();
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

  void handleAnswer() {
    if (answerController.text.trim().toLowerCase() ==
        questionSet[currentQuestion]['answer'].toString().toLowerCase()) {
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
    answerController.clear(); // Clear the text field after each answer
  }

  void _showResultPage() {
    // Calculate the current score percentage
    double currentScore = (score / questionSet.length) * 100;

    // Menampilkan notifikasi dengan currentScore
    showCompletionNotification(currentScore);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(
          currentScore: currentScore,
          subject: subject ?? "Essay Quiz",
          quizId: widget.quizId,
        ),
      ),
    );
  }

// Fungsi untuk menampilkan notifikasi setelah soal dijawab
  void showCompletionNotification(double currentScore) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Quiz Completed!',
        body:
            'Subject: $subject\nFinal Score: ${currentScore.toStringAsFixed(2)}%',
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
                  'Question ${currentQuestion + 1} of ${questionSet.length}',
                  questionSet[currentQuestion]['content'],
                ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestion(String questionTitle, String questionText) {
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: answerController,
            decoration: InputDecoration(
              labelText: 'Your Answer',
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: Colors.black),
            minLines: 1,
            maxLines: 5,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            onPressed: handleAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0D47A1),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Submit Answer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
