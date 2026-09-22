import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_holy_quran/models/surah.dart';
import 'package:the_holy_quran/tabs/juzamma_tab.dart';
import 'package:the_holy_quran/tabs/surah_tab.dart';
import 'package:the_holy_quran/widgets/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({
    super.key,
    required this.username,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>?> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();

    final lastSurahNo = prefs.getInt('last_surah');

    if (lastSurahNo == null) return null;

    final lastAyat = prefs.getInt('last_ayat_$lastSurahNo');

    if (lastAyat == null) return null;

    final dataStr = await DefaultAssetBundle.of(context)
        .loadString('assets/datas/list-surah.json');

    final List<Surah> surahList = surahFromJson(dataStr);

    final Surah currentSurah = surahList.firstWhere(
      (surah) => surah.nomor == lastSurahNo,
    );

    return {
      'surah': currentSurah,
      'ayat': lastAyat,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAF7F0),
      appBar: _appBar(),
      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: NestedScrollView(
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) =>
                [
              SliverToBoxAdapter(
                child: _greeting(widget.username),
              ),
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xffFAF7F0),
                automaticallyImplyLeading: false,
                shape: Border(
                  bottom: BorderSide(
                    width: 3,
                    color: const Color(0xff8B5E3C).withOpacity(0.10),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: _tab(),
                ),
              ),
            ],
            body: TabBarView(
              children: [
                SurahTab(),
                JuzammaTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TabBar _tab() {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      unselectedLabelColor: const Color(0xff8B5E3C).withOpacity(0.35),
      labelColor: const Color(0xff8B5E3C),
      indicatorColor: const Color(0xff8B5E3C),
      indicatorWeight: 4,
      dividerColor: const Color(0xffFAF7F0),
      tabs: [
        _tabItem(label: 'Surah'),
        _tabItem(label: 'Juzamma'),
      ],
    );
  }

  Tab _tabItem({
    required String label,
  }) {
    return Tab(
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Column _greeting(String username) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assalamualaikum',
          style: GoogleFonts.poppins(
            color: const Color(0xff8B5E3C).withOpacity(0.40),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          username,
          style: GoogleFonts.poppins(
            color: const Color(0xff8B5E3C),
            fontWeight: FontWeight.w600,
            fontSize: 23,
          ),
        ),
        const SizedBox(height: 20),

        // LAST READ
        Stack(
          children: [
            Container(
              height: 135,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffE6DED6),
                borderRadius: BorderRadius.circular(11),
              ),
            ),

            // Gambar Al-Qur'an
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/quran.png',
                width: 155,
                fit: BoxFit.contain,
              ),
            ),

            // Konten Last Read
            FutureBuilder<Map<String, dynamic>?>(
              future: getLastRead(),
              builder: (context, snapshot) {
                final data = snapshot.data;
                final Surah? surah = data?['surah'];
                final int? ayat = data?['ayat'];

                return Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: data == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(
                                    noSurat: surah!.nomor,
                                    lastAyat: ayat!,
                                  ),
                                ),
                              );
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.menu_book_rounded,
                                  color: Color(0xff8B5E3C),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Last Read',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xff8B5E3C),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              surah != null ? surah.namaLatin : 'Belum Ada',
                              style: GoogleFonts.poppins(
                                color: const Color(0xff7A4E2D),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ayat != null ? 'Ayat No: $ayat' : 'Ayat No: -',
                              style: GoogleFonts.poppins(
                                color: const Color(0xff9A8B7C),
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: const Color(0xffFAF7F0),
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/sort.png',
              width: 24,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            'Quran App',
            style: GoogleFonts.poppins(
              color: const Color(0xff8B5E3C),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/search.png',
              width: 24,
            ),
          ),
        ],
      ),
    );
  }
}
