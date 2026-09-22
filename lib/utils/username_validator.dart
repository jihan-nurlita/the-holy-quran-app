import 'restricted_patterns.dart';

class UsernameValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    final name = value.trim().replaceAll(RegExp(r'\s+'), ' ');

    if (name.length < 5 || name.length > 25) {
      return 'Gunakan nama lengkap';
    }

    if (!RegExp(r'^[a-zA-ZÀ-ÿ ]+$').hasMatch(name)) {
      return 'Nama hanya boleh berisi huruf';
    }

    final bannedWords = [
      'asu',
      'asuu',
      'geleh',
      'gehel',
      'gehell',
      'geheng',
      'jelek',
      'burik',
      'goreng',
      'butut',
      'norak',
      'kampungan',
      'alay',
      'lebay',
      'pisan',
      'sok suci',
      'dasar',
      'lucu',
      'anjay',
      'najis',
      'najiss',
      'anjing',
      'bangsat',
      'babi',
      'bagong',
      'anjir',
      'anjirr',
      'njirr',
      'njir',
      'bacot',
      'bacott',
      'sinting',
      'gelo',
      'miring',
      'sedeng',
      'gila',
      'anjirr',
      'anjing',
      'anying',
      'kampret',
      'gaje',
      'gajelas',
      'bodo',
      'bodoh',
      'adalah',
      'siah',
      'sia',
      'oon',
      'bego',
      'beggo',
      'maneh',
      'nyaneh',
      'maenya',
      'karep',
      'goblok',
      'goblog',
      'kumaha',
      'hantu',
      'setan',
      'jurig',
      'tolol',
      'koplok',
      'naon',
      'napa',
      'dah',
      'aing',
      'aingg',
      'urang',
      'bajing',
      'bajingan',
      'beunget',
      'sih',
      'teuing',
      'teuapal',
      'tenyaho',
      'apal',
      'meren',
      'teu',
      'nyaho',
      'apal',
      'wae',
      'keren',
      'meledak',
      'kepo',
      'bel',
      'bebel',
      'yauw',
      'amat',
      'slebew',
      'slebeww',
      'kunyuk',
      'fuck',
      'fuck you',
      'persetanan',
      'monyet',
      'mongkey',
      'nyet',
      'penyek',
      'pengek',
      'bajingan',
      'waras',
      'cager',
      'tolol',
      'bodoh',
      'aing',
      'maung',
      'endog',
      'adalah pokonamah',
      'lain',
      'ulah',
      'kumaha',
      'owalah',
      'lieur',
      'teuing',
      'bedrod',
      'bukan',
      'salah',
      'yah',
      'aya',
      'weh',
      'ouh',
      'kitu',
      'nya',
      'nyah',
      'ga ',
      'tau',
      'atuh',
      'masa ',
      'ga',
      'kenal',
      'siapa',
      'anda',
      'gua ',
      'lo',
      'lol',
      'wakwaw',
      'wkw',
    ];
    if (bannedWords.any((w) => name.toLowerCase().contains(w))) {
      return 'Nama tidak sopan';
    }

    // terlalu banyak huruf sama (asuuu, heyyy)
    if (RegExp(r'(.)\1{2,}').hasMatch(name.toLowerCase())) {
      return 'Nama tidak valid';
    }

    // vokal terlalu dominan (aaaeeeii)
    if (RegExp(r'[aeiou]{4,}').hasMatch(name.toLowerCase())) {
      return 'Nama tidak valid';
    }

    // konsonan acak panjang (xkzrt)
    if (RegExp(r'[bcdfghjklmnpqrstvwxyz]{4,}').hasMatch(name.toLowerCase())) {
      return 'Nama tidak valid';
    }

    final lower = name.toLowerCase();

    // 🔒 langkah ke-3: cek semua pola terlarang
    for (final pattern in restrictedPatterns) {
      if (RegExp(pattern).hasMatch(lower)) {
        return 'Nama tidak valid';
      }
    }

    // ❌ kata terlalu aneh (satu huruf di kata)
    if (name.split(' ').any((w) => w.length == 1)) {
      return 'Nama tidak valid';
    }

    return null;
  }
}
