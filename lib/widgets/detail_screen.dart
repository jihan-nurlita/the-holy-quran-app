import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late Surah surah;

  late AudioPlayer _audioPlayer;
  int? _playingAyat;

  late final int surahNumber;
  late Future<Surah> _surahFuture;

  final Map<int, GlobalKey> _ayatKeys = {};

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
      if (mounted) {
        setState(() {
          _playingAyat = null;
        });
      }
    });

    _surahFuture = _getDetailSurah();

    _loadLastAyat();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

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

  Future<void> _loadLastAyat() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      lastAyat = prefs.getInt('last_ayat_$surahNumber');
      _hasScrolled = false;
    });
  }

  void _scrollToLastAyatOnce() {
    if (_hasScrolled) return;
    if (lastAyat == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _ayatKeys[lastAyat!];

      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.2,
        );

        _hasScrolled = true;
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
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xffFAF7F0),
          );
        }

        final Surah surah = snapshot.data!;

        if (!_hasScrolled &&
            lastAyat != null &&
            _ayatKeys.containsKey(lastAyat)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToLastAyatOnce();
          });
        }

        return Scaffold(
          backgroundColor: const Color(0xffFAF7F0),
          appBar: _appBar(
            context: context,
            Surah: surah,
          ),
          body: NestedScrollView(
            headerSliverBuilder: (
              context,
              innerBoxIsScrolled,
            ) =>
                [
              SliverToBoxAdapter(
                child: _details(
                  surah: surah,
                ),
              ),
            ],
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final ayat = surah.ayat!.elementAt(
                    index + (surahNumber == 1 ? 1 : 0),
                  );

                  final ayatKey = _ayatKeys.putIfAbsent(
                    ayat.nomor,
                    () => GlobalKey(),
                  );

                  return _ayatItem(
                    key: ayatKey,
                    ayat: ayat,
                  );
                },
                itemCount: surah.jumlahAyat + (surahNumber == 1 ? -1 : 0),
                separatorBuilder: (
                  context,
                  index,
                ) =>
                    const SizedBox.shrink(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _ayatItem({
    required Key? key,
    required Ayat ayat,
  }) {
    final bool isLastRead = ayat.nomor == lastAyat;
    final bool isPlaying = ayat.nomor == _playingAyat;

    return Padding(
      key: key,
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
                    final globalAyat = _globalAyatNumber(
                      surahNumber,
                      ayat.nomor,
                    );

                    if (_playingAyat == ayat.nomor) {
                      await _audioPlayer.pause();

                      if (mounted) {
                        setState(() {
                          _playingAyat = null;
                        });
                      }
                    } else {
                      try {
                        await _audioPlayer.stop();

                        await _audioPlayer.play(
                          UrlSource(
                            'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$globalAyat.mp3',
                          ),
                        );

                        if (mounted) {
                          setState(() {
                            _playingAyat = ayat.nomor;
                          });
                        }
                      } catch (e) {
                        debugPrint(
                          'ERROR AUDIO: $e',
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
                        await prefs.remove(
                          'last_surah',
                        );
                      }

                      if (mounted) {
                        setState(() {
                          lastAyat = null;
                        });
                      }

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Penanda terakhir dibaca dihapus',
                            ),
                            duration: Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                      }
                    } else {
                      await prefs.setInt(
                        'last_surah',
                        surahNumber,
                      );

                      await prefs.setInt(
                        'last_ayat_$surahNumber',
                        ayat.nomor,
                      );

                      if (mounted) {
                        setState(() {
                          lastAyat = ayat.nomor;
                        });
                      }

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Terakhir dibaca: Surah $surahNumber Ayat ${ayat.nomor}',
                            ),
                            duration: const Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                      }
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

  Widget _details({
    required Surah surah,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
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
              // IMAGE QURAN
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

              // CONTENT
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      surah.namaLatin,
                      style: GoogleFonts.poppins(
                        color: const Color(0xff8B5E3C),
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      surah.arti,
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
                  color: Color(0xffA8AAB6).withOpacity(0.39),
                )),
            const SizedBox(width: 8),
            Text(
              Surah.namaLatin,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Color(0xff8B5E3C),
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
