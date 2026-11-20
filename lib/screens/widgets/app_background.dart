// KORMI - App Background Widget
// সব Screen এর পেছনের Common Background
// Splash Screen এই ফাইলটা খুঁজতেছে, তাই এই path এ বানাতে হবে

import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  // ভিতরের Content
  final Widget? child;
  // কেউ body নামে পাঠালে সেটাও ধরবে
  final Widget? body;

  const AppBackground({
    super.key,
    this.child,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    // child না থাকলে body, তাও না থাকলে খালি Box
    final Widget content = child ?? body ?? const SizedBox();

    return Container(
      width: double.infinity,
      height: double.infinity,
      // KORMI এর Background Gradient - হালকা নীল / সাদা
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE8F0FE), // উপরে হালকা নীল
            Color(0xFFFFFFFF), // নিচে সাদা
          ],
        ),
      ),
      child: SafeArea(
        child: content,
      ),
    );
  }
}
