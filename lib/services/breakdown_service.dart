// Breakdown Service - ব্রেকডাউন
// Machine বন্ধ হলে Entry। OCR দিয়েও তোলা যাবে।

import 'package:hive/hive.dart';

class BreakdownService {
  static const String _boxName = 'kormi_breakdown';

  static Future<void> addBreakdown({
    required String companyId,
    required String unit,
    required String shift,
    required String date,
    required String machine,
    required String reason,
    required String duration, // যেমন: 20 মিনিট
    String status = 'চলতেছে', // চলতেছে / ঠিক হইছে
  }) async {
    final box = await Hive.openBox(_boxName);
    await box.add({
      'companyId': companyId,
      'unit': unit,
      'shift': shift,
      'date': date,
      'machine': machine,
      'reason': reason,
      'duration': duration,
      'status': status,
      'time': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map>> getBreakdowns({
    required String unit,
    String? date,
  }) async {
    final box = await Hive.openBox(_boxName);
    final List<Map> result = [];
    for (int i = box.length - 1; i >= 0; i--) {
      final v = box.getAt(i);
      if (v is Map && v['unit'] == unit) {
        if (date != null && v['date'] != date) continue;
        result.add(v);
      }
    }
    return result;
  }

  static Future<void> markFixed(int index) async {
    final box = await Hive.openBox(_boxName);
    final v = box.getAt(index);
    if (v is Map) {
      v['status'] = 'ঠিক হইছে';
      await box.putAt(index, v);
    }
  }
}
