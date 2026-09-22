import 'package:flutter/material.dart';
import 'package:the_holy_quran/navigation/custom_bottom_nav.dart';
import 'package:the_holy_quran/pages/doa/doa_page.dart';
import 'package:the_holy_quran/pages/light/light_page.dart';
import 'package:the_holy_quran/pages/sholat/sholat_page.dart';
import 'package:the_holy_quran/widgets/home_screen.dart';

class MainNavigation extends StatefulWidget {
  final String username;

  const MainNavigation({
    super.key,
    required this.username,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      HomeScreen(username: widget.username),
      const SholatPage(),
      const DoaPage(),
      const LightPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
