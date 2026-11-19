// Settings Screen - সেটিংস
// সাউন্ড, ভাইব্রেশন, পপআপ, ফন্ট সাইজ, App Lock - সব এখানে।

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundOn = true;
  bool _vibrationOn = true;
  bool _popupOn = true;
  bool _appLockOn = false; // ডিফল্ট Off
  double _fontSize = 16;
  String _tone = 'Default Tone';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A2F),
        title: const Text(
          'সেটিংস',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // নোটিফিকেশন সাউন্ড
            Card(
              child: SwitchListTile(
                title: const Text('নোটিফিকেশন সাউন্ড'),
                subtitle: const Text('On / Off'),
                value: _soundOn,
                activeColor: const Color(0xFFD4AF37),
                onChanged: (v) => setState(() => _soundOn = v),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('টোন বাছুন'),
                subtitle: Text(_tone),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            Card(
              child: SwitchListTile(
                title: const Text('ভাইব্রেশন'),
                value: _vibrationOn,
                activeColor: const Color(0xFFD4AF37),
                onChanged: (v) => setState(() => _vibrationOn = v),
              ),
            ),
            Card(
              child: SwitchListTile(
                title: const Text('পপআপ দেখাবে'),
                subtitle: const Text('ছোট মেসেজ পুরোটা, বড় মেসেজ প্রথম ২ লাইন + ...'),
                value: _popupOn,
                activeColor: const Color(0xFFD4AF37),
                onChanged: (v) => setState(() => _popupOn = v),
              ),
            ),
            // ফন্ট সাইজ
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ফন্ট সাইজ: ${_fontSize.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Slider(
                      value: _fontSize,
                      min: 12,
                      max: 24,
                      activeColor: const Color(0xFFD4AF37),
                      onChanged: (v) => setState(() => _fontSize = v),
                    ),
                    Text(
                      'সাধারণ মানুষের জন্য বড় লেখা ভালো',
                      style: TextStyle(fontSize: _fontSize),
                    ),
                  ],
                ),
              ),
            ),
            // App Lock
            Card(
              child: SwitchListTile(
                title: const Text('App Lock'),
                subtitle: const Text('ফিঙ্গার দিয়ে অ্যাপ খুলবে। ডিফল্ট Off।'),
                value: _appLockOn,
                activeColor: const Color(0xFFD4AF37),
                onChanged: (v) => setState(() => _appLockOn = v),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Permissions'),
                subtitle: const Text('ক্যামেরা, মাইক, লোকেশন অনুমতি'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('ভাষা'),
                subtitle: const Text('বাংলা'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 16),
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
