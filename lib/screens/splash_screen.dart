// Splash Screen - অ্যাপ খুললে প্রথম স্ক্রিন
// KORMI লোগো + ফ্যাক্টরি + চিমনি ধোঁয়া। ২ সেকেন্ড পর Login / Home এ যাবে।

import 'package:flutter/material.dart';
import 'widgets/app_background.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    bool loggedIn = false;
    try {
      final box = await Hive.openBox('kormi_auth');
      loggedIn = (box.get('is_logged_in') ?? false) as bool;
    } catch (_) {
      loggedIn = false;
    }
    if (loggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'K',
                    style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'KORMI',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'স্পিনিং মিল ওয়ার্কফোর্স',
                style: TextStyle(color: Colors.white70, fontSize: 17),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: Color(0xFFD4AF37)),
            ],
          ),
        ),
      ),
    );
  }
}
