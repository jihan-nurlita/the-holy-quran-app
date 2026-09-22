import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_holy_quran/models/surah.dart';

class SurahListTab extends StatefulWidget {
  final String jsonPath;

  const SurahListTab({
    super.key,
    required this.jsonPath,
  });

  @override
  State<SurahListTab> createState() => _SurahListTabState();
}

class _SurahListTabState extends State<SurahListTab> {
  Future<List<Surah>> _loadData() async {
    String data = await rootBundle.loadString(widget.jsonPath);

    return surahFromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Surah>>(
      future: _loadData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final surah = snapshot.data![index];

            return ListTile(
              title: Text(surah.namaLatin),
            );
          },
        );
      },
    );
  }
}
