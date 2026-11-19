// Dashboard Screen - ড্যাশবোর্ড
// ৮টা কার্ড, উপরে ডান পাশে প্রোফাইল ছবি, তার বামে বেল আইকন।

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ১টা কার্ড বানানোর ফাংশন
  Widget _card(BuildContext context, String title, String bangla, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        // পরে এইখানে নেভিগেশন আসবে
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$bangla খুলতেছে...')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFFD4AF37)),
            const SizedBox(height: 8),
            Text(
              bangla,
              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A2F),
        title: const Text(
          'KORMI',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          // বেল আইকন, প্রোফাইলের বামে
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          // প্রোফাইল ছবি, উপরে ডান পাশে
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {},
              child: const CircleAvatar(
                backgroundColor: Color(0xFFD4AF37),
                child: Icon(Icons.person, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _card(context, 'Workers', 'শ্রমিক', Icons.people, '/workers'),
            _card(context, 'Attendance', 'হাজিরা', Icons.check_circle, '/attendance'),
            _card(context, 'Production', 'উৎপাদন', Icons.factory, '/production'),
            _card(context, 'Manpower', 'ম্যানপাওয়ার', Icons.groups, '/manpower'),
            _card(context, 'Breakdown', 'ব্রেকডাউন', Icons.build, '/breakdown'),
            _card(context, 'Messages', 'মেসেজ', Icons.message, '/messages'),
            _card(context, 'Location', 'লোকেশন', Icons.location_on, '/location'),
            _card(context, 'ASK AI', 'ASK AI', Icons.mic, '/askai'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0A1A2F),
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.factory), label: 'Production'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Team'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
