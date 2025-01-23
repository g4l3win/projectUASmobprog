import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quizdb/screens/util/emoticon_face.dart';
import 'package:quizdb/screens/util/exercise_tile.dart';
import 'chat.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  const DetailScreen({required this.title, Key? key}) : super(key: key);

  @override
  _DetailScreen createState() => _DetailScreen();
}

class _DetailScreen extends State<DetailScreen> {
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  // Ambil tanggal hari ini
  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('d MMMM yyyy').format(now);
  }

//fungsi buat mengangani tap pada bottomnavigationbar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      //navigasi ke halaman chat
      Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, //biar tahu tab yang aktif yang mana
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
          ]),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          // Kolom besar
          children: [
            // Greeting Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Kolom teks di kiri dengan border
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halaman: ${widget.title}',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              getFormattedDate(),
                              style: TextStyle(
                                color: Colors.blue[200],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Ikon di kanan dengan border
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          border: Border.all(
                            color: Colors.white, // Warna border
                            width: 2, // Ketebalan border
                          ),
                          borderRadius:
                              BorderRadius.circular(12), // Sudut melengkung
                        ),
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Search bar
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Search...",
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  // Row buat ikon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'How do you feel',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Barisan emoticon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          EmoticonFace(emoticonFace: '☹️'),
                          SizedBox(height: 8),
                          Text('Bad', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Column(
                        children: [
                          EmoticonFace(emoticonFace: '😑'),
                          SizedBox(height: 8),
                          Text('Neutral',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Column(
                        children: [
                          EmoticonFace(emoticonFace: '🙂'),
                          SizedBox(height: 8),
                          Text('Fine', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Column(
                        children: [
                          EmoticonFace(emoticonFace: '😀'),
                          SizedBox(height: 8),
                          Text('Great', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            // The white part
            Expanded(
              child: Container(
                padding: EdgeInsets.all(18),
                color: Colors.grey[100],
                child: Column(
                  children: [
                    // Exercise row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Exercises',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Icon(Icons.more_horiz),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // ListTile
                    Expanded(
                        child: ListView(
                      children: [
                        ExerciseTile(
                          icon: Icons.favorite,
                          exerciseName: 'Speaking skills',
                          numberOfExercises: 16,
                          warna: Colors.redAccent,
                        ),
                        ExerciseTile(
                          icon: Icons.chat,
                          exerciseName: 'Chatting skills',
                          numberOfExercises: 1,
                          warna: Colors.yellowAccent,
                        ),
                        ExerciseTile(
                          icon: Icons.social_distance,
                          exerciseName: 'capek banget skills',
                          numberOfExercises: 1,
                          warna: Colors.blueAccent,
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

