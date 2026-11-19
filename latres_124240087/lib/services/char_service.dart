import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latihanresponsi_124240087/models/char.dart';

class ApiService {
  static String apiUrl = "https://potterapi-fedeperin.vercel.app/en/characters";

  static Future<List<Char>> getCharacters() async {
    // hasil respon
    final response = await http.get(Uri.parse(apiUrl));

    // cek respon
    if(response.statusCode == 200) {
      // decode response body
      final data = jsonDecode(response.body);
      final List characters = data is List ? data : (data["characters"] ?? []);

      // kembalikan data karakter
      return characters.map((character) => Char.fromJson(character)).toList();
    } else {
      throw Exception("Gagal ambil data");
    }
  }

  static Future<Char> getSingleCharacters(int index) async {
    final response = await http.get(Uri.parse("$apiUrl?index=$index"));

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return Char.fromJson(data.first);
      }
      final characters = data;

      return Char.fromJson(characters);
    } else {
      throw Exception("Gagal ambil data id: $index");
    }
  }
}