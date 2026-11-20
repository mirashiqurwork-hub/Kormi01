import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1E3C),
              Color(0xFF122A52),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 140,
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A1E3C),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0xFFD4AF6A),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'K',
                      style: TextStyle(
                        color: Color(0xFFD4AF6A),
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'KORMI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'SPINNING MILL WORKFORCE',
              style: TextStyle(
                color: Color(0xFFD4AF6A),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: Color(0xFFD4AF6A),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
