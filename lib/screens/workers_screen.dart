// Workers Screen - শ্রমিকের তালিকা
// সুপারফাস্ট: প্রথমে অল্প ডাটা দেখাবে, নিচে টান দিলে আরও আসবে।
// কার্ড নম্বর আগে, তারপর নাম।

import 'package:flutter/material.dart';
import '../database/kormi_database.dart';
import '../widgets/ocr_camera_button.dart';

class WorkersScreen extends StatefulWidget {
  const WorkersScreen({super.key});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  // ডাটাবেজ থেকে শ্রমিক আনবো
  final _db = KormiDatabase();
  List<Map> _allWorkers = []; // সব শ্রমিক
  List<Map> _showWorkers = []; // স্ক্রিনে যা দেখাবো
  String _search = ''; // খোঁজার লেখা

  // পরে লগইন থেকে আসল তথ্য আসবে, এখন ডেমোর জন্য Admin
  final String _myRole = 'Admin';
  final String _myUnit = '1';
  final String _myShift = 'A';
  final String _myCompanyId = 'company_1';

  @override
  void initState() {
    super.initState();
    _loadWorkers(); // স্ক্রিন খুললেই শ্রমিক লোড হবে
  }

  // শ্রমিক লোড করা, সুপারফাস্ট ভাবে
  void _loadWorkers() {
    final workers = _db.getWorkers(
      myRole: _myRole,
      myUnit: _myUnit,
      myShift: _myShift,
      myCompanyId: _myCompanyId,
    );
    setState(() {
      _allWorkers = workers;
      _filterWorkers(); // প্রথমে অল্প দেখাই
    });
  }

  // খোঁজা + অল্প করে দেখানো
  void _filterWorkers() {
    var list = _allWorkers;

    // নাম বা কার্ড নম্বর দিয়ে খুঁজলে
    if (_search.isNotEmpty) {
      list = list.where((w) {
        final name = w['name'].toString().toLowerCase();
        final card = w['cardNumber'].toString();
        return name.contains(_search.toLowerCase()) || card.contains(_search);
      }).toList();
    }

    // সুপারফাস্ট এর জন্য প্রথমে ৫০ জন দেখাই, বাকি নিচে টান দিলে আসবে
    if (list.length > 50) {
      _showWorkers = list.sublist(0, 50);
    } else {
      _showWorkers = list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F), // Navy
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A2F),
        title: const Text(
          'শ্রমিকের তালিকা',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // উপরে খোঁজার জায়গা, বড় করে
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'নাম বা কার্ড নম্বর দিয়ে খুঁজুন...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                _search = value;
                _filterWorkers(); // টাইপ করলেই সাথে সাথে খুঁজবে
                setState(() {});
              },
            ),
          ),

          // OCR বাটন, ছবি তুলে শ্রমিক যোগ করা যাবে
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: OcrCameraButton(
              label: 'ছবি দিয়ে শ্রমিক যোগ করুন',
              onImagePicked: (image) {
                // ছবি পেলে পরে OCR করে নাম + কার্ড নম্বর বসাবো
                if (image != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ছবি পেয়েছি, এখন OCR চলবে...')),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 10),

          // শ্রমিকের লিস্ট
          Expanded(
            child: ListView.builder(
              itemCount: _showWorkers.length,
              itemBuilder: (context, index) {
                final w = _showWorkers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFD4AF37),
                      child: Text(
                        w['cardNumber'].toString(), // কার্ড নম্বর বড় করে
                        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // কার্ড নম্বর আগে, তারপর নাম - তুমি যেভাবে বলছিলা
                    title: Text(
                      '${w['cardNumber']} - ${w['name']}',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'সেকশন: ${w['section'] ?? ''} | ফোন: ${w['phone'] ?? ''}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // টিপ দিলে ওই শ্রমিকের ডিটেইলস দেখাবে, পরে File-এ আসবে
                    },
                  ),
                );
              },
            ),
          ),

          // নিচে বড় যোগ বাটন
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                onPressed: () {
                  // নতুন শ্রমিক যোগ করার ফর্ম পরে আসবে
                },
                child: const Text(
                  '+ নতুন শ্রমিক যোগ করুন',
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
