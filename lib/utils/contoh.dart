// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:the_holy_quran/models/surah.dart';

// class DetailScreen extends StatelessWidget {
//   final int nosurat;
//   const DetailScreen({super.key, required this.nosurat});

//   Future<Surah> _getDetailSurah() async {
//     var data = await Dio().get("https://equran.id/api/surat/$nosurat");
//     return Surah.fromJson(json.decode(data.toString()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Surah>(
//         future: _getDetailSurah(),
//         initialData: null,
//         builder: ((context, snapshot) {
//           if (!snapshot.hasData) {
//             return Scaffold(
//               backgroundColor: Color(0xffFAF7F0),
//             );
//           }
//           Surah surah = snapshot.data!;
//           return Scaffold(
//             backgroundColor: Color(0xffFAF7F0),
//             appBar: _appBar(context: context, surah: surah),
//           );
//         }));
//   }

//   AppBar _appBar({
//     required BuildContext context,
//     required Surah surah,
//   }) =>
//       AppBar(
//         backgroundColor: Color(0xffFAF7F0),
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               onPressed: (() => Navigator.of(context).pop()),
//               icon: Image.asset(
//                 'assets/back.png',
//                 width: 45,
//               ),
//             ),
//             SizedBox(width: 8),
//             Text(
//               surah.namaLatin,
//               style: GoogleFonts.poppins(
//                 color: Color(0xff8B5E3C),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//               ),
//             ),
//             Spacer(),
//             IconButton(
//               onPressed: () {},
//               icon: Image.asset(
//                 'assets/search.png',
//                 width: 29,
//               ),
//             ),
//           ],
//         ),
//       );
// }
