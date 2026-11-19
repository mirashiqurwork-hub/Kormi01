// Manpower Screen - ম্যানপাওয়ার
// হাজিরা থেকে অটো আসবে। Active + Present ছাড়া কেউ গুনায় আসবে না।
// সেকশন ফিক্সড: Back / Ring / Cone।

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../database/kormi_database.dart';

class ManpowerScreen extends StatefulWidget {
  const ManpowerScreen({super.key});

  @override
  State<ManpowerScreen> createState() => _ManpowerScreenState();
}

class _ManpowerScreenState extends State<ManpowerScreen> {
  final _db = KormiDatabase();

  // Unit + Shift বাছা, ম্যানুয়ালি বাছতে হবে
  String _unit = '1';
  String _permanentShift = 'P/B'; // P/A, P/B, P/C
  String _runningShift = 'R/A'; // R/A, R/B, R/C
  String _date = '2026-11-21';

  // সেকশন অনুযায়ী লোক
  Map<String, int> _counts = {
    'Back': 0,
    'Ring': 0,
    'Cone': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadManpower();
  }

  // হাজিরা থেকে ম্যানপাওয়ার গুনা
  void _loadManpower() {
    // হাজিরা আনি
    final attendance = _db.getAttendance(date: _date, myCompanyId: 'company_1');
    // শ্রমিকের তালিকা আনি, সেকশন জানার জন্য
    final workers = _db.getWorkers(
      myRole: 'Admin',
      myUnit: _unit,
      myShift: _permanentShift,
      myCompanyId: 'company_1',
    );

    // শ্রমিকের কার্ড নম্বর দিয়ে সেকশন ম্যাপ বানাই
    Map<String, String> sectionByCard = {};
    for (var w in workers) {
      sectionByCard[w['cardNumber'].toString()] = w['section']?.toString() ?? 'Back';
    }

    // গুনা শুরু, প্রথমে ০ করি
    Map<String, int> newCounts = {'Back': 0, 'Ring': 0, 'Cone': 0};

    for (var a in attendance) {
      // শুধু Present গুনবো, Absent / Off গুনবো না
      // রেকর্ড নাই মানে গুনায় আসবে না, এইটাই নিয়ম
      if (a['status'] != 'Present') continue;

      // শুধু নিজের Unit + Permanent Shift গুনবো
      if (a['unit'] != _unit) continue;

      final card = a['cardNumber'].toString();
      var section = sectionByCard[card] ?? 'Back';

      // Cone / Auto Cone ২টাই Cone ধরবো
      if (section.toLowerCase().contains('cone') || section.toLowerCase().contains('auto')) {
        section = 'Cone';
      } else if (section.toLowerCase().contains('ring')) {
        section = 'Ring';
      } else {
        section = 'Back';
      }

      newCounts[section] = (newCounts[section] ?? 0) + 1;
    }

    setState(() => _counts = newCounts);
  }

  // মোট লোক
  int get _total => _counts.values.fold(0, (a, b) => a + b);

  // শেয়ার ফরম্যাট, তুমি যেভাবে বলছিলা ওইভাবে
  void _shareManpower() {
    final text = '''
MANPOWER
UNIT: $_unit
Date: $_date
Shift: $_permanentShift - $_runningShift
Back: ${_counts['Back']} জন
Ring: ${_counts['Ring']} জন
Cone: ${_counts['Cone']} জন
Total: $_total জন
''';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A2F),
        title: const Text(
          'ম্যানপাওয়ার',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // উপরে Unit + Shift বাছা
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _unit,
                        decoration: const InputDecoration(labelText: 'Unit', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                        items: const [
                          DropdownMenuItem(value: '1', child: Text('Unit 1')),
                          DropdownMenuItem(value: '2', child: Text('Unit 2')),
                          DropdownMenuItem(value: '3', child: Text('Unit 3')),
                        ],
                        onChanged: (v) {
                          _unit = v ?? '1';
                          _loadManpower();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _permanentShift,
                        decoration: const InputDecoration(labelText: 'Permanent Shift', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                        items: const [
                          DropdownMenuItem(value: 'P/A', child: Text('P/A')),
                          DropdownMenuItem(value: 'P/B', child: Text('P/B')),
                          DropdownMenuItem(value: 'P/C', child: Text('P/C')),
                        ],
                        onChanged: (v) {
                          _permanentShift = v ?? 'P/B';
                          _loadManpower();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _runningShift,
                  decoration: const InputDecoration(labelText: 'Running Shift', border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
                  items: const [
                    DropdownMenuItem(value: 'R/A', child: Text('R/A')),
                    DropdownMenuItem(value: 'R/B', child: Text('R/B')),
                    DropdownMenuItem(value: 'R/C', child: Text('R/C')),
                  ],
                  onChanged: (v) {
                    _runningShift = v ?? 'R/A';
                    _loadManpower();
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'তারিখ: $_date | Shift: $_permanentShift - $_runningShift',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),

          // সেকশন কার্ড গুলা
          Expanded(
            child: ListView(
              children: _counts.entries.map((e) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFD4AF37),
                      child: Icon(Icons.people, color: Colors.black),
                    ),
                    title: Text(
                      e.key == 'Back' ? 'ব্যাক সাইড' : e.key == 'Ring' ? 'রিং সেকশন' : 'কোন সেকশন',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '${e.value} জন',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // নিচে মোট + শেয়ার
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white12,
            child: Column(
              children: [
                Text(
                  'মোট: $_total জন',
                  style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                        onPressed: _loadManpower,
                        child: const Text('আবার হিসাব করুন', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _shareManpower,
                        child: const Text('শেয়ার করুন', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
