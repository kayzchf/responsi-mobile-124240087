import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/spell.dart';
import '../services/spell_service.dart';
import 'books_screen.dart';
import 'favorite_screen.dart';
import 'login_screen.dart';

class SpellsScreen extends StatefulWidget {
  const SpellsScreen({super.key});

  @override
  State<SpellsScreen> createState() => _SpellsScreenState();
}

class _SpellsScreenState extends State<SpellsScreen> {
  final List<Spell> spells = [];
  bool isLoading = true;
  final Box _favBox = Hive.box('favorite_spells');

  // Ambil data spells
  Future<void> fetchSpells() async {
    try {
      final spellsData = await SpellService.getSpells();
      setState(() {
        spells.addAll(spellsData);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi toggle favorit
  void toggleFavorite(Spell spell) {
    final isFav = _favBox.containsKey(spell.index);

    if (isFav) {
      _favBox.delete(spell.index);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Remove!", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${spell.spell} removed from fav list!"),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      _favBox.put(spell.index, spell.toJson());
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Add!", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${spell.spell} successfully added to fav list!"),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    setState(() {});
  }

  // Fungsi logout
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
    fetchSpells();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Harry Potter Spells Gallery"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            tooltip: "Favorite Spells",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoriteSpellsPage(),
                ),
              );
              // Refresh state setelah kembali dari FavoriteSpellsPage
              setState(() {});
            },
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: spells.length,
              itemBuilder: (context, index) {
                final spell = spells[index];
                final isFav = _favBox.containsKey(spell.index);

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    title: Text(
                      spell.spell,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      spell.use,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey.shade600,
                      ),
                      onPressed: () {
                        toggleFavorite(spell);
                      },
                    ),
                  ),
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
                  MaterialPageRoute(builder: (context) => const BooksScreen()),
                );
              },
              child: Text(
                "Characters",
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
