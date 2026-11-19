// Attendance Screen - হাজিরা
// সুপারফাস্ট: শুধু আজকের + নিজের Unit + Shift দেখাবে।
// কার্ড নম্বর আগে, তারপর নাম।

import 'package:flutter/material.dart';
import '../database/kormi_database.dart';
import '../widgets/ocr_camera_button.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _db = KormiDatabase();

  // আজকের তারিখ, পরে ক্যালেন্ডার থেকে বদলানো যাবে
  String _date = '2026-11-21';
  List<Map> _workers = []; // শ্রমিকের লিস্ট
  Map<String, String> _status = {}; // কার্ড নম্বর -> Present / Absent / Off

  // পরে লগইন থেকে আসবে, এখন ডেমোর জন্য
  final String _myRole = 'Officer';
  final String _myUnit = '1';
  final String _myShift = 'A';
  final String _myCompanyId = 'company_1';

  @override
  void initState() {
    super.initState();
    _loadWorkers();
  }

  // শ্রমিক লোড করা
  void _loadWorkers() {
    final workers = _db.getWorkers(
      myRole: _myRole,
      myUnit: _myUnit,
      myShift: _myShift,
      myCompanyId: _myCompanyId,
    );
    setState(() {
      _workers = workers;
      // প্রথমে সবাইকে Absent ধরে নিই, পরে Present টিক দিবো
      // তুমি যেভাবে বলছিলা, Present List দিলে বাকিরা Absent হয়ে যাবে
      for (var w in workers) {
        _status[w['cardNumber'].toString()] ??= 'Absent';
      }
    });
  }

  // হাজিরা সেভ করা
  Future<void> _saveAttendance() async {
    for (var w in _workers) {
      final card = w['cardNumber'].toString();
      await _db.saveAttendance({
        'date': _date,
        'cardNumber': card,
        'name': w['name'],
        'companyId': _myCompanyId,
        'unit': _myUnit,
        'shift': _myShift,
        'status': _status[card] ?? 'Absent', // Present / Absent / Off
      });
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('হাজিরা সেভ হয়ে গেছে')),
      );
    }
  }

  // একটা বাটনের রঙ ঠিক করা
  Color _getColor(String status, String btn) {
    if (status == btn) {
      if (btn == 'Present') return Colors.green;
      if (btn == 'Absent') return Colors.red;
      if (btn == 'Off') return Colors.grey;
    }
    return Colors.white24;
  }

  @override
  Widget build(BuildContext context) {
    // আজকে কতজন হাজির, গুনে দেখাই
    final presentCount = _status.values.where((s) => s == 'Present').length;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A2F),
        title: const Text(
          'হাজিরা',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // উপরে তারিখ + মোট হাজির
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'তারিখ: $_date',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Text(
                  'হাজির: $presentCount জন',
                  style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // OCR ২টা বাটন - Absent List + Present List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: OcrCameraButton(
                    label: 'Absent List OCR',
                    onImagePicked: (image) {
                      if (image != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Absent List ছবি পেয়েছি')),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OcrCameraButton(
                    label: 'Present List OCR',
                    onImagePicked: (image) {
                      if (image != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Present List ছবি পেয়েছি')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // শ্রমিকের লিস্ট
          Expanded(
            child: ListView.builder(
              itemCount: _workers.length,
              itemBuilder: (context, index) {
                final w = _workers[index];
                final card = w['cardNumber'].toString();
                final status = _status[card] ?? 'Absent';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // কার্ড নম্বর আগে, তারপর নাম
                        Text(
                          '$card - ${w['name']}',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // ৩টা বাটন - হাজির / অনুপস্থিত / ছুটি
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: _getColor(status, 'Present')),
                                onPressed: () => setState(() => _status[card] = 'Present'),
                                child: const Text('হাজির', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: _getColor(status, 'Absent')),
                                onPressed: () => setState(() => _status[card] = 'Absent'),
                                child: const Text('অনুপস্থিত', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: _getColor(status, 'Off')),
                                onPressed: () => setState(() => _status[card] = 'Off'),
                                child: const Text('ছুটি', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // নিচে বড় সেভ বাটন
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                onPressed: _saveAttendance,
                child: const Text(
                  'হাজিরা সেভ করুন',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
