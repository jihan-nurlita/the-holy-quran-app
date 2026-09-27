import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:the_holy_quran/models/ayat.dart';
import 'package:the_holy_quran/models/surah.dart';

class DetailScreen extends StatefulWidget {
  final int noSurat;
  final int? lastAyat;

  const DetailScreen({
    super.key,
    required this.noSurat,
    this.lastAyat,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int currentSurah;
  late int currentAyat;

  late AudioPlayer _audioPlayer;
  int? _playingAyat;

  late final int surahNumber;
  late Future<Surah> _surahFuture;

  // Controller untuk scroll ke ayat tertentu.
  final ItemScrollController _itemScrollController = ItemScrollController();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int? lastAyat;
  bool _hasScrolled = false;

  @override
  void initState() {
    super.initState();

    surahNumber = widget.noSurat;
    currentSurah = widget.noSurat;
    currentAyat = 1;

    _audioPlayer = AudioPlayer();

    _audioPlayer.setVolume(1.0);
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    _audioPlayer.onPlayerComplete.listen((event) {
      if (!mounted) return;

      setState(() {
        _playingAyat = null;
      });
    });

    _surahFuture = _getDetailSurah();

    _loadLastAyat();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Menghitung nomor ayat global untuk audio Al-Quran.
  int _globalAyatNumber(int surah, int ayat) {
    const startAyat = [
      0,
      1,
      8,
      295,
      493,
      670,
      789,
      954,
      1160,
      1236,
      1366,
      1474,
      1591,
      1707,
      1751,
      1802,
      1902,
      2029,
      2140,
      2250,
      2349,
      2483,
      2596,
      2673,
      2791,
      2856,
      2932,
      3159,
      3252,
      3341,
    ];

    return startAyat[surah - 1] + ayat;
  }

  // Memuat penanda ayat terakhir yang dibaca.
  Future<void> _loadLastAyat() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      lastAyat = widget.lastAyat ?? prefs.getInt('last_ayat_$surahNumber');

      _hasScrolled = false;
    });
  }

  // Scroll otomatis menuju ayat terakhir dibaca.
  void _scrollToLastAyat(Surah surahData) {
    if (_hasScrolled || lastAyat == null) return;

    final listAyat = surahData.ayat;

    if (listAyat == null || listAyat.isEmpty) return;

    // Offset 1 untuk Surah Al-Fatihah karena item pertama
    // pada data API dilewati sesuai kode awal.
    final int listAyatOffset = surahNumber == 1 ? 1 : 0;

    // Cari posisi ayat berdasarkan nomor ayat.
    final int targetAyatIndex = listAyat.indexWhere(
      (element) => element.nomor == lastAyat,
    );

    if (targetAyatIndex == -1) return;

    // Posisi indeks pada daftar ayat yang ditampilkan.
    final int displayedAyatIndex = targetAyatIndex - listAyatOffset;

    if (displayedAyatIndex < 0) return;

    // Item pertama adalah banner surah.
    final int targetItemIndex = displayedAyatIndex + 1;

    final int totalAyatCount =
        surahData.jumlahAyat + (surahNumber == 1 ? -1 : 0);

    if (displayedAyatIndex >= totalAyatCount) return;

    _hasScrolled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (_itemScrollController.isAttached) {
        _itemScrollController.scrollTo(
          index: targetItemIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
          alignment: 0.0,
        );
      }
    });
  }

  Future<Surah> _getDetailSurah() async {
    final data = await Dio().get(
      'https://equran.id/api/surat/$surahNumber',
    );

    return Surah.fromJson(json.decode(data.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Surah>(
      future: _surahFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xffFAF7F0),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xff8B5E3C),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            backgroundColor: const Color(0xffFAF7F0),
            appBar: AppBar(
              backgroundColor: const Color(0xffFAF7F0),
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xff8B5E3C),
                ),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    size: 48,
                    color: Color(0xff8B5E3C),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Gagal memuat data surah.',
                    style: GoogleFonts.poppins(
                      color: const Color(0xff8B5E3C),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _surahFuture = _getDetailSurah();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8B5E3C),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        final Surah surah = snapshot.data!;

        // Scroll otomatis setelah data surah dan penanda tersedia.
        if (!_hasScrolled && lastAyat != null) {
          _scrollToLastAyat(surah);
        }

        // Offset untuk Surah Al-Fatihah.
        final int listAyatOffset = surahNumber == 1 ? 1 : 0;

        // Jumlah ayat yang benar-benar ditampilkan.
        final int totalAyatCount =
            surah.jumlahAyat + (surahNumber == 1 ? -1 : 0);

        // Satu item tambahan untuk banner surah.
        final int totalItemCount = totalAyatCount + 1;

        return Scaffold(
          backgroundColor: const Color(0xffFAF7F0),
          appBar: _appBar(
            context: context,
            Surah: surah,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
              itemCount: totalItemCount,
              itemBuilder: (context, index) {
                // Item pertama adalah banner informasi surah.
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: _details(
                      surah: surah,
                    ),
                  );
                }

                // Item berikutnya adalah daftar ayat.
                final int ayatIndex = (index - 1) + listAyatOffset;

                final Ayat ayat = surah.ayat!.elementAt(ayatIndex);

                return _ayatItem(
                  ayat: ayat,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _ayatItem({
    required Ayat ayat,
  }) {
    final bool isLastRead = ayat.nomor == lastAyat;
    final bool isPlaying = ayat.nomor == _playingAyat;

    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isPlaying
                  ? Colors.orange.shade700
                  : isLastRead
                      ? const Color(0xff79430A)
                      : const Color(0xff8B5E3C),
              borderRadius: BorderRadius.circular(10),
              border: isLastRead
                  ? Border.all(
                      color: Colors.amber,
                      width: 2.5,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color: const Color(0xffFAF7F0),
                    borderRadius: BorderRadius.circular(27 / 2),
                  ),
                  child: Center(
                    child: Text(
                      '${ayat.nomor}',
                      style: GoogleFonts.poppins(
                        color: const Color(0xff6F7075),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Spacer(),

                const Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                ),

                const SizedBox(width: 16),

                // AUDIO
                InkWell(
                  onTap: () async {
                    final int globalAyat = _globalAyatNumber(
                      surahNumber,
                      ayat.nomor,
                    );

                    if (_playingAyat == ayat.nomor) {
                      await _audioPlayer.pause();

                      if (!mounted) return;

                      setState(() {
                        _playingAyat = null;
                      });
                    } else {
                      try {
                        await _audioPlayer.stop();

                        await _audioPlayer.play(
                          UrlSource(
                            'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$globalAyat.mp3',
                          ),
                        );

                        if (!mounted) return;

                        setState(() {
                          _playingAyat = ayat.nomor;
                        });
                      } catch (e) {
                        debugPrint('ERROR AUDIO: $e');

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Gagal memutar audio ayat.',
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Icon(
                    _playingAyat == ayat.nomor
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color: isPlaying ? Colors.orange.shade200 : Colors.white,
                  ),
                ),

                const SizedBox(width: 16),

                // BOOKMARK / LAST READ
                InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();

                    if (isLastRead) {
                      await prefs.remove(
                        'last_ayat_$surahNumber',
                      );

                      final currentLastSurah = prefs.getInt('last_surah');

                      if (currentLastSurah == surahNumber) {
                        await prefs.remove('last_surah');
                      }

                      if (!mounted) return;

                      setState(() {
                        lastAyat = null;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Penanda terakhir dibaca dihapus',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      await prefs.setInt(
                        'last_surah',
                        surahNumber,
                      );

                      await prefs.setInt(
                        'last_ayat_$surahNumber',
                        ayat.nomor,
                      );

                      if (!mounted) return;

                      setState(() {
                        lastAyat = ayat.nomor;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Terakhir dibaca: Surah $surahNumber Ayat ${ayat.nomor}',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    isLastRead ? Icons.bookmark : Icons.bookmark_outline,
                    color: isLastRead ? Colors.amber : Colors.white,
                  ),
                ),
              ],
            ),
          ),

          if (isPlaying)
            Padding(
              padding: const EdgeInsets.only(
                top: 6,
                left: 4,
              ),
              child: Text(
                'Sedang diputar',
                style: GoogleFonts.poppins(
                  color: Colors.orange,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          if (isLastRead)
            Padding(
              padding: const EdgeInsets.only(
                top: 6,
                left: 4,
              ),
              child: Text(
                'Terakhir dibaca',
                style: GoogleFonts.poppins(
                  color: Colors.amber,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          const SizedBox(height: 24),

          // ARAB
          Text(
            ayat.ar,
            style: GoogleFonts.amiri(
              color: const Color(0xff6F7075),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 2.5,
            ),
            textAlign: TextAlign.right,
          ),

          const SizedBox(height: 16),

          // TERJEMAHAN
          Text(
            ayat.idn,
            style: GoogleFonts.poppins(
              color: const Color(0xffA8AAB6),
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // BANNER SURAH - WARNA ASLI VERSI COKELAT
  Widget _details({
    required Surah surah,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xffE6DED6),
          ),
          child: Stack(
            children: [
              // GAMBAR QURAN
              Positioned(
                bottom: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.7,
                  child: Image.asset(
                    'assets/quran.png',
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // KONTEN BANNER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      surah.namaLatin,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: const Color(0xff8B5E3C),
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      surah.arti,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: const Color(0xff8B5E3C),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Divider(
                      color: const Color(0xff8B5E3C).withOpacity(0.25),
                      thickness: 1.5,
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          surah.tempatTurun.name,
                          style: GoogleFonts.poppins(
                            color: const Color(0xff8B5E3C),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: const Color(0xff8B5E3C),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${surah.jumlahAyat} Ayat',
                          style: GoogleFonts.poppins(
                            color: const Color(0xff8B5E3C),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      'assets/lafadz.png',
                      width: 200,
                      color: Colors.white,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // APP BAR - WARNA ASLI VERSI COKELAT
  AppBar _appBar({
    required BuildContext context,
    required Surah Surah,
  }) {
    return AppBar(
      backgroundColor: const Color(0xffFAF7F0),
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                weight: 24,
                color: const Color(0xffA8AAB6).withOpacity(0.39),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                Surah.namaLatin,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xff8B5E3C),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
      ),
    );
  }
}
