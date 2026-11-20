// KORMI - Attendance Screen
// ড্যাশবোর্ড -> Attendance কার্ডে চাপ দিলে এই পেজ খুলবে
// Present / Absent + OCR ক্যামেরা (Gallery / Take Photo)

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _shift = 'P/B';
  String _search = '';
  DateTime _date = DateTime.now();

  // ডেমো ডাটা - পরে আসল ডাটাবেজ থেকে আসবে
  final Map<String, String> _status = {
    'W-104': 'Present',
    'W-105': 'Present',
    'W-106': 'Absent',
    'W-107': 'Present',
    'W-108': 'Present',
  };

  final List<Map<String, String>> _workers = [
    {'name': 'Md. Rahim Mia', 'id': 'W-104', 'desg': 'OP', 'section': 'RING'},
    {'name': 'Fatema Begum', 'id': 'W-105', 'desg': 'HELPER', 'section': 'PACKING'},
    {'name': 'Rashedul Karim', 'id': 'W-106', 'desg': 'JR.A.OP', 'section': 'BACKSIDE'},
    {'name': 'Kamrul Hasan', 'id': 'W-107', 'desg': 'SR.HELPER', 'section': 'AUTOCONE'},
    {'name': 'Nasrin Akter', 'id': 'W-108', 'desg': 'LINE-MAN', 'section': 'RING'},
  ];

  List<Map<String, String>> get _filtered {
    return _workers.where((w) {
      if (_search.isEmpty) return true;
      return w['name']!.toLowerCase().contains(_search.toLowerCase()) ||
          w['id']!.toLowerCase().contains(_search.toLowerCase());
    }).toList();
  }

  int get _presentCount => _status.values.where((v) => v == 'Present').length;

  // OCR - ক্যামেরা আইকনে চাপ দিলে ২টা অপশন
  void _showOcrOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const Text('Attendance OCR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: KormiColors.navy)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: KormiColors.navy),
              title: const Text('Select Photo from Gallery'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gallery থেকে ছবি সিলেক্ট করুন')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: KormiColors.navy),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ক্যামেরা দিয়ে ছবি তুলুন')),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _toggleStatus(String id) {
    setState(() {
      _status[id] = _status[id] == 'Present' ? 'Absent' : 'Present';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: _showOcrOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // তারিখ + শিফট
          Padding(
            padding: const EdgeInsets.all(14),
            child: KormiCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date: ${_date.day}/${_date.month}/${_date.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (picked != null) setState(() => _date = picked);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 18, color: KormiColors.navy),
                            SizedBox(width: 6),
                            Text('Change', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: ['P/A', 'P/B', 'P/C'].map((s) {
                      final active = _shift == s;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _shift = s),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: active ? KormiColors.navy : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: KormiColors.border),
                              ),
                              child: Center(
                                child: Text(
                                  s,
                                  style: TextStyle(
                                    color: active ? KormiColors.goldLight : KormiColors.navy,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Present: $_presentCount / ${_workers.length}',
                          style: const TextStyle(color: KormiColors.textGrey, fontSize: 13),
                        ),
                      ),
                      Text(
                        'Shift: $_shift',
                        style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // সার্চ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search Name / Card ID',
                prefixIcon: const Icon(Icons.search, color: KormiColors.textGrey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: KormiColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: KormiColors.border),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // লিস্ট
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final w = _filtered[i];
                final status = _status[w['id']] ?? 'Absent';
                final isPresent = status == 'Present';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: KormiCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: KormiColors.navy,
                          child: Text(
                            w['name']!.substring(0, 1),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(w['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                              Text('${w['id']} • ${w['desg']} • ${w['section']}',
                                  style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleStatus(w['id']!),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isPresent ? KormiColors.green : KormiColors.red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // সেভ
          Padding(
            padding: const EdgeInsets.all(14),
            child: KormiPrimaryButton(
              label: 'Save Attendance',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Attendance Saved - Present $_presentCount, Shift $_shift')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
