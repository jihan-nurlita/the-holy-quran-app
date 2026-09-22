import 'package:flutter/material.dart';
import 'package:the_holy_quran/widgets/splash_screen.dart';

void main() => runApp(theholyquran());

class theholyquran extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "The Holy Quran App",
      home: SplashScreen(),
    );
  }
}
