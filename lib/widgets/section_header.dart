// Section Header - সেকশন টাইটেল
// Back / Ring / A/Cone - সব জায়গায় একই স্টাইল।

import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  const SectionHeader({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: const Color(0xFFD4AF37), size: 22),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Divider(color: Color(0xFFD4AF37), thickness: 0.6),
          ),
        ],
      ),
    );
  }
}
