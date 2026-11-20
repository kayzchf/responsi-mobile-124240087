import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi_124240087/models/books.dart';

class ApiService {
  static String apiUrl = "https://potterapi-fedeperin.vercel.app/en/books";

  static Future<List<Books>> getBooks() async {
    // hasil respon
    final response = await http.get(Uri.parse(apiUrl));

    // cek respon
    if(response.statusCode == 200) {
      // decode response body
      final data = jsonDecode(response.body);
      print(data);
      final List books = data is List ? data : (data["books"] ?? []);

      // kembalikan data karakter
      return books.map((books) => Books.fromJson(books)).toList();
    } else {
      throw Exception("Gagal ambil data");
    }
  }

  static Future<Books> getSingleBooks(int index) async {
    final response = await http.get(Uri.parse("$apiUrl?index=$index"));

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return Books.fromJson(data.first);
      }
      final books = data;

      return Books.fromJson(books);
    } else {
      throw Exception("Gagal ambil data id: $index");
    }
  }
}