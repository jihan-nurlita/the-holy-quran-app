import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_holy_quran/models/surah.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_holy_quran/widgets/detail_screen.dart';

class SurahTab extends StatefulWidget {
  const SurahTab({super.key});

  @override
  State<SurahTab> createState() => _SurahTabState();
}

class _SurahTabState extends State<SurahTab> {
  int? lastSurah;
  int? lastAyat;

  Future<List<Surah>> _getSurahList() async {
    final String data = await rootBundle.loadString(
      'assets/datas/list-surah.json',
    );

    return surahFromJson(data);
  }

  @override
  void initState() {
    super.initState();
    _loadLastSurah();
  }

  Future<void> _loadLastSurah() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    final savedLastSurah = prefs.getInt('last_surah');

    setState(() {
      lastSurah = savedLastSurah;

      if (savedLastSurah != null) {
        lastAyat = prefs.getInt(
          'last_ayat_$savedLastSurah',
        );
      } else {
        lastAyat = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Surah>>(
      future: _getSurahList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          color: const Color(0xffFAF7F0),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
            ),
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: const Color(0xff8B5E3C).withOpacity(0.35),
            ),
            itemBuilder: (context, index) {
              final surah = snapshot.data![index];

              return _surahItem(
                context: context,
                surah: surah,
                index: index,
                isLastRead: lastSurah == surah.nomor,
              );
            },
          ),
        );
      },
    );
  }

  Widget _surahItem({
    required BuildContext context,
    required Surah surah,
    required int index,
    required bool isLastRead,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setInt(
          'last_surah',
          surah.nomor,
        );

        if (!context.mounted) return;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailScreen(
              noSurat: surah.nomor,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        child: Row(
          children: [
            // 🔢 NOMOR SURAT
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/outline_border.png',
                  width: 38,
                ),
                Text(
                  '${index + 1}',
                  style: GoogleFonts.poppins(
                    color: const Color(0xff6F7075),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // 📘 NAMA SURAT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.namaLatin,
                    style: GoogleFonts.poppins(
                      color: const Color(0xff6F7075),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  // ✅ BADGE TERAKHIR DIBACA
                  if (isLastRead)
                    Container(
                      margin: const EdgeInsets.only(
                        top: 4,
                        left: 0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Terakhir dibaca',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Text(
                        surah.tempatTurun.name,
                        style: GoogleFonts.poppins(
                          color: const Color(0xffA8AAB6),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${surah.jumlahAyat} Ayat',
                        style: GoogleFonts.poppins(
                          color: const Color(0xff8B5E3C),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🕌 NAMA ARAB
            Text(
              surah.nama,
              style: GoogleFonts.amiri(
                color: const Color(0xff6F7075),
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
