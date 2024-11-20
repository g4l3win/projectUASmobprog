import 'package:flutter/material.dart';

import 'quiz_screen.dart';
import 'create_quiz_screen.dart'; // Import halaman baru
import 'Account.dart';
import 'materistat.dart';
import 'package:quizdb/screens/mahasiswa.dart'; // Sesuaikan dengan lokasi file Mahasiswa


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> catNames = [
    "Buat Kuis",
    "Statistik",
    "Daftar Mahasiswa",
  ];

  List<Color> catColors = [
    Color(0xFF00B1C2),
    Color(0xFF00B1C2),
    Color(0xFF00B1C2),
  ];

  List<Icon> catIcons = [
    Icon(Icons.category, color: Colors.white, size: 30),
    Icon(Icons.video_library, color: Colors.white, size: 30),
    Icon(Icons.assignment, color: Colors.white, size: 30),
  ];

  List<String> imgList = [
    'Flutter',
    'SQL',
    'HTML',
    'C++',
  ];

  int _selectedIndex = 0; // Menyimpan indeks halaman yang dipilih

  List<Widget> _pages = [
    HomePage(), // Halaman utama
    Account(), // Halaman akun
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Mengubah halaman yang dipilih
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 10),
              decoration: BoxDecoration(
                color: Color(0xFF00B1C2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.dashboard,
                          size: 30, color: Color(0xFFFFD801)),
                      Icon(Icons.notifications,
                          size: 30, color: Color(0xFFFFD801)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 3, bottom: 15),
                    child: Text(
                      "Hi, Lecturer",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF3B547A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search here...",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        prefixIcon: Icon(Icons.search,
                            size: 25, color: Color(0xFFFFD801)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                children: [
                  GridView.builder(
                    itemCount: catNames.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (catNames[index] == "Buat Kuis") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateQuizScreen()),
                            );
                          } else if (catNames[index] == "Statistik") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Materistat(), // Isi dengan subjek sesuai kebutuhan
                              ),
                            );
                          } else if (catNames[index] ==
                              "Daftar Mahasiswa") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Mahasiswa(), // Isi dengan subjek sesuai kebutuhan
                              ),
                            );
                            print("Navigating to Mahasiswa...");
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: catColors[index],
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: catIcons[index]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              catNames[index],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Kuis yang tersedia",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  GridView.builder(
                    itemCount: imgList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                      (MediaQuery.of(context).size.height - 50 - 25) /
                          (4 * 240),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          // Navigasi berdasarkan nama gambar
                          if (imgList[index] == "Flutter") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizHomePage(
                                    subject:
                                    'Mobile Programming'), // Ganti dengan halaman kuis Flutter
                              ),
                            );
                          } else if (imgList[index] == "C++") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuizHomePage(subject: 'Algorithm'),
                              ),
                            );
                          } else if (imgList[index] == "HTML") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuizHomePage(subject: 'Web Programming'),
                              ),
                            );
                          } else if (imgList[index] == "SQL") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuizHomePage(subject: 'Database Systems'),
                              ),
                            );
                          }
                          ;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFF5F3FF),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Image.asset(
                                  "images/${imgList[index]}.png",
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                imgList[index],
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          : _pages[_selectedIndex], // Halaman lain jika bukan Home

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Mengatur indeks saat ini
        onTap: _onItemTapped, // Menangani penekanan ikon
        showUnselectedLabels: true,
        iconSize: 32,
        selectedItemColor: Color(0xFF3B547A),
        selectedFontSize: 18,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}
