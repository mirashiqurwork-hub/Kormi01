// Bottom Bar - নিচের বার
// Home, Production, Team, Profile - Admin চাইলে max 5টা পর্যন্ত বদলাতে পারবে। Team এর বদলে Messages দেওয়া যাবে।

import 'package:flutter/material.dart';

class KormiBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<String> items; // Admin থেকে আসবে, ডিফল্ট 4টা

  const KormiBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = const ['Home', 'Production', 'Team', 'Profile'],
  });

  IconData _iconFor(String label) {
    if (label == 'Home') return Icons.home;
    if (label == 'Production') return Icons.factory;
    if (label == 'Team') return Icons.group;
    if (label == 'Messages') return Icons.message;
    if (label == 'Profile') return Icons.person;
    if (label == 'Attendance') return Icons.check_circle;
    if (label == 'Manpower') return Icons.people;
    return Icons.circle;
  }

  String _banglaFor(String label) {
    if (label == 'Home') return 'হোম';
    if (label == 'Production') return 'প্রোডাকশন';
    if (label == 'Team') return 'টিম';
    if (label == 'Messages') return 'মেসেজ';
    if (label == 'Profile') return 'প্রোফাইল';
    if (label == 'Attendance') return 'হাজিরা';
    if (label == 'Manpower') return 'ম্যানপাওয়ার';
    return label;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1D3F),
        border: Border(top: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.4))),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: items.asMap().entries.map((e) {
            final index = e.key;
            final label = e.value;
            final selected = index == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFD4AF37).withOpacity(0.15) : Colors.transparent,
                    border: selected
                        ? const Border(top: BorderSide(color: Color(0xFFD4AF37), width: 3))
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _iconFor(label),
                        color: selected ? const Color(0xFFD4AF37) : Colors.white70,
                        size: 26,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _banglaFor(label),
                        style: TextStyle(
                          color: selected ? const Color(0xFFD4AF37) : Colors.white70,
                          fontSize: 13,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
