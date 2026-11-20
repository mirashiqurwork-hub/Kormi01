// KORMI - Main Entry - FINAL WIRING
// Theme + Splash -> Login -> Main (Dashboard + All Modules)

import 'package:flutter/material.dart';
import 'theme/kormi_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      // Splash -> Login -> Main Flow
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
      },
      // Fallback - কোনো Route না মিললে Splash দেখাবে
      onUnknownRoute: (settings) => MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }
}
