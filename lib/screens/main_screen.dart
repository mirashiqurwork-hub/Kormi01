// KORMI - Main Screen - REAL NAVIGATION
// Dashboard + All Modules Bottom Navigation - আসল Wiring

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';
import 'dashboard_screen.dart';
import 'workers_screen.dart';
import 'attendance_screen.dart';
import 'production_screen.dart';
import 'manpower_screen.dart';
import 'breakdown_screen.dart';
import 'messages_screen.dart';
import 'alerts_screen.dart';
import 'overtime_screen.dart';
import 'location_screen.dart';
import 'admin_panel_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Dashboard এর onNavigate Index -> Main Index Mapping
  // Dashboard: 0=Dashboard, 1=Workers, 2=Attendance, 3=Production, 4=Manpower,
  // 5=Breakdown, 6=Messages, 7=Alerts, 8=Overtime, 9=Location, 10=Admin, 11=Profile
  // Main Bottom Nav: 0=Home, 1=Workers, 2=Attendance, 3=Production, 4=More
  // More Screen থেকে বাকি Module গুলো খুলবে

  void _onDashboardNavigate(int dashboardIndex) {
    // Dashboard থেকে যেই Module এ যেতে চায়, সেটা খুলবে
    if (dashboardIndex == 0) {
      setState(() => _currentIndex = 0);
      return;
    }
    if (dashboardIndex >= 1 && dashboardIndex <= 3) {
      setState(() => _currentIndex = dashboardIndex);
      return;
    }
    // 4+ মানে More Screen এর ভিতরের Module - More তে যেয়ে সেই Module খুলবে
    setState(() => _currentIndex = 4);
    // More Screen কে বলবে কোন Module খুলতে হবে
    Future.microtask(() {
      _openFromMore(dashboardIndex);
    });
  }

  void _openFromMore(int dashboardIndex) {
    Widget page;
    String title = '';
    switch (dashboardIndex) {
      case 4:
        page = const ManpowerScreen();
        title = 'Manpower';
        break;
      case 5:
        page = const BreakdownScreen();
        title = 'Breakdown';
        break;
      case 6:
        page = const MessagesScreen();
        title = 'Messages';
        break;
      case 7:
        page = const AlertsScreen();
        title = 'Alerts';
        break;
      case 8:
        page = const OvertimeScreen();
        title = 'Overtime';
        break;
      case 9:
        page = const LocationScreen();
        title = 'Location';
        break;
      case 10:
        page = const AdminPanelScreen();
        title = 'Admin Panel';
        break;
      case 11:
        page = const ProfileScreen();
        title = 'Profile';
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(body: page, appBar: AppBar(backgroundColor: KormiColors.navy, foregroundColor: KormiColors.goldLight, title: Text(title)))));
  }

  List<Widget> get _pages => [
        DashboardScreen(onNavigate: _onDashboardNavigate),
        const WorkersScreen(),
        const AttendanceScreen(),
        const ProductionScreen(),
        _MoreScreen(onOpen: _openFromMore),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: KormiColors.border)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: KormiColors.navy,
          unselectedItemColor: KormiColors.textGrey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Workers'),
            BottomNavigationBarItem(icon: Icon(Icons.fingerprint_outlined), activeIcon: Icon(Icons.fingerprint), label: 'Attendance'),
            BottomNavigationBarItem(icon: Icon(Icons.factory_outlined), activeIcon: Icon(Icons.factory), label: 'Production'),
            BottomNavigationBarItem(icon: Icon(Icons.apps_outlined), activeIcon: Icon(Icons.apps), label: 'More'),
          ],
        ),
      ),
    );
  }
}

class _MoreScreen extends StatelessWidget {
  final Function(int) onOpen;
  const _MoreScreen({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Manpower', 'subtitle': 'Required vs Present • Shortage', 'icon': Icons.groups_outlined, 'index': 4},
      {'title': 'Breakdown', 'subtitle': 'Report • In Progress • Fixed', 'icon': Icons.build_outlined, 'index': 5},
      {'title': 'Messages', 'subtitle': 'Chat • Unread • Quick Reply', 'icon': Icons.message_outlined, 'index': 6},
      {'title': 'Alerts', 'subtitle': 'Unread • High Priority', 'icon': Icons.notifications_outlined, 'index': 7},
      {'title': 'Overtime', 'subtitle': 'OT + Night Bill Calculator', 'icon': Icons.schedule_outlined, 'index': 8},
      {'title': 'Location', 'subtitle': 'Inside / Outside Live', 'icon': Icons.location_on_outlined, 'index': 9},
      {'title': 'Admin Panel', 'subtitle': 'Pending Approval • Users • Audit', 'icon': Icons.admin_panel_settings_outlined, 'index': 10},
      {'title': 'Profile', 'subtitle': 'Edit • Password • Settings', 'icon': Icons.person_outline, 'index': 11},
    ];

    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(backgroundColor: KormiColors.navy, foregroundColor: KormiColors.goldLight, title: const Text('More Modules')),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: KormiCard(
              onTap: () => onOpen(item['index'] as int),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: KormiColors.navy.withOpacity(0.08), child: Icon(item['icon'] as IconData, color: KormiColors.navy, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 15)), Text(item['subtitle'] as String, style: const TextStyle(color: KormiColors.textGrey, fontSize: 12))])),
                  const Icon(Icons.chevron_right, color: KormiColors.textGrey, size: 18),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
