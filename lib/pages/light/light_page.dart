import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightPage extends StatelessWidget {
  const LightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xffFAF7F0),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Spiritual',
          style: GoogleFonts.poppins(
            color: const Color(0xff8B5E3C),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff8B5E3C),
                    Color(0xffB08968),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Tetap Dekat\nDengan Al-Qur’an',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Perindah hari dengan dzikir,\nmurottal, dan ibadah harian.',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Text(
              'Features',
              style: GoogleFonts.poppins(
                color: const Color(0xff8B5E3C),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 20),

            /// MENU
            _menuItem(
              icon: Icons.dark_mode_rounded,
              title: 'Dark Mode',
              subtitle: 'Tema aplikasi yang nyaman di mata',
            ),

            _menuItem(
              icon: Icons.menu_book_rounded,
              title: 'Dzikir Harian',
              subtitle: 'Dzikir pagi & petang',
            ),

            _menuItem(
              icon: Icons.notifications_active_rounded,
              title: 'Reminder Ibadah',
              subtitle: 'Pengingat sholat dan membaca Qur’an',
            ),

            _menuItem(
              icon: Icons.headphones_rounded,
              title: 'Murottal',
              subtitle: 'Dengarkan bacaan Al-Qur’an',
            ),

            _menuItem(
              icon: Icons.favorite_rounded,
              title: 'Muhasabah',
              subtitle: 'Catatan dan refleksi harian',
            ),

            _menuItem(
              icon: Icons.settings_rounded,
              title: 'Pengaturan',
              subtitle: 'Atur font, tampilan, dan lainnya',
            ),

            const SizedBox(height: 5),

            /// FOOTER
            Center(
              child: Text(
                'The Holy Quran',
                style: GoogleFonts.poppins(
                  color: const Color(0xffB7A99A),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xffEDE4DB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xff8B5E3C).withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: const Color(0xff8B5E3C),
              size: 28,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: const Color(0xff8B5E3C),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: const Color(0xff9A8B7C),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Color(0xff8B5E3C),
            size: 18,
          ),
        ],
      ),
    );
  }
}
