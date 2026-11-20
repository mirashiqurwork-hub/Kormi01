// Worker Service - শ্রমিক ডাটা
// Card Number Unique। CompanyId + Unit + Shift + Date সব রেকর্ডে থাকবে।

import 'package:hive/hive.dart';

class WorkerService {
  static const String _boxName = 'kormi_workers';

  // শ্রমিক যোগ করা
  static Future<bool> addWorker({
    required String companyId,
    required String card,
    required String name,
    required String unit,
    required String shift, // Permanent Shift P/A, P/B, P/C
    required String section, // Back / Ring / A/Cone
    String phone = '',
    String status = 'Active', // Active / Pending
  }) async {
    final box = await Hive.openBox(_boxName);
    // Card Unique চেক
    for (final key in box.keys) {
      final v = box.get(key);
      if (v is Map && v['card']?.toString() == card && v['companyId'] == companyId) {
        return false;
      }
    }
    await box.put('${companyId}_$card', {
      'companyId': companyId,
      'card': card,
      'name': name,
      'unit': unit,
      'shift': shift,
      'section': section,
      'phone': phone,
      'status': status,
      'created': DateTime.now().toIso8601String(),
    });
    return true;
  }

  // এক কোম্পানির সব শ্রমিক - প্রথম 50 জন, Superfast
  static Future<List<Map>> getWorkers({
    required String companyId,
    String? unit,
    String? shift,
    String? section,
    int limit = 50,
  }) async {
    final box = await Hive.openBox(_boxName);
    final List<Map> result = [];
    for (final key in box.keys) {
      final v = box.get(key);
      if (v is Map && v['companyId'] == companyId) {
        if (unit != null && v['unit'] != unit) continue;
        if (shift != null && v['shift'] != shift) continue;
        if (section != null && v['section'] != section) continue;
        result.add(v);
        if (result.length >= limit) break;
      }
    }
    return result;
  }

  // একজনের প্রোফাইল
  static Future<Map?> getWorker(String companyId, String card) async {
    final box = await Hive.openBox(_boxName);
    final v = box.get('${companyId}_$card');
    if (v is Map) return v;
    return null;
  }

  // Active শুধু
  static Future<List<Map>> getActiveWorkers(String companyId) async {
    final box = await Hive.openBox(_boxName);
    final List<Map> result = [];
    for (final key in box.keys) {
      final v = box.get(key);
      if (v is Map && v['companyId'] == companyId && v['status'] == 'Active') {
        result.add(v);
      }
    }
    return result;
  }

  // Pending Approve
  static Future<void> approveWorker(String companyId, String card) async {
    final box = await Hive.openBox(_boxName);
    final v = box.get('${companyId}_$card');
    if (v is Map) {
      v['status'] = 'Active';
      await box.put('${companyId}_$card', v);
    }
  }

  // ফোন নম্বর - ASK AI এর জন্য
  static Future<String> getPhone(String companyId, String card) async {
    final w = await getWorker(companyId, card);
    if (w != null) return w['phone']?.toString() ?? '';
    return '';
  }
}
