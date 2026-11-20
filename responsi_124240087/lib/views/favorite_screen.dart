import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/spell.dart';

class FavoriteSpellsPage extends StatefulWidget {
  const FavoriteSpellsPage({super.key});

  @override
  State<FavoriteSpellsPage> createState() => _FavoriteSpellsPageState();
}

class _FavoriteSpellsPageState extends State<FavoriteSpellsPage> {
  final Box _favBox = Hive.box('favorite_spells');

  Future<void> _removeFavorite(Spell spell) async {
    await _favBox.delete(spell.index);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Ambil semua spell favorit dari Hive
    final List<Spell> favoriteSpells = _favBox.values.map((item) {
      return Spell.fromJson(Map<dynamic, dynamic>.from(item));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Favorite Spell"),
      ),
      body: favoriteSpells.isEmpty
          ? const Center(
              child: Text(
                "No favorite spells yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: favoriteSpells.length,
              itemBuilder: (context, index) {
                final spell = favoriteSpells[index];

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: const Icon(Icons.auto_stories, size: 28),
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
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _removeFavorite(spell);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
