// KORMI - main.dart - File 4
// অ্যাপ শুরু এখান থেকে, লগইন -> ড্যাশবোর্ড

import 'package:flutter/material.dart';
import 'theme/kormi_theme.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

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
      theme: KormiTheme.light,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
