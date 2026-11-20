// Notifications Screen - নোটিফিকেশন লিস্ট
// বেল আইকনে টিপ দিলে এই লিস্ট আসবে। প্রোফাইলের Notifications শুধু সাউন্ড সেটিংস।

import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ডেমো নোটিফিকেশন
    final List<Map<String, String>> items = [
      {
        'title': '১ নম্বর ইউনিট গ্রুপ',
        'body': 'আজকের প্রোডাকশন ১২০০ কেজি হইছে',
        'time': '১০ মিনিট আগে',
        'type': 'group',
      },
      {
        'title': 'ফাতেমা আক্তার',
        'body': 'স্যার, কাল ছুটি লাগবে',
        'time': '৩০ মিনিট আগে',
        'type': 'personal',
      },
      {
        'title': 'ব্রেকডাউন',
        'body': 'রিং মেশিন ৫ বন্ধ আছে, ২০ মিনিট ধরে',
        'time': '১ ঘণ্টা আগে',
        'type': 'breakdown',
      },
      {
        'title': 'হাজিরা',
        'body': 'আজকে ১ নম্বর ইউনিটে ৪৫ জন হাজির',
        'time': '২ ঘণ্টা আগে',
        'type': 'attendance',
      },
    ];

    // পপআপ নিয়ম: ছোট মেসেজ পুরোটা, বড় মেসেজ প্রথম ২ লাইন + ...
    String shortBody(String body) {
      if (body.length <= 120) return body;
      return '${body.substring(0, 120)}...';
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A2F),
        title: const Text(
          'নোটিফিকেশন',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('সব পড়া', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFD4AF37),
                child: Icon(
                  item['type'] == 'group'
                      ? Icons.group
                      : item['type'] == 'breakdown'
                          ? Icons.build
                          : item['type'] == 'attendance'
                              ? Icons.check_circle
                              : Icons.person,
                  color: Colors.black,
                ),
              ),
              title: Text(
                item['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(shortBody(item['body']!)),
              trailing: Text(item['time']!, style: const TextStyle(fontSize: 12)),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
