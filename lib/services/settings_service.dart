// Settings Service - সেটিংস Save
// সাউন্ড, ভাইব্রেশন, পপআপ, ফন্ট সাইজ, App Lock - সব Hive এ থাকবে।

import 'package:hive/hive.dart';

class SettingsService {
  static const String _boxName = 'kormi_settings';

  static Future<void> setSound(bool v) async {
    final box = await Hive.openBox(_boxName);
    await box.put('sound', v);
  }

  static Future<bool> getSound() async {
    final box = await Hive.openBox(_boxName);
    return (box.get('sound') ?? true) as bool;
  }

  static Future<void> setVibration(bool v) async {
    final box = await Hive.openBox(_boxName);
    await box.put('vibration', v);
  }

  static Future<bool> getVibration() async {
    final box = await Hive.openBox(_boxName);
    return (box.get('vibration') ?? true) as bool;
  }

  static Future<void> setPopup(bool v) async {
    final box = await Hive.openBox(_boxName);
    await box.put('popup', v);
  }

  static Future<bool> getPopup() async {
    final box = await Hive.openBox(_boxName);
    return (box.get('popup') ?? true) as bool;
  }

  static Future<void> setFontSize(double v) async {
    final box = await Hive.openBox(_boxName);
    await box.put('fontSize', v);
  }

  static Future<double> getFontSize() async {
    final box = await Hive.openBox(_boxName);
    final v = box.get('fontSize');
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return 16.0;
  }

  static Future<void> setTone(String tone) async {
    final box = await Hive.openBox(_boxName);
    await box.put('tone', tone);
  }

  static Future<String> getTone() async {
    final box = await Hive.openBox(_boxName);
    return (box.get('tone') ?? 'Default Tone') as String;
  }

  static Future<void> setLanguage(String lang) async {
    final box = await Hive.openBox(_boxName);
    await box.put('language', lang);
  }

  static Future<String> getLanguage() async {
    final box = await Hive.openBox(_boxName);
    return (box.get('language') ?? 'বাংলা') as String;
  }
}
