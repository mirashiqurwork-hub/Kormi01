// KORMI - Main Entry
// Login -> Dashboard, সব Module আসল পেজ খুলবে

import 'package:flutter/material.dart';
import 'theme/kormi_theme.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/register_screen.dart';
import 'screens/workers_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/production_screen.dart';
import 'screens/manpower_screen.dart';
import 'screens/breakdown_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/location_screen.dart';
import 'screens/admin_panel_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/overtime_screen.dart';

void main() {
  runApp(const KormiApp());
}

class KormiApp extends StatelessWidget {
  const KormiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KORMI',
      debugShowCheckedModeBanner: false,
      theme: KormiTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/register': (context) => const RegisterScreen(),
        '/workers': (context) => const WorkersScreen(),
        '/attendance': (context) => const AttendanceScreen(),
        '/production': (context) => const ProductionScreen(),
        '/manpower': (context) => const ManpowerScreen(),
        '/breakdown': (context) => const BreakdownScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/location': (context) => const LocationScreen(),
        '/admin': (context) => const AdminPanelScreen(),
        '/admin-panel': (context) => const AdminPanelScreen(),
        '/alerts': (context) => const AlertsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/overtime': (context) => const OvertimeScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      },
    );
  }
}
