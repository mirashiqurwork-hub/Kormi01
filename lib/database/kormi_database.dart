import 'package:hive_flutter/hive_flutter.dart';

class KormiDatabase {
  static Box? _box;

  static Box get box {
    if (_box == null) {
      throw Exception('KormiDatabase is not initialized. Call KormiDatabase.init() first.');
    }
    return _box!;
  }

  static Future<void> init() async {
    if (Hive.isBoxOpen('kormi_box')) {
      _box = Hive.box('kormi_box');
    } else {
      _box = await Hive.openBox('kormi_box');
    }
  }

  static Future<void> saveWorker(Map<String, dynamic> worker) async {
    final List<dynamic> workers = _box!.get('workers', defaultValue: []) as List<dynamic>;
    workers.add(worker);
    await _box!.put('workers', workers);
  }

  static List<Map<String, dynamic>> getWorkers() {
    final List<dynamic> list = _box?.get('workers', defaultValue: []) as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> deleteWorker(String cardNumber) async {
    final List<Map<String, dynamic>> workers = getWorkers();
    workers.removeWhere((w) => (w['cardNumber'] ?? '').toString() == cardNumber);
    await _box!.put('workers', workers);
  }

  static Future<void> saveAttendance(Map<String, dynamic> attendance) async {
    final List<dynamic> list = _box!.get('attendance', defaultValue: []) as List<dynamic>;
    list.add(attendance);
    await _box!.put('attendance', list);
  }

  static List<Map<String, dynamic>> getAttendance() {
    final List<dynamic> list = _box?.get('attendance', defaultValue: []) as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> saveProduction(Map<String, dynamic> production) async {
    final List<dynamic> list = _box!.get('production', defaultValue: []) as List<dynamic>;
    list.add(production);
    await _box!.put('production', list);
  }

  static List<Map<String, dynamic>> getProduction() {
    final List<dynamic> list = _box?.get('production', defaultValue: []) as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> saveBreakdown(Map<String, dynamic> breakdown) async {
    final List<dynamic> list = _box!.get('breakdown', defaultValue: []) as List<dynamic>;
    list.add(breakdown);
    await _box!.put('breakdown', list);
  }

  static List<Map<String, dynamic>> getBreakdown() {
    final List<dynamic> list = _box?.get('breakdown', defaultValue: []) as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> clearAll() async {
    await _box!.clear();
  }
}
