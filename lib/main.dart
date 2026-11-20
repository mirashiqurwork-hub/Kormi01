// Main - KORMI অ্যাপের শুরু
// সব স্ক্রিন এখানে যুক্ত। Splash -> Login -> Dashboard + Bottom Bar।

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/production_screen.dart';
import 'screens/workers_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/app_background.dart';
import 'widgets/bottom_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const KormiApp());
}

class KormiApp extends StatelessWidget {
  const KormiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KORMI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0A1D3F),
        scaffoldBackgroundColor: const Color(0xFF0A1D3F),
        fontFamily: 'HindSiliguri',
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainShell(),
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  List<String> _bottomItems = ['Home', 'Production', 'Team', 'Profile'];

  final List<Widget> _pages = const [
    DashboardScreen(),
    ProductionScreen(),
    WorkersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(child: _pages[_index]),
      bottomNavigationBar: KormiBottomBar(
        currentIndex: _index,
        items: _bottomItems,
        onTap: (i) {
          setState(() => _index = i);
        },
      ),
    );
  }
}
