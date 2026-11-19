import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latihanresponsi_124240087/models/spell.dart';

class SpellService {
  static String apiUrl = "https://potterapi-fedeperin.vercel.app/en/spells";

  static Future<List<Spell>> getSpells() async {
    // hasil respon
    final response = await http.get(Uri.parse(apiUrl));

    // cek respon
    if(response.statusCode == 200) {
      // decode response body
      final data = jsonDecode(response.body);
      final List spells = data is List ? data : (data["spells"] ?? []);

      // kembalikan data spell
      return spells.map((spell) => Spell.fromJson(spell)).toList();
    } else {
      throw Exception("Gagal ambil data");
    }
  }

  static Future<Spell> getSingleSpell(int index) async {
    final response = await http.get(Uri.parse("$apiUrl?index=$index"));

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return Spell.fromJson(data.first);
      }
      final spell = data;

      return Spell.fromJson(spell);
    } else {
      throw Exception("Gagal ambil data id: $index");
    }
  }
}
