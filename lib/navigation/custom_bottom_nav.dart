import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget navItem({
    required String icon,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          icon,
          width: 30,
          height: 30,
          color: selected ? const Color(0xffFFFFFF) : const Color(0xffF3E8D8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xff8B5E3C),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(
            icon: 'assets/al_quran.png',
            selected: currentIndex == 0,
            onPressed: () => onTap(0),
          ),
          navItem(
            icon: 'assets/pray.png',
            selected: currentIndex == 1,
            onPressed: () => onTap(1),
          ),
          navItem(
            icon: 'assets/doa.png',
            selected: currentIndex == 2,
            onPressed: () => onTap(2),
          ),
          navItem(
            icon: 'assets/light.png',
            selected: currentIndex == 3,
            onPressed: () => onTap(3),
          ),
        ],
      ),
    );
  }
}
