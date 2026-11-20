// Notification Service - নোটিফিকেশন পপআপ + সাউন্ড
// ছোট মেসেজ পুরোটা, বড় মেসেজ প্রথম ২ লাইন / ~১২০ অক্ষর + ... ফাইল হলে টাইপ + ক্যাপশন, গ্রুপ হলে গ্রুপ নাম + Sender।

import 'package:flutter/material.dart';

class NotificationService {
  static bool soundOn = true;
  static bool vibrationOn = true;
  static bool popupOn = true;

  // পপআপের জন্য ছোট করা টেক্সট
  static String popupText({
    required String text,
    String? fileType,
    String? caption,
    String? groupName,
    String? senderName,
  }) {
    String body = text;
    if (fileType != null) {
      body = '[$fileType] ${caption ?? ''}'.trim();
    }
    if (groupName != null && senderName != null) {
      body = '$groupName - $senderName: $body';
    }
    // ছোট হলে পুরোটা
    if (body.length <= 120) return body;
    // বড় হলে প্রথম ২ লাইন / ১২০ অক্ষর
    final lines = body.split('\n');
    if (lines.length >= 2) {
      String two = '${lines[0]}\n${lines[1]}';
      if (two.length > 120) two = two.substring(0, 120);
      return '$two...';
    }
    return '${body.substring(0, 120)}...';
  }

  // পপআপ দেখানো
  static void showPopup(
    BuildContext context, {
    required String title,
    required String body,
    VoidCallback? onTap,
  }) {
    if (!popupOn) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(body, style: const TextStyle(color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFF0A1D3F),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'দেখুন',
          textColor: const Color(0xFFD4AF37),
          onPressed: () {
            if (onTap != null) onTap();
          },
        ),
      ),
    );
  }

  // সাউন্ড / ভাইব্রেশন সেটিংস
  static void setSound(bool v) => soundOn = v;
  static void setVibration(bool v) => vibrationOn = v;
  static void setPopup(bool v) => popupOn = v;
}
