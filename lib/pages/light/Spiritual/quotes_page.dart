import 'package:flutter/material.dart';

class QuotesPage extends StatelessWidget {
  const QuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const quotes = [
      'Sesungguhnya bersama kesulitan ada kemudahan.',
      'Allah tidak membebani seseorang melainkan sesuai kesanggupannya.',
      'Barang siapa bertakwa kepada Allah, niscaya Dia akan membukakan jalan keluar baginya.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes Islami'),
      ),
      body: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(quotes[index]),
            ),
          );
        },
      ),
    );
  }
}
