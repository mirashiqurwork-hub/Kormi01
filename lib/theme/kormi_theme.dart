// KORMI - Theme - FINAL POLISH
// Navy + Light Gold + Glass - সব Screen এই Theme ব্যবহার করে
// KormiCard + KormiPrimaryButton - সব Screen এ Same Design

import 'package:flutter/material.dart';

class KormiColors {
  static const Color navy = Color(0xFF0F2440);
  static const Color navyDark = Color(0xFF0A1A2E);
  static const Color navyLight = Color(0xFF1A3A5C);
  static const Color gold = Color(0xFFD4AF6A);
  static const Color goldLight = Color(0xFFE8D5A3);
  static const Color goldDark = Color(0xFFB8944A);
  static const Color bg = Color(0xFFF4F6F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color textGrey = Color(0xFF64748B);
  static const Color green = Color(0xFF16A34A);
  static const Color red = Color(0xFFDC2626);
  static const Color white = Colors.white;
}

class KormiTheme {
  static ThemeData get lightTheme {
    return ThemeData(
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
        titleTextStyle: TextStyle(color: KormiColors.goldLight, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KormiColors.navy,
          foregroundColor: KormiColors.goldLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      useMaterial3: true,
      fontFamily: 'Roboto',
    );
  }
}

// Glass Card - সব Screen এ Same Card Design
class KormiCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const KormiCard({super.key, required this.child, this.onTap, this.padding});

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KormiColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: card,
      );
    }
    return card;
  }
}

// Primary Button - সব Screen এ Same Button
class KormiPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const KormiPrimaryButton({super.key, required this.label, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 18, color: KormiColors.goldLight) : const SizedBox.shrink(),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: KormiColors.navy,
          foregroundColor: KormiColors.goldLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// Secondary Gold Button
class KormiGoldButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const KormiGoldButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: KormiColors.gold,
          foregroundColor: KormiColors.navy,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }
}
