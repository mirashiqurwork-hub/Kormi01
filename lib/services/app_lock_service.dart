// App Lock Service - অ্যাপ লক
// ডিফল্ট Off। চাইলে On করলে ফিঙ্গার / PIN দিয়ে অ্যাপ খুলবে।

import 'package:hive/hive.dart';

class AppLockService {
  static const String _boxName = 'kormi_settings';

  static Future<bool> isEnabled() async {
    try {
      final box = await Hive.openBox(_boxName);
      return (box.get('app_lock') ?? false) as bool;
    } catch (_) {
      return false;
    }
  }

  static Future<void> setEnabled(bool enabled) async {
    final box = await Hive.openBox(_boxName);
    await box.put('app_lock', enabled);
  }

  static Future<bool> shouldAskLock() async {
    final enabled = await isEnabled();
    if (!enabled) return false;
    return true;
  }

  // PIN - সহজ 4 সংখ্যার PIN
  static Future<void> setPin(String pin) async {
    final box = await Hive.openBox(_boxName);
    await box.put('app_lock_pin', pin);
  }

  static Future<bool> checkPin(String pin) async {
    try {
      final box = await Hive.openBox(_boxName);
      final saved = box.get('app_lock_pin') as String?;
      if (saved == null || saved.isEmpty) return true;
      return saved == pin;
    } catch (_) {
      return true;
    }
  }

  static Future<void> clearPin() async {
    final box = await Hive.openBox(_boxName);
    await box.delete('app_lock_pin');
  }
}
