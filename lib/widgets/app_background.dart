// App Background - সব স্ক্রিনে একই ব্যাকগ্রাউন্ড
// Navy + Gold, ফ্যাক্টরি + চিমনি ধোঁয়া, Glassmorphism।

import 'package:flutter/material.dart';
import 'dart:math' as math;

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Navy Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A1D3F), Color(0xFF0A2A5A), Color(0xFF0A1D3F)],
            ),
          ),
        ),
        // চিমনি ধোঁয়া + ফ্যাক্টরি সিলুয়েট
        const Positioned.fill(
          child: _FactorySilhouette(),
        ),
        // Glassmorphism হালকা আলো
        Positioned(
          top: -60,
          right: -60,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD4AF37).withOpacity(0.12),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -40,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _FactorySilhouette extends StatefulWidget {
  const _FactorySilhouette();

  @override
  State<_FactorySilhouette> createState() => _FactorySilhouetteState();
}

class _FactorySilhouetteState extends State<_FactorySilhouette>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _FactoryPainter(_controller.value),
        );
      },
    );
  }
}

class _FactoryPainter extends CustomPainter {
  final double progress;
  _FactoryPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.25);
    final goldPaint = Paint()..color = const Color(0xFFD4AF37).withOpacity(0.10);

    // নিচে ফ্যাক্টরি বিল্ডিং
    final h = size.height;
    final w = size.width;
    canvas.drawRect(Rect.fromLTWH(0, h - 90, w, 90), paint);

    // চিমনি
    canvas.drawRect(Rect.fromLTWH(w * 0.75, h - 200, 18, 110), paint);
    canvas.drawRect(Rect.fromLTWH(w * 0.75 - 4, h - 205, 26, 10), paint);

    // জানালা - Gold হালকা
    for (int i = 0; i < 6; i++) {
      canvas.drawRect(
        Rect.fromLTWH(20 + i * 45, h - 70, 28, 20),
        goldPaint,
      );
    }

    // ধোঁয়া - উপরে উঠতেছে
    for (int i = 0; i < 3; i++) {
      final t = (progress + i * 0.33) % 1.0;
      final dx = w * 0.75 + 9 + math.sin(t * 6) * 12;
      final dy = (h - 210) - t * 90;
      final r = 8 + t * 16;
      final smokePaint = Paint()
        ..color = Colors.white.withOpacity(0.18 * (1 - t));
      canvas.drawCircle(Offset(dx, dy), r, smokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FactoryPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
