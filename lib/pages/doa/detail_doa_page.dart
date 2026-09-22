import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'doa_data.dart';

class DetailPage extends StatelessWidget {
  final DoaModel doa;

  const DetailPage({
    super.key,
    required this.doa,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F3EE),

      /// APPBAR (FIX JUDUL PANJANG)
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF7F3EE),
        iconTheme: const IconThemeData(color: Color(0xffB7AAA0)),
        title: Text(
          doa.judul,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff8B5E3C),
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xffFFFCF8),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff8B5E3C).withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER MINI
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xffF4ECE4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xff8B5E3C),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      doa.judul,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              /// ARAB (LEBIH PREMIUM)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xffF4ECE4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    doa.arab,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.notoNaskhArabic(
                      fontSize: 30,
                      height: 2.2,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff6B625C),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// ARTI (ONLY)
              const Text(
                "Artinya",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffA79A90),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xffFAF6F1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  doa.arti,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff8E8177),
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
