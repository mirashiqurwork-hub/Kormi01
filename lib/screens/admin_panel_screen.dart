// Admin Panel Screen - অ্যাডমিন প্যানেল
// শুধু Admin / Management দেখতে পারবে। Pending শ্রমিক Approve, কোম্পানি, Shift, Night Bill।

import 'package:flutter/material.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  // Pending শ্রমিক, ডেমো
  List<Map<String, String>> _pending = [
    {'name': 'নতুন শ্রমিক ১', 'card': '105', 'unit': 'Unit 1', 'shift': 'P/B'},
    {'name': 'নতুন শ্রমিক ২', 'card': '106', 'unit': 'Unit 1', 'shift': 'P/A'},
  ];

  // কোম্পানি অনুযায়ী Night Bill
  Map<String, String> _nightBill = {
    'Company 1': '150',
    'Company 2': '180',
  };

  String _rotationDay = 'শুক্রবার';

  void _approve(int index) {
    setState(() => _pending.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Approve হয়ে গেছে')),
    );
  }

  void _reject(int index) {
    setState(() => _pending.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reject করা হইছে')),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A2F),
        title: const Text(
          'অ্যাডমিন প্যানেল',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _sectionTitle('Pending শ্রমিক Approve করুন'),
            if (_pending.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text('কোনো Pending শ্রমিক নাই', style: TextStyle(color: Colors.white)),
              ),
            ..._pending.asMap().entries.map((e) {
              final index = e.key;
              final w = e.value;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text('${w['card']} - ${w['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Unit: ${w['unit']} | Shift: ${w['shift']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _approve(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _reject(index),
                      ),
                    ],
                  ),
                ),
              );
            }),
            _sectionTitle('Shift Rotation'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                title: const Text('Rotation Day: শুক্রবার'),
                subtitle: Text('নিয়ম: Permanent Shift একই থাকবে, শুধু Running Shift ঘুরবে - Night -> B, B -> সকাল, সকাল -> Night'),
              ),
            ),
            _sectionTitle('Night Bill - কোম্পানি অনুযায়ী'),
            ..._nightBill.entries.map((e) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text(e.key),
                  trailing: Text('${e.value} টাকা', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            }),
            _sectionTitle('Bottom Bar Edit - শুধু Admin পারবে'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                title: const Text('Home, Production, Team, Profile'),
                subtitle: const Text('সর্বোচ্চ ৫টা, ৪টা হলে সবচেয়ে সুন্দর দেখায়। Team বাদ দিয়ে Messages যোগ করা যাবে।'),
                trailing: const Icon(Icons.edit, color: Color(0xFFD4AF37)),
                onTap: () {},
              ),
            ),
            _sectionTitle('কোম্পানি - শুধু তুমি বদলাতে পারবা'),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                title: const Text('কোম্পানি যোগ / বাদ / নাম বদলানো'),
                subtitle: const Text('অন্য কেউ কোম্পানি যোগ, বাদ, বদলাতে পারবে না।'),
                trailing: const Icon(Icons.business, color: Color(0xFFD4AF37)),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
