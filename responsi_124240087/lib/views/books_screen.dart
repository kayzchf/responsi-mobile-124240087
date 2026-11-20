import 'package:flutter/material.dart';
import 'package:responsi_124240087/views/detail_screen.dart';
import 'package:responsi_124240087/views/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/books.dart';
import '../services/books_service.dart';
import 'login_screen.dart';
import 'spells_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  // state produk / karakter
  final List<Books> books = [];
  bool isLoading = true;

  // fungsi mengambil data
  Future<void> fetchBooks() async {
    try {
      // ambil data
      final booksData = await ApiService.getBooks();

      setState(() {
        books.addAll(booksData);
        isLoading = false;
      });
    } catch (e) {
      throw Exception(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  // fungsi profile
  Future<void> _profile() async {
    final authPref = await SharedPreferences.getInstance();
    await authPref.clear();

    if (mounted) {
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
  }

  // fungsi logout
  Future<void> _logout() async {
    final authPref = await SharedPreferences.getInstance();
    await authPref.clear();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Success!", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Logged out Successfully"),
            ],
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Books View"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Profile",
            onPressed: _profile,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      book.cover,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.book, size: 40),
                    ),
                  ),
                  title: Text(book.title),
                  subtitle: Text(book.releaseDate),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(bookId: book.index),
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: SizedBox(
            height: 44,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                side: BorderSide(color: Colors.purple.shade200),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SpellsScreen()),
                );
              },
              child: Text(
                "Spells",
                style: TextStyle(
                  color: Colors.purple.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
