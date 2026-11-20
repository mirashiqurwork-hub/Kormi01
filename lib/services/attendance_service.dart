// Attendance Service - হাজিরা
// Date / Unit / Permanent Shift। Present / Absent / Off। সাপ্তাহিক ছুটি Auto Off।
// Manpower গণনা: শুধু Active + Present।

import 'package:hive/hive.dart';

class AttendanceService {
  static const String _boxName = 'kormi_attendance';

  // হাজিরা Save - একদিনের এক Unit / Shift এর
  static Future<void> saveAttendance({
    required String companyId,
    required String unit,
    required String shift, // Permanent Shift P/A, P/B, P/C
    required String date, // YYYY-MM-DD
    required Map<String, String> statusByCard, // card -> Present / Absent / Off
  }) async {
    final box = await Hive.openBox(_boxName);
    final key = '${date}_${unit}_$shift';
    await box.put(key, {
      'companyId': companyId,
      'unit': unit,
      'shift': shift,
      'date': date,
      'data': statusByCard,
      'time': DateTime.now().toIso8601String(),
    });
  }

  // এক দিনের হাজিরা পাওয়া
  static Future<Map<String, String>> getAttendance({
    required String unit,
    required String shift,
    required String date,
  }) async {
    final box = await Hive.openBox(_boxName);
    final key = '${date}_${unit}_$shift';
    final v = box.get(key);
    if (v is Map && v['data'] is Map) {
      final Map<String, String> result = {};
      (v['data'] as Map).forEach((k, val) {
        result[k.toString()] = val.toString();
      });
      return result;
    }
    return {};
  }

  // Manpower এর জন্য Present গণনা - Active + Present শুধু
  static Future<int> countPresent({
    required String unit,
    required String shift,
    required String date,
    required List<Map> workers, // Active workers list
  }) async {
    final att = await getAttendance(unit: unit, shift: shift, date: date);
    int count = 0;
    for (final w in workers) {
      final card = w['card']?.toString() ?? '';
      if (w['status'] != 'Active') continue;
      if (att[card] == 'Present') count++;
    }
    return count;
  }

  // সাপ্তাহিক ছুটি Auto Off - শুক্রবার Off
  static bool isWeeklyOff(DateTime date) {
    return date.weekday == DateTime.friday;
  }

  // Present List OCR নিয়ম: Present List এ যারা আছে তারা Present, বাকি সবাই Absent। Off আগের মতো Off থাকবে।
  static Map<String, String> applyPresentList({
    required List<String> allCards,
    required List<String> presentCards,
    required List<String> offCards,
  }) {
    final Map<String, String> result = {};
    for (final card in allCards) {
      if (offCards.contains(card)) {
        result[card] = 'Off';
      } else if (presentCards.contains(card)) {
        result[card] = 'Present';
      } else {
        result[card] = 'Absent';
      }
    }
    return result;
  }
}
