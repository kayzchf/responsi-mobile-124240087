import 'package:flutter/material.dart';
import 'package:responsi_124240087/models/books.dart';

import '../services/books_service.dart';

class DetailScreen extends StatefulWidget {
  final int bookId;
  const DetailScreen({super.key, required this.bookId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Books? book;
  bool isLoading = true;

  Future<void> fetchSingleBook() async {
    final booksData = await ApiService.getSingleBooks(widget.bookId);

    setState(() {
      book = booksData;
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchSingleBook();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(isLoading ? "..." : book!.title),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : 
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book!.cover,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.book, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              book!.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Original Title: ${book!.originalTitle}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 3),
            Text(
              'Release Date: ${book!.releaseDate}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 3),
           Text(
              'Total Pages: ${book!.pages}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              book!.description,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      )
    );
  }
}