import 'package:flutter/material.dart';
import 'package:quizdb/database/database_helper.dart'; // Make sure this is your correct import for the database helper

class Mahasiswa extends StatefulWidget {
  @override
  _MahasiswaState createState() => _MahasiswaState();
}

class _MahasiswaState extends State<Mahasiswa> {
  // This will hold the future result that we want to display
  late Future<List<Map<String, dynamic>>> users;

  @override
  void initState() {
    super.initState();
    users = _fetchUsers();  // Fetch users when the page is first initialized
  }

  // Function to fetch all users (mahasiswa) from the database
  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    final userList = await DatabaseHelper().getUsers(); // Call your getUsers method
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daftar Mahasiswa",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00B1C2),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: users,  // Provide the future to the FutureBuilder
        builder: (context, snapshot) {
          // Checking if the future is still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there's an error with fetching the data
          else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          // If there's no data or an empty result
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data mahasiswa."));
          } else {
            // If the data is available
            final mahasiswaList = snapshot.data!;
            return ListView.builder(
              itemCount: mahasiswaList.length,
              itemBuilder: (context, index) {
                final mahasiswa = mahasiswaList[index];

                // Assuming your 'Mahasiswa' table has columns like 'id', 'name', 'email', etc.
                final id = mahasiswa['user_id'].toString();  // Replace with the actual column names in your database
                final name = mahasiswa['name'].toString();

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading:Text(id),  // Display ID in avatar
                    title: Text(name),  // Display student name

                    onTap: () {
                      // Handle item tap, for example to show detailed info
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
