// Night Bill Helper - নাইট বিল
// কোম্পানি অনুযায়ী আলাদা রেট, Fixed না। Admin / তুমি সেট করবা।

import 'package:hive/hive.dart';

class NightBillHelper {
  static const String _boxName = 'kormi_night_bill';

  // কোম্পানির রেট পাওয়া
  static Future<int> getRate(String companyId) async {
    final box = await Hive.openBox(_boxName);
    final v = box.get(companyId);
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  // কোম্পানির রেট সেট করা - শুধু Admin পারবে
  static Future<void> setRate(String companyId, int rate) async {
    final box = await Hive.openBox(_boxName);
    await box.put(companyId, rate);
  }

  // সব কোম্পানির রেট লিস্ট
  static Future<Map<String, int>> getAllRates() async {
    final box = await Hive.openBox(_boxName);
    final Map<String, int> result = {};
    for (final key in box.keys) {
      final v = box.get(key);
      if (v is int) result[key.toString()] = v;
      if (v is String) result[key.toString()] = int.tryParse(v) ?? 0;
    }
    return result;
  }

  // নাইট বিল হিসাব: কত রাত * রেট
  static int calculate({
    required int nightCount,
    required int rate,
  }) {
    return nightCount * rate;
  }

  // একজনের নাইট বিল টেক্সট
  static String formatBill({
    required String workerName,
    required String card,
    required String companyId,
    required int nightCount,
    required int rate,
  }) {
    final total = calculate(nightCount: nightCount, rate: rate);
    return '''$workerName - Card: $card
কোম্পানি: $companyId
নাইট: $nightCount x $rate টাকা = $total টাকা''';
  }
}
