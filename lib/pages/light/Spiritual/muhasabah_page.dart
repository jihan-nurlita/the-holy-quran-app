import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MuhasabahPage extends StatefulWidget {
  const MuhasabahPage({super.key});

  @override
  State<MuhasabahPage> createState() => _MuhasabahPageState();
}

class _MuhasabahPageState extends State<MuhasabahPage> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNote();
  }

  Future<void> loadNote() async {
    final prefs = await SharedPreferences.getInstance();

    controller.text = prefs.getString('muhasabah_note') ?? '';
  }

  Future<void> saveNote() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'muhasabah_note',
      controller.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan tersimpan'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muhasabah Harian'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Tulis refleksi ibadah hari ini...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveNote,
              child: const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
