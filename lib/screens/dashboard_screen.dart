// KORMI - Dashboard Screen
// সব কার্ড আসল Module খুলবে - Coming Soon নাই

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';
import 'workers_screen.dart';
import 'attendance_screen.dart';
import 'production_screen.dart';
import 'manpower_screen.dart';
import 'breakdown_screen.dart';
import 'messages_screen.dart';
import 'location_screen.dart';
import 'admin_panel_screen.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';
import 'overtime_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _bottomIndex = 0;

  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Text('T', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tariqul Islam', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('CHIEF MILL ADMINISTRATOR', style: TextStyle(fontSize: 10, color: KormiColors.goldLight)),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _open(const AlertsScreen()),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(color: KormiColors.red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => _open(const ProfileScreen()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: KormiColors.navy,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: KormiColors.gold.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Today • 18 Nov 2026 • P/B Shift',
                      style: TextStyle(color: KormiColors.goldLight, fontSize: 12)),
                  const SizedBox(height: 10),
                  const Text('Unit 1 Total Output',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const Text('39,353.7 kg',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _topStat('Present', '96 / 102', Colors.white)),
                      Expanded(child: _topStat('OT Today', '7.5 hrs', KormiColors.goldLight)),
                      Expanded(child: _topStat('Breakdown', '2 Active', Colors.redAccent)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Modules', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 18)),
            const SizedBox(height: 12),

            // Grid - সব কার্ড আসল পেজ খুলবে
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                _moduleCard('Workers', '124 Workers', Icons.groups_outlined, KormiColors.navy, () => _open(const WorkersScreen())),
                _moduleCard('Attendance', '96 Present', Icons.fact_check_outlined, KormiColors.green, () => _open(const AttendanceScreen())),
                _moduleCard('Production', '39,353 kg', Icons.factory_outlined, KormiColors.gold, () => _open(const ProductionScreen())),
                _moduleCard('Manpower', '96 / 102', Icons.people_outlined, KormiColors.navy, () => _open(const ManpowerScreen())),
                _moduleCard('Breakdown', '2 Active', Icons.warning_amber_rounded, KormiColors.red, () => _open(const BreakdownScreen())),
                _moduleCard('Overtime', '7.5 hrs', Icons.access_time_outlined, KormiColors.gold, () => _open(const OvertimeScreen())),
                _moduleCard('Messages', '3 Unread', Icons.chat_outlined, KormiColors.navy, () => _open(const MessagesScreen())),
                _moduleCard('Location', 'Live', Icons.location_on_outlined, KormiColors.green, () => _open(const LocationScreen())),
                _moduleCard('Admin Panel', 'Access • Mills', Icons.admin_panel_settings_outlined, KormiColors.navy, () => _open(const AdminPanelScreen())),
                _moduleCard('Alerts', '3 New', Icons.notifications_outlined, KormiColors.red, () => _open(const AlertsScreen())),
                _moduleCard('Profile', 'My Profile', Icons.person_outlined, KormiColors.navy, () => _open(const ProfileScreen())),
                _moduleCard('Settings', 'Backup • Help', Icons.settings_outlined, KormiColors.textGrey, () => _open(const ProfileScreen())),
              ],
            ),
            const SizedBox(height: 14),
            // Quick Share
            KormiCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Share - Production Summary',
                      style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                  const SizedBox(height: 10),
                  const Text('Shift:-P/B-R/C\nproduction summary\nC/D:- 4928 kg, B/D:- 5093 kg\nPacking = 00 Bag',
                      style: TextStyle(color: KormiColors.textGrey, fontSize: 13)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _open(const ProductionScreen()),
                          icon: const Icon(Icons.copy_outlined, size: 16, color: KormiColors.navy),
                          label: const Text('Copy', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: KormiColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _open(const ProductionScreen()),
                          icon: const Icon(Icons.share_outlined, size: 16, color: KormiColors.goldLight),
                          label: const Text('Share', style: TextStyle(color: KormiColors.goldLight, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KormiColors.navy,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        onTap: (i) {
          setState(() => _bottomIndex = i);
          if (i == 1) _open(const WorkersScreen());
          if (i == 2) _open(const AttendanceScreen());
          if (i == 3) _open(const MessagesScreen());
          if (i == 4) _open(const ProfileScreen());
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: KormiColors.navy,
        unselectedItemColor: KormiColors.textGrey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Workers'),
          BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _topStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _moduleCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: KormiColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 15)),
            Text(subtitle, style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
