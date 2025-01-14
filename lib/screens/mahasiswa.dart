import 'package:flutter/material.dart';
import 'package:quizdb/database/database_helper.dart';

class Mahasiswa extends StatefulWidget {
  @override
  _MahasiswaState createState() => _MahasiswaState();
}

class _MahasiswaState extends State<Mahasiswa> {
  late Future<List<Map<String, dynamic>>> users;
  final dbHelper = DatabaseHelper();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> allUsers = []; // Semua data mahasiswa
  List<Map<String, dynamic>> filteredUsers = []; // Data mahasiswa yang difilter (hasil pencarian)

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Ambil semua data mahasiswa saat halaman pertama kali dimuat
  }

  // Fungsi untuk memuat semua data mahasiswa
  Future<void> _loadUsers() async {
    final userList = await dbHelper.getUsers(); // Memanggil semua mahasiswa dari database
    setState(() {
      allUsers = userList; // Simpan ke dalam daftar utama
      filteredUsers = userList; // Awalnya filtered sama dengan semua mahasiswa
    });
  }

  // Fungsi untuk mencari mahasiswa berdasarkan input search bar
  void _searchUsers(String query) {
    final results = allUsers.where((user) {
      final name = user['name'].toLowerCase();
      final userId = user['user_id'].toString();
      final input = query.toLowerCase();

      return name.contains(input) || userId.contains(input); // Cocokkan nama atau user_id
    }).toList();

    setState(() {
      filteredUsers = results; // Perbarui hasil pencarian
    });
  }

  // Fungsi untuk menambahkan mahasiswa
  Future<void> _addUser() async {
    final nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Mahasiswa"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Nama Mahasiswa"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await dbHelper.insertUser({'name': nameController.text});
                  _loadUsers(); // Perbarui daftar setelah menambahkan data
                  Navigator.pop(context);
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengedit mahasiswa
  Future<void> _editUser(int userId, String currentName) async {
    final nameController = TextEditingController(text: currentName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Mahasiswa"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Nama Mahasiswa"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await dbHelper.updateUser({
                    'user_id': userId,
                    'name': nameController.text,
                  });
                  _loadUsers(); // Perbarui daftar setelah mengedit data
                  Navigator.pop(context);
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus mahasiswa
  Future<void> _deleteUser(int userId) async {
    await dbHelper.deleteUser(userId);
    _loadUsers(); // Perbarui daftar setelah menghapus data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Mahasiswa"),
        backgroundColor: const Color(0xFF00B1C2),
      ),
      body: Column(
        children: [
          // Search Barr
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Cari mahasiswa...",
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: _searchUsers, // Panggil fungsi saat teks berubah
            ),
          ),
          // List Mahasiswa
          Expanded(
            child: filteredUsers.isEmpty
                ? const Center(child: Text("Tidak ada data mahasiswa."))
                : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final mahasiswa = filteredUsers[index];
                final id = mahasiswa['user_id'];
                final name = mahasiswa['name'];

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Text(id.toString()), // Menampilkan user_id
                    title: Text(name), // Menampilkan nama mahasiswa
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editUser(id, name),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUser(id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF00B1C2),
      ),
    );
  }
}
