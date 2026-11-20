// Machine Card - মেশিন কার্ড
// Carding / Drawing / Simplex / Ring / Winding / Packing - সব মেশিনের কার্ড।

import 'package:flutter/material.dart';

class MachineCard extends StatelessWidget {
  final String name;
  final String value;
  final String status; // চলতেছে / বন্ধ / ঠিক হইছে
  final VoidCallback? onTap;

  const MachineCard({
    super.key,
    required this.name,
    required this.value,
    required this.status,
    this.onTap,
  });

  Color _statusColor() {
    if (status == 'চলতেছে') return Colors.green;
    if (status == 'বন্ধ') return Colors.red;
    return const Color(0xFFD4AF37);
  }

  IconData _icon() {
    if (name == 'Carding') return Icons.settings;
    if (name == 'Drawing') return Icons.timeline;
    if (name == 'Simplex') return Icons.loop;
    if (name == 'Ring') return Icons.donut_large;
    if (name == 'Winding') return Icons.cable;
    return Icons.inventory;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFD4AF37),
          child: Icon(_icon(), color: Colors.black),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('প্রোডাকশন: $value'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _statusColor().withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _statusColor()),
          ),
          child: Text(
            status,
            style: TextStyle(color: _statusColor(), fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
