// Location Service - লাইভ লোকেশন
// Worker শুধু নিজের লোকেশন শেয়ার করবে। Admin / Management / Officer অন্যদেরটা দেখতে পারবে।
// Private করার পর আসল Maps Key বসবে।

import 'package:hive/hive.dart';

class LocationService {
  static const String _boxName = 'kormi_location';

  // আমার লোকেশন Save করা
  static Future<void> saveMyLocation({
    required String card,
    required String name,
    required String unit,
    required double lat,
    required double lng,
    required String place,
  }) async {
    final box = await Hive.openBox(_boxName);
    await box.put(card, {
      'card': card,
      'name': name,
      'unit': unit,
      'lat': lat,
      'lng': lng,
      'place': place,
      'time': DateTime.now().toIso8601String(),
    });
  }

  // সব লোকেশন পাওয়া
  static Future<List<Map>> getAllLocations() async {
    final box = await Hive.openBox(_boxName);
    final List<Map> list = [];
    for (final key in box.keys) {
      final v = box.get(key);
      if (v is Map) list.add(v);
    }
    return list;
  }

  // একজনের লোকেশন
  static Future<Map?> getLocation(String card) async {
    final box = await Hive.openBox(_boxName);
    final v = box.get(card);
    if (v is Map) return v;
    return null;
  }

  // Permission চেক - Worker শুধু নিজেরটা
  static bool canViewLocation({
    required String myRole,
    required String myCard,
    required String targetCard,
  }) {
    if (myRole == 'Worker') return myCard == targetCard;
    return true;
  }
}
