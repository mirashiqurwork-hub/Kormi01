// Kormi Button - বড় বাটন
// সাধারণ মানুষের জন্য বড়, আইকন + লেখা, সর্বোচ্চ ৩ ট্যাপে কাজ।

import 'package:flutter/material.dart';

class KormiButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? color;

  const KormiButton({
    super.key,
    required this.text,
    this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFFD4AF37),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.black, size: 24),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class KormiOutlineButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;

  const KormiOutlineButton({
    super.key,
    required this.text,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFD4AF37), width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: const Color(0xFFD4AF37), size: 24),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
