// KORMI - Theme File - File 1
// স্ক্রিনশটের হুবহু কালার + স্টাইল
// এই ফাইলটা সব পেজ ব্যবহার করবে, তাই ডিজাইন একরকম থাকবে

import 'package:flutter/material.dart';

class KormiColors {
  // উপরের বার + বটম বার + বড় বাটন - ডার্ক নেভি
  static const Color navy = Color(0xFF0A1E4A);
  static const Color navyLight = Color(0xFF12294F);

  // গোল্ডেন লেখা + আইকন - হালকা গোল্ড, চোখে লাগা হলুদ না
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFE8D5A8);

  // পেজের বডি - হালকা ধূসর-সাদা, ছবির মতো
  static const Color bg = Color(0xFFF2F4F7);

  // কার্ড - সাদা
  static const Color card = Colors.white;

  // লেখা
  static const Color textDark = Color(0xFF0A1E4A);
  static const Color textGrey = Color(0xFF6B7A8F);
  static const Color textLight = Colors.white;

  // সবুজ - Allowed / On
  static const Color green = Color(0xFF1B8C4A);

  // লাল - Alerts ডট / Pending
  static const Color red = Color(0xFFE53935);

  // কার্ডের বর্ডার - খুব হালকা
  static const Color border = Color(0xFFE5E8EC);
}

class KormiTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: KormiColors.bg,
      primaryColor: KormiColors.navy,
      appBarTheme: const AppBarTheme(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        elevation: 0,
        centerTitle: false,
      ),
      // সব লেখার ডিফল্ট স্টাইল
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: KormiColors.textDark,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        bodyMedium: TextStyle(
          color: KormiColors.textDark,
          fontSize: 15,
        ),
        bodySmall: TextStyle(
          color: KormiColors.textGrey,
          fontSize: 13,
        ),
      ),
    );
  }
}

// সাদা কার্ড - সব পেজে একই রকম, ছবির মতো গোল কর্নার + হালকা শ্যাডো
class KormiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const KormiCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: KormiColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KormiColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

// বড় বাটন - ডার্ক নেভি ব্যাকগ্রাউন্ড + গোল্ডেন লেখা, ছবির মতো
class KormiPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const KormiPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: KormiColors.navy,
          foregroundColor: KormiColors.goldLight,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
