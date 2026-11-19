import 'package:flutter/material.dart';
import 'package:latihanresponsi_124240087/views/detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/char.dart';
import '../services/char_service.dart';
import 'login_screen.dart';
import 'spells_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // state produk / karakter
  final List<Char> characters = [];
  bool isLoading = true;

  // fungsi mengambil data
  Future<void> fetchCharacters() async {
    try {
      // ambil data
      final charactersData = await ApiService.getCharacters();

      setState(() {
        characters.addAll(charactersData);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
    fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Characters"),
        actions: [
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
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      character.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: 40),
                    ),
                  ),
                  title: Text(character.fullname),
                  subtitle: Text(character.interpretedBy),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(charId: character.index),
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
                  MaterialPageRoute(builder: (context) => const SpellsPage()),
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
