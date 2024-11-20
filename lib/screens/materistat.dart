import 'package:flutter/material.dart';
import 'statistic.dart';

class Materistat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Statistik Materi",
          style: TextStyle(color: Colors.white),
        ), // Judul halaman
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        backgroundColor: Color(0xFF00B1C2), // Warna AppBar
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Pilih Materi untuk melihat statistik',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(height: 10),

            // Grid View for Menu
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildMenuItem('Web Programming', Icons.data_object,
                      onTap: () {
                        // Aksi saat 'mat' ditekan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Statistik(subject: 'Web Programming'),
                          ),
                        );
                      }),
                  _buildMenuItem('Mobile Programming', Icons.menu, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Statistik(subject: 'Mobile Programming'),
                      ),
                    );
                  }),
                  _buildMenuItem('Algorithm', Icons.menu, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Statistik(subject: 'Algorithm'),
                      ),
                    );
                  }),
                  _buildMenuItem('Database Systems', Icons.menu, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Statistik(subject: 'Database Systems'),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun tampilan setiap item di Grid
  Widget _buildMenuItem(String title, IconData icon, {VoidCallback? onTap}) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Color(0xFFFFD801), size: 30), // Tambahkan Icon
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}