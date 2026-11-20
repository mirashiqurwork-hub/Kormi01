// Security Service - সিকিউরিটি
// স্ক্রিনশট ব্লক (Sensitive স্ক্রিনে), রুট ওয়ার্নিং, Encrypted DB / Settings / Backup, HTTPS only।

import 'dart:convert';

class SecurityService {
  // Sensitive স্ক্রিনে স্ক্রিনশট ব্লক হবে কিনা
  // Workers / Attendance / Production / Messages / Profile - Sensitive
  static bool shouldBlockScreenshot(String screenName) {
    const sensitive = [
      'Workers',
      'Attendance',
      'Production',
      'Messages',
      'Profile',
      'Admin',
      'Overtime',
    ];
    return sensitive.contains(screenName);
  }

  // Root চেক - আসল চেকে root_checker প্যাকেজ লাগবে, এখন Safe ধরে নিচ্ছি
  // Private করার পর আসল Root চেক চালু হবে
  static Future<bool> isRooted() async {
    return false;
  }

  static String rootWarningText() {
    return 'তোমার ফোন Root করা মনে হচ্ছে। KORMI তে Sensitive ডাটা আছে, সাবধানে ব্যবহার করো।';
  }

  // হালকা Encrypt - আসল অ্যাপে Hive Encrypted Box ব্যবহার হবে
  // এখন লাইট Encrypt, যাতে ডাটা খালি চোখে পড়া না যায়
  static String encrypt(String plain, String key) {
    final plainBytes = utf8.encode(plain);
    final keyBytes = utf8.encode(key);
    final out = <int>[];
    for (int i = 0; i < plainBytes.length; i++) {
      out.add(plainBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    return base64Encode(out);
  }

  static String decrypt(String encrypted, String key) {
    try {
      final encBytes = base64Decode(encrypted);
      final keyBytes = utf8.encode(key);
      final out = <int>[];
      for (int i = 0; i < encBytes.length; i++) {
        out.add(encBytes[i] ^ keyBytes[i % keyBytes.length]);
      }
      return utf8.decode(out);
    } catch (_) {
      return '';
    }
  }

  // HTTPS only - http লিংক ব্লক
  static bool isHttps(String url) {
    return url.startsWith('https://');
  }

  // পাসওয়ার্ড শক্ত কিনা চেক
  static bool isStrongPassword(String pass) {
    if (pass.length < 6) return false;
    return true;
  }
}
