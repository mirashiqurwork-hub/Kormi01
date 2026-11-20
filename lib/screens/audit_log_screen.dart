// Audit Log Screen - কে কখন কী করলো
// Security এর জন্য। Admin দেখতে পারবে।

import 'package:flutter/material.dart';

class AuditLogScreen extends StatelessWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ডেমো Audit Log
    final List<Map<String, String>> logs = [
      {'user': 'ADMIN', 'action': 'Approve', 'detail': 'Card 105 - নতুন শ্রমিক Approve', 'time': '10:30'},
      {'user': 'Officer - Unit 1', 'action': 'Attendance', 'detail': 'Unit 1 - P/B হাজিরা দিলো', 'time': '09:15'},
      {'user': 'ADMIN', 'action': 'Production', 'detail': 'Unit 1 - Carding 1200 Kg Entry', 'time': '08:40'},
      {'user': 'Worker - 101', 'action': 'Login', 'detail': 'লগইন করলো', 'time': '08:00'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A1D3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1D3F),
        title: const Text(
          'Audit Log',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFD4AF37),
                child: Icon(Icons.history, color: Colors.black),
              ),
              title: Text('${log['user']} - ${log['action']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(log['detail']!),
              trailing: Text(log['time']!, style: const TextStyle(fontSize: 12)),
            ),
          );
        },
      ),
    );
  }
}
