import 'package:flutter/material.dart';
import 'package:the_holy_quran/pages/doa/detail_doa_page.dart';
import 'doa_data.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  List<DoaModel> filteredDoa = [];

  String selectedCategory = "Semua";

  final List<String> categories = [
    "Semua",
    "Shalawat",
    "Dzikir Pagi",
    "Dzikir Petang",
  ];

  @override
  void initState() {
    super.initState();
    filteredDoa = doaList;
  }

  void searchDoa(String keyword) {
    final result = doaList.where((doa) {
      final matchKeyword =
          doa.judul.toLowerCase().contains(keyword.toLowerCase());

      final matchCategory = selectedCategory == "Semua"
          ? true
          : doa.kategori.contains(selectedCategory);

      return matchKeyword && matchCategory;
    }).toList();

    setState(() {
      filteredDoa = result;
    });
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;

      if (category == "Semua") {
        filteredDoa = doaList;
      } else {
        filteredDoa =
            doaList.where((e) => e.kategori.contains(category)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xffFAF7F0),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Doa Harian",
          style: TextStyle(
            color: Color(0xff8B5E3C),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          /// SEARCH & CATEGORY
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 20,
            ),
            child: Column(
              children: [
                /// SEARCH
                TextField(
                  onChanged: searchDoa,
                  decoration: InputDecoration(
                    hintText: "Cari doa & dzikir harian...",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'assets/search.png',
                        width: 20,
                        height: 20,
                        color: const Color(0xff8B5E3C),
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xffEDE4DB),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: Color(0xff8B5E3C),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// CATEGORY
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isActive = selectedCategory == cat;

                      return GestureDetector(
                        onTap: () => filterByCategory(cat),
                        child: Container(
                          margin: const EdgeInsets.only(
                            right: 10,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xff8B5E3C)
                                : const Color(0xffEDE4DB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : const Color(0xff8B5E3C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// LIST DOA
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 24,
              ),
              itemCount: filteredDoa.length,
              itemBuilder: (context, index) {
                final doa = filteredDoa[index];

                return DoaTile(
                  number: "${index + 1}",
                  title: doa.judul,
                  doa: doa,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DoaTile extends StatelessWidget {
  final String number;
  final String title;
  final DoaModel doa;

  const DoaTile({
    super.key,
    required this.number,
    required this.title,
    required this.doa,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(doa: doa),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 16,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xffEDE4DB),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            /// NOMOR
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xff8B5E3C),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// JUDUL
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xff6F7075),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            /// ARROW
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Color(0xff8B5E3C),
            ),
          ],
        ),
      ),
    );
  }
}
