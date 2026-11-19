import 'package:flutter/material.dart';

import '../models/char.dart';
import '../services/char_service.dart';

class DetailPage extends StatefulWidget {
  final int charId;
  const DetailPage({super.key, required this.charId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Char? character;
  bool isLoading = true;

  Future<void> fetchSingleProduct() async {
    final charactersData = await ApiService.getSingleCharacters(widget.charId);

    setState(() {
      character = charactersData;
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchSingleProduct();
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
        title: Text(isLoading ? "..." : character!.fullname),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : 
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  character!.image,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              character!.fullname,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Nickname: ${character!.nickname}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Hogwarts House: ${character!.hogwartsHouse}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Birthdate: ${character!.birthdate}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Interpreted By: ${character!.interpretedBy}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            const Text(
              'Children:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            if (character!.children.isEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('-', style: TextStyle(fontSize: 18)),
              )
            else
              ...character!.children.map(
                (child) => Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                  child: Text('• $child', style: const TextStyle(fontSize: 18)),
                ),
              ),
          ],
        ),
      )
    );
  }
}