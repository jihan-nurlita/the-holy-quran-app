import 'package:flutter/material.dart';

class DzikirPage extends StatelessWidget {
  const DzikirPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dzikir = [
      'Subhanallah (33x)',
      'Alhamdulillah (33x)',
      'Allahu Akbar (34x)',
      'La ilaha illallah',
      'Astaghfirullah',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dzikir Harian'),
      ),
      body: ListView.builder(
        itemCount: dzikir.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(dzikir[index]),
          );
        },
      ),
    );
  }
}
