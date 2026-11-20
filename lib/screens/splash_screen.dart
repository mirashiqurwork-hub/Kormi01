// KORMI - Splash Screen
// Duplicate K Logo সরানো - User পরে আসল Logo দিবে
// এখন শুধু KORMI Text + Loading

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.navy,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo পরে এখানে বসবে - এখন কোনো K Logo নাই
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: KormiColors.gold.withOpacity(0.4)),
              ),
              child: const Center(
                child: Text(
                  'KORMI',
                  style: TextStyle(
                    color: KormiColors.goldLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'KORMI',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Mill Management System',
              style: TextStyle(color: KormiColors.goldLight, fontSize: 13),
            ),
            const SizedBox(height: 30),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                color: KormiColors.goldLight,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
