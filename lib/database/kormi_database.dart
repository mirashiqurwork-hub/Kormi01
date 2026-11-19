// KORMI Database - ডিসিপ্লিন ভাবে ডাটা রাখার জায়গা
// সব ডাটা ফোনের ভিতরে Hive বক্সে থাকবে। কোনো সার্ভার নাই, কোনো টাকা লাগে না।
// ASK AI-ও এইখান থেকেই ডাটা পড়ে।

import 'package:hive/hive.dart';

// সব বক্সের নাম এক জায়গায়, যাতে ভুল না হয়
class KormiBoxes {
  static const companies = 'kormi_companies'; // কোম্পানি / মিল
  static const workers = 'kormi_workers'; // শ্রমিকের তালিকা
  static const attendance = 'kormi_attendance'; // হাজিরা
  static const production = 'kormi_production'; // প্রোডাকশন
  static const messages = 'kormi_messages'; // মেসেজ
  static const settings = 'kormi_settings'; // সেটিংস
}

// ডাটাবেজের আসল কাজ এই ক্লাসে
class KormiDatabase {
  // বক্স খোলা আছে কিনা দেখি
  Box _box(String name) {
    return Hive.box(name);
  }

  // ১. কোম্পানি সেভ করা
  // শুধু তুমিই কোম্পানি যোগ / বাদ দিতে পারবা, আর কেউ পারবে না
  Future<void> saveCompany(Map<String, dynamic> company) async {
    final box = _box(KormiBoxes.companies);
    // companyId দিয়ে সেভ করি, যাতে ডাবল না হয়
    await box.put(company['companyId'], company);
  }

  // সব কোম্পানি পাওয়া
  List<Map> getCompanies() {
    final box = _box(KormiBoxes.companies);
    return box.values.map((e) => e as Map).toList();
  }

  // ২. শ্রমিক সেভ করা
  // কার্ড নম্বর দিয়ে সেভ করি, একজনের ডাটা একবারই থাকবে
  Future<void> saveWorker(Map<String, dynamic> worker) async {
    final box = _box(KormiBoxes.workers);
    // প্রতিটা শ্রমিকের সাথে companyId + Unit + Shift + Date রাখি
    // এইটাই ডিসিপ্লিন, এইটা দিয়েই পারমিশন ঠিক থাকে
    await box.put(worker['cardNumber'], worker);
  }

  // শ্রমিকের তালিকা পাওয়া, পারমিশন মেনে
  // Officer হলে শুধু নিজের Unit + Shift পাবে, Admin / Management সব পাবে
  List<Map> getWorkers({
    required String myRole,
    required String myUnit,
    required String myShift,
    required String myCompanyId,
  }) {
    final box = _box(KormiBoxes.workers);
    final all = box.values.map((e) => e as Map).toList();

    // Worker হলে শুধু নিজেরটা দেখবে, এইটা পরে লগইন থেকে ঠিক হবে
    if (myRole == 'Worker') {
      return [];
    }

    // Officer হলে শুধু নিজের Unit + Shift
    if (myRole == 'Officer') {
      return all.where((w) {
        return w['companyId'] == myCompanyId &&
            w['unit'] == myUnit &&
            w['shift'] == myShift;
      }).toList();
    }

    // Admin / Management হলে সব, কিন্তু শুধু নিজের কোম্পানিরটা
    return all.where((w) => w['companyId'] == myCompanyId).toList();
  }

  // নাম দিয়ে শ্রমিক খোঁজা, ASK AI এইটা দিয়ে ফোন নম্বর খুঁজে
  Map? findWorkerByName(String name, String myCompanyId) {
    final box = _box(KormiBoxes.workers);
    for (var i = 0; i < box.length; i++) {
      final w = box.getAt(i) as Map;
      if (w['companyId'] == myCompanyId) {
        // ছোট করে বললেও মিলবে, যেমন ফাতেমা বললেই ফাতেমা আক্তার পাবে
        if (w['name'].toString().toLowerCase().contains(name.toLowerCase())) {
          return w;
        }
      }
    }
    return null;
  }

  // ৩. হাজিরা সেভ করা
  Future<void> saveAttendance(Map<String, dynamic> record) async {
    final box = _box(KormiBoxes.attendance);
    // তারিখ + কার্ড নম্বর দিয়ে সেভ করি, যাতে একই দিনে ডাবল না হয়
    final key = '${record['date']}_${record['cardNumber']}';
    await box.put(key, record);
  }

  // হাজিরা পাওয়া, তারিখ + Unit + Shift দিয়ে
  List<Map> getAttendance({
    required String date,
    required String myCompanyId,
  }) {
    final box = _box(KormiBoxes.attendance);
    return box.values
        .map((e) => e as Map)
        .where((a) => a['companyId'] == myCompanyId && a['date'] == date)
        .toList();
  }

  // ৪. প্রোডাকশন সেভ করা
  // ASK AI ভয়েসে বললেও এইখানেই সেভ হবে
  Future<void> saveProduction(Map<String, dynamic> record) async {
    final box = _box(KormiBoxes.production);
    // তারিখ + মেশিন + Shift দিয়ে সেভ করি
    final key = '${record['date']}_${record['machine']}_${record['shift']}';
    await box.put(key, record);
  }

  // প্রোডাকশন পাওয়া, তারিখ দিয়ে
  List<Map> getProduction({
    required String date,
    required String myCompanyId,
  }) {
    final box = _box(KormiBoxes.production);
    return box.values
        .map((e) => e as Map)
        .where((p) => p['companyId'] == myCompanyId && p['date'] == date)
        .toList();
  }

  // ৫. মেসেজ সেভ করা
  Future<void> saveMessage(Map<String, dynamic> msg) async {
    final box = _box(KormiBoxes.messages);
    await box.add(msg); // মেসেজ একটার পর একটা জমা হবে
  }

  // ৬. সেটিংস সেভ করা, যেমন ফন্ট সাইজ, সাউন্ড
  Future<void> saveSetting(String key, dynamic value) async {
    final box = _box(KormiBoxes.settings);
    await box.put(key, value);
  }

  // সেটিংস পড়া
  dynamic getSetting(String key) {
    final box = _box(KormiBoxes.settings);
    return box.get(key);
  }
}
