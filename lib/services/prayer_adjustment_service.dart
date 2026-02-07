import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerAdjustmentService {
  static const String _key = 'prayer_adjustments';

  static Future<Map<String, int>> load(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) return {};

    final Map<String, dynamic> decoded = jsonDecode(raw);
    final Map<String, int> result = {};

    decoded.forEach((k, v) {
      if (k.startsWith(date)) {
        final prayer = k.split('_')[1];
        result[prayer] = v;
      }
    });

    return result;
  }

  static Future<void> save(
      String date, String prayer, int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    final Map<String, dynamic> data =
        raw == null ? {} : jsonDecode(raw);

    data['${date}_$prayer'] = minutes;

    await prefs.setString(_key, jsonEncode(data));
  }
}
