// Profile Screen - প্রোফাইল
// উপরে ছবি, নিচে Log Out, Settings, Font Size, Permissions, Notification Sound।

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A2F),
        title: const Text(
          'প্রোফাইল',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // প্রোফাইল ছবি, উপরে
            const CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xFFD4AF37),
              child: Icon(Icons.person, size: 60, color: Colors.black),
            ),
            const SizedBox(height: 12),
            const Text(
              'মির আশিকুর রহমান',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Card: 101 - Unit 1 - P/B',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 6),
            const Text(
              'Admin',
              style: TextStyle(color: Color(0xFFD4AF37), fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // মেনু লিস্ট
            Card(
              child: ListTile(
                leading: const Icon(Icons.settings, color: Color(0xFFD4AF37)),
                title: const Text('Settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.text_fields, color: Color(0xFFD4AF37)),
                title: const Text('Font Size'),
                subtitle: const Text('বড় / ছোট করুন'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock, color: Color(0xFFD4AF37)),
                title: const Text('Permissions'),
                subtitle: const Text('ক্যামেরা, মাইক, লোকেশন'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications, color: Color(0xFFD4AF37)),
                title: const Text('Notification Sound'),
                subtitle: const Text('সাউন্ড On / Off, টোন, ভাইব্রেশন, পপআপ'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.fingerprint, color: Color(0xFFD4AF37)),
                title: const Text('App Lock'),
                subtitle: const Text('ডিফল্ট Off, চাইলে On করুন'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {},
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
