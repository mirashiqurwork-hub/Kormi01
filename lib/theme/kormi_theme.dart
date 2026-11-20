// KORMI - Theme
// Ultra-Premium Classy Navy + Light Gold / Glass Look
// সব Screen এই Theme ব্যবহার করে

import 'package:flutter/material.dart';

class KormiColors {
  static const Color navy = Color(0xFF0F2A4A);
  static const Color navyDark = Color(0xFF0A1E35);
  static const Color gold = Color(0xFFC9A86A);
  static const Color goldLight = Color(0xFFE8D5A3);
  static const Color bg = Color(0xFFF4F6F8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color textGrey = Color(0xFF64748B);
  static const Color green = Color(0xFF16A34A);
  static const Color red = Color(0xFFDC2626);
  static const Color white = Colors.white;
}

class KormiTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: KormiColors.navy,
      scaffoldBackgroundColor: KormiColors.bg,
      colorScheme: const ColorScheme.light(
        primary: KormiColors.navy,
        secondary: KormiColors.gold,
        surface: Colors.white,
        background: KormiColors.bg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: KormiColors.goldLight,
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: KormiColors.goldLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KormiColors.navy,
          foregroundColor: KormiColors.goldLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: KormiColors.navy,
        unselectedItemColor: KormiColors.textGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: KormiColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: KormiColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: KormiColors.navy, width: 1.5),
        ),
      ),
    );
  }
}

// Common Card - সব Screen এ ব্যবহার হয়
class KormiCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const KormiCard({super.key, required this.child, this.onTap, this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: KormiColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

// Common Primary Button
class KormiPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const KormiPrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: KormiColors.navy,
          foregroundColor: KormiColors.goldLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }
}
