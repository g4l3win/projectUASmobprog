import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:flutter/services.dart'; // untuk clipboard

class TruefalseFinalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Link dummy yang bisa disalin
    String link = "https://dummy.link/kuis";

    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.6,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.6,
              decoration: BoxDecoration(
                color: Color(0xFF3B547A),
              ),
              child: Center(
                child: Image.asset(
                  "images/correct.png",
                  width: 150,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.666,
                decoration: BoxDecoration(
                  color: Color(0xFF674AEF),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.666,
                padding: EdgeInsets.only(top: 40, bottom: 30),
                decoration: BoxDecoration(
                  color: Color(0xFF00B1C2),
                ),
                child: Column(
                  children: [
                    Text(
                      "Kuis telah berhasil dibuat !",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        color: Color(0xFFFFD801),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container untuk link dummy dengan border
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              link,
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF00B1C2),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          // Button untuk menyalin link
                          ElevatedButton(
                            onPressed: () {
                              // Salin link ke clipboard
                              Clipboard.setData(ClipboardData(text: link));

                              // Tampilkan notifikasi/snackbar dengan border
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black,
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      "Link sudah di salin",
                                      style: TextStyle(
                                          color: Colors
                                              .white), // Perbaiki warna teks agar terlihat
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Text("Salin Link",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3B547A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                    SizedBox(height: 60),
                    Material(
                      color: Color(0xFF3B547A),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          // Navigasi ke halaman home
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 40),
                          child: Text(
                            "Home",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
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
