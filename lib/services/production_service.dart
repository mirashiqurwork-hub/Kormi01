// Production Service - প্রোডাকশন ডাটা
// Date / Unit / Shift / Machine দিয়ে Entry। History: Unit -> Shift -> Machine।

import 'package:hive/hive.dart';

class ProductionService {
  static const String _boxName = 'kormi_production';

  // Entry Save
  static Future<void> saveEntry({
    required String companyId,
    required String unit,
    required String shift, // Permanent Shift P/A, P/B, P/C
    required String runningShift, // R/A, R/B, R/C
    required String date, // YYYY-MM-DD
    required String machine, // Carding, Drawing, Simplex, Ring, Winding, Packing
    required double value,
    required String unitType, // Kg, m/min, yd/min
  }) async {
    final box = await Hive.openBox(_boxName);
    final key = '${date}_${unit}_${shift}_${machine}';
    await box.put(key, {
      'companyId': companyId,
      'unit': unit,
      'shift': shift,
      'runningShift': runningShift,
      'date': date,
      'machine': machine,
      'value': value,
      'unitType': unitType,
      'time': DateTime.now().toIso8601String(),
    });
  }

  // এক দিনের সব Entry
  static Future<List<Map>> getByDateUnitShift({
    required String date,
    required String unit,
    required String shift,
  }) async {
    final box = await Hive.openBox(_boxName);
    final List<Map> result = [];
    for (final key in box.keys) {
      final v = box.get(key);
      if (v is Map && v['date'] == date && v['unit'] == unit && v['shift'] == shift) {
        result.add(v);
      }
    }
    return result;
  }

  // History: Unit -> Shift -> Machine
  static Future<List<Map>> getHistory({
    required String unit,
    String? shift,
    String? machine,
  }) async {
    final box = await Hive.openBox(_boxName);
    final List<Map> result = [];
    for (final key in box.keys) {
      final v = box.get(key);
      if (v is Map && v['unit'] == unit) {
        if (shift != null && v['shift'] != shift) continue;
        if (machine != null && v['machine'] != machine) continue;
        result.add(v);
      }
    }
    result.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));
    return result;
  }

  // Calculator Formulas
  // TPI = TM x sqrt(Count)
  static double calcTPI({required double tm, required double count}) {
    if (count <= 0) return 0;
    return tm * _sqrt(count);
  }

  static double _sqrt(double v) {
    double x = v / 2;
    for (int i = 0; i < 10; i++) {
      x = (x + v / x) / 2;
    }
    return x;
  }

  // Kg/hr = (RPM * 60 * Tex) / (TPI * 1000 * 1000) - Simplified, আসল ফর্মুলা Calculator স্ক্রিনে আছে
  static double calcKgPerHour({
    required double rpm,
    required double tex,
    required double tpi,
  }) {
    if (tpi == 0) return 0;
    return (rpm * 60 * tex) / (tpi * 1000 * 1000) * 1000;
  }

  static double calc8HourTotal(double kgPerHour) => kgPerHour * 8;
}
