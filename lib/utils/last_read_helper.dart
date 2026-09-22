import 'package:shared_preferences/shared_preferences.dart';

class LastReadHelper {
  static const _key = 'last_surah';

  static Future<void> saveLastSurah(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, index);
  }

  static Future<int?> getLastSurah() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key);
  }
}
