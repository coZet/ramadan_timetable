import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  static Future<List<Map<String, dynamic>>> loadRamadanData() async {
    final jsonStr =
        await rootBundle.loadString('assets/data/ramadan_1447.json');

    final Map<String, dynamic> data = json.decode(jsonStr);
    return List<Map<String, dynamic>>.from(data['days']);
  }
}
