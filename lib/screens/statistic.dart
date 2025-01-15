import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:quizdb/database/quiz_command.dart';
import 'package:quizdb/database/result_command.dart';

class Statistik extends StatefulWidget {
  final String subject;
  const Statistik({Key? key, required this.subject}) : super(key: key);

  @override
  State<Statistik> createState() => _Statistik();
}

class _Statistik extends State<Statistik> {
  List<int> currentDistribusi = [];
  List<Map<String, dynamic>> quizList = [];
  int totalStudents = 0;
  final QuizCommand quizCommand = QuizCommand();
  List<String> quizTypes = ['Pilihan Ganda', 'Isian', 'Benar Salah'];
  String selectedQuizType = 'Pilihan Ganda';
  final ResultCommand resultCommand = ResultCommand();

  @override
  void initState() {
    super.initState();
    _fetchQuizzesBySubject();
  }

  // Fetch quizzes based on the selected subject
  Future<void> _fetchQuizzesBySubject() async {
    final quizzes = await QuizCommand().getAllQuizzes();
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

  Future<void> _loadQuizScores(int quizId) async {
    final scores = await ResultCommand().getScoresByQuizId(quizId);
    final studentCount = await ResultCommand().getTotalStudentsByQuizId(quizId);

    setState(() {
      currentDistribusi = _calculateScoreDistribution(scores);
      totalStudents = studentCount;
    });
  }

  List<int> _calculateScoreDistribution(List<int> scores) {
    List<int> distribution = [0, 0, 0, 0];
    for (int score in scores) {
      if (score <= 25) {
        distribution[0]++;
      } else if (score <= 50) {
        distribution[1]++;
      } else if (score <= 75) {
        distribution[2]++;
      } else {
        distribution[3]++;
      }
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00B1C2),
        title: Text(
          'Statistik Nilai Kuis ${widget.subject}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // // Tambahkan kode di bawah ini jika ingin mengaktifkan filter quiz type
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: quizTypes.map((type) {
              //     return GestureDetector(
              //       onTap: () {
              //         setState(() {
              //           selectedQuizType = type;
              //           _fetchQuizzesBySubject();
              //         });
              //       },
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              //         decoration: BoxDecoration(
              //           color: selectedQuizType == type
              //               ? const Color(0xFFFFD801)
              //               : Colors.grey.shade200,
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         child: Text(
              //           type,
              //           style: TextStyle(
              //             fontSize: 16,
              //             color: selectedQuizType == type ? Colors.black : Colors.grey,
              //           ),
              //         ),
              //       ),
              //     );
              //   }).toList(),
              // ),
            ),
            SizedBox(
              width: 400,
              height: 400,
              child: BarChart(
                BarChartData(
                  maxY: 10,
                  barGroups: _generateBarGroups(currentDistribusi),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('0-25');
                            case 1:
                              return const Text('26-50');
                            case 2:
                              return const Text('51-75');
                            case 3:
                              return const Text('76-100');
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Total Mahasiswa : $totalStudents",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            quizList.isNotEmpty
                ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quizList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _loadQuizScores(quizList[index]['quiz_id']); // pastikan kunci diakses dengan benar
                  },
                  child: _buildProductItem(quizList[index]['title']),
                );
              },
            )
                : const Center(child: Text("No quizzes available")),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(List<int> distribusi) {
    return List.generate(
      distribusi.length,
          (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: distribusi[index].toDouble(),
            color: const Color(0xFFFFD801),
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(String name) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3B547A),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
