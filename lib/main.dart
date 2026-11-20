import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'database/kormi_database.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await KormiDatabase.init();
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
        primaryColor: const Color(0xFF0A1E3C),
        scaffoldBackgroundColor: const Color(0xFFF6F1E7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A1E3C),
          primary: const Color(0xFF0A1E3C),
          secondary: const Color(0xFFD4AF6A),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainNavigationScreen(),
      },
    );
  }
}
