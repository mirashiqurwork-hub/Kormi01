// Backup Service - ব্যাকআপ / রিস্টোর
// Encrypted DB + Settings + Backup। Logout করলে ডাটা ডিলিট হবে না।

import 'dart:convert';
import 'package:hive/hive.dart';

class BackupService {
  static const List<String> _boxes = [
    'kormi_companies',
    'kormi_workers',
    'kormi_attendance',
    'kormi_production',
    'kormi_messages',
    'kormi_settings',
    'kormi_users',
    'kormi_auth',
  ];

  // সব Box -> JSON String
  static Future<String> exportAll() async {
    final Map<String, dynamic> all = {};
    for (final name in _boxes) {
      try {
        final box = await Hive.openBox(name);
        final Map<String, dynamic> data = {};
        for (final key in box.keys) {
          data[key.toString()] = box.get(key);
        }
        all[name] = data;
      } catch (_) {
        all[name] = {};
      }
    }
    all['backup_date'] = DateTime.now().toIso8601String();
    all['app'] = 'KORMI';
    return jsonEncode(all);
  }

  // JSON String -> সব Box এ ফেরত
  static Future<bool> importAll(String jsonString) async {
    try {
      final Map<String, dynamic> all = jsonDecode(jsonString);
      for (final name in _boxes) {
        if (all.containsKey(name)) {
          final box = await Hive.openBox(name);
          final Map<String, dynamic> data = Map<String, dynamic>.from(all[name] ?? {});
          for (final e in data.entries) {
            await box.put(e.key, e.value);
          }
        }
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  // একটা Box এর ব্যাকআপ
  static Future<String> exportBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    final Map<String, dynamic> data = {};
    for (final key in box.keys) {
      data[key.toString()] = box.get(key);
    }
    return jsonEncode({'box': boxName, 'data': data, 'date': DateTime.now().toIso8601String()});
  }

  // Audit Log - কে কখন কী করলো
  static Future<void> addAudit({
    required String user,
    required String action,
    required String detail,
  }) async {
    final box = await Hive.openBox('kormi_audit');
    await box.add({
      'user': user,
      'action': action,
      'detail': detail,
      'time': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map>> getAudit() async {
    final box = await Hive.openBox('kormi_audit');
    final List<Map> list = [];
    for (int i = box.length - 1; i >= 0; i--) {
      final v = box.getAt(i);
      if (v is Map) list.add(v);
      if (list.length >= 100) break;
    }
    return list;
  }
}
