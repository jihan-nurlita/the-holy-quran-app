import 'package:flutter/material.dart';

class TilawahPage extends StatefulWidget {
  const TilawahPage({super.key});

  @override
  State<TilawahPage> createState() => _TilawahPageState();
}

class _TilawahPageState extends State<TilawahPage> {
  int progress = 0;
  final int target = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Tilawah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress / target,
            ),
            const SizedBox(height: 20),
            Text('$progress / $target Ayat'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (progress < target) {
                    progress++;
                  }
                });
              },
              child: const Text('Tambah Progress'),
            ),
          ],
        ),
      ),
    );
  }
}
