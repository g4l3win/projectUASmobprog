import 'package:flutter/material.dart';
import 'SignIn.dart'; // Pastikan path ke file SignIn.dart sudah benar

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan',
            style: TextStyle(color: Colors.white)), // Judul di AppBar
        centerTitle: true,
        backgroundColor: Color(0xFF00B1C2), // Warna AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80), // Spasi antara judul dan ListTile
            // Tombol Masuk / Daftar
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Signin()));
                },
                child: Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    wordSpacing: 1,
                    color: Color(0xFF3B547A),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Color(0xFF3B547A), width: 2), // Warna border tombol
                ),
              ),
            ),
            SizedBox(height: 20), // Memberikan sedikit spasi di bawah tombol
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, IconData icon, String title, Color textColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 10), // Spasi antar ListTile
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300), // Warna border
        borderRadius: BorderRadius.circular(10), // Sudut border
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.yellow), // Ubah warna ikon menjadi kuning
        title: Text(
          title,
          style: TextStyle(color: textColor),
        ),
        onTap: () {
          // Tindakan ketika ListTile ditekan
        },
      ),
    );
  }
}
