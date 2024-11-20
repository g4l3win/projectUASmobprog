import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:quizdb/database/database_helper.dart';
import 'package:quizdb/models/result_model.dart';

class ResultsPage extends StatefulWidget {
  final double currentScore;
  final String subject;
  final int quizId;

  ResultsPage({
    required this.currentScore,
    required this.subject,
    required this.quizId,
  });

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  int? selectedUserId;
  String? selectedUserName;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Memuat daftar user saat halaman dimulai
  }

  // Fungsi untuk mengambil daftar user dari database
  Future<void> _fetchUsers() async {
    final userList = await DatabaseHelper().getUsers(); // Ambil daftar user dari database
    setState(() {
      users = userList;
    });
  }

  // Fungsi untuk menyimpan hasil kuis
  Future<void> _saveResult() async {
    if (selectedUserId != null) {
      final result = Result(
        userId: selectedUserId!, // Mengonversi userId ke integer
        quizId: widget.quizId,
        score: widget.currentScore,
      );

      await DatabaseHelper().insertResult(result); // Menyimpan data hasil ke database

      // Menampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hasil kuis berhasil disimpan!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pilih user terlebih dahulu!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00B1C2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text(
              'Congratulation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Total skor kamu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${widget.currentScore}',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Dropdown untuk memilih user_id dan nama mahasiswa
            DropdownButtonFormField<int>(
              value: selectedUserId,
              items: users.map((user) {
                return DropdownMenuItem<int>(
                  value: user['user_id'] as int,
                  child: Text(user['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUserId = value;
                  selectedUserName = users.firstWhere((user) => user['user_id'] == value)['name'];
                });
              },
              decoration: InputDecoration(
                labelText: 'Pilih Namamu',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),

            // Button untuk menyimpan hasil dan kembali ke home
            ElevatedButton.icon(
              onPressed: () async {
                await _saveResult(); // Menyimpan hasil kuis
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              icon: Icon(Icons.home, color: Color(0xFFFFD801)),
              label: Text(
                'Home',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3B547A),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
