// Worker Card - শ্রমিক কার্ড
// সবুজ = Present, লাল = Absent, হলুদ = Pending, Gold = Urgent।

import 'package:flutter/material.dart';

class WorkerCard extends StatelessWidget {
  final String card;
  final String name;
  final String unit;
  final String shift;
  final String section;
  final String status; // Present / Absent / Off / Pending / Active
  final VoidCallback? onTap;

  const WorkerCard({
    super.key,
    required this.card,
    required this.name,
    required this.unit,
    required this.shift,
    required this.section,
    required this.status,
    this.onTap,
  });

  Color _statusColor() {
    if (status == 'Present' || status == 'Active') return Colors.green;
    if (status == 'Absent') return Colors.red;
    if (status == 'Pending') return Colors.amber;
    if (status == 'Off') return Colors.grey;
    return const Color(0xFFD4AF37);
  }

  String _statusBangla() {
    if (status == 'Present') return 'হাজির';
    if (status == 'Absent') return 'অনুপস্থিত';
    if (status == 'Off') return 'ছুটি';
    if (status == 'Pending') return 'Pending';
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _statusColor(),
          child: Text(
            card,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$unit - $shift - $section'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _statusColor().withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _statusColor()),
          ),
          child: Text(
            _statusBangla(),
            style: TextStyle(color: _statusColor(), fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
