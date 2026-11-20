// KORMI - Splash Screen - FINAL
// বড় K Logo নাই - শুধু KORMI Text + Gold Line
// 2 সেকেন্ড পর Login এ যাবে

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
            // Logo Area - আসল Logo পরে এখানে বসবে
            // এখন শুধু Text, বড় K Logo নাই
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: KormiColors.gold.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'KORMI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 38,
                  letterSpacing: 6,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(width: 80, height: 2, color: KormiColors.gold),
            const SizedBox(height: 12),
            const Text(
              'SPINNING MILL WORKFORCE',
              style: TextStyle(color: KormiColors.goldLight, fontSize: 11, letterSpacing: 3),
            ),
            const SizedBox(height: 6),
            const Text(
              'Kumira Spinning Mill',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: KormiColors.gold, strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }
}
