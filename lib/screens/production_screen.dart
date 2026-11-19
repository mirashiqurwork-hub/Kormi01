// Production Screen - উৎপাদন
// মেশিনের অর্ডার: কার্ডিং, ড্রয়িং, সিমপ্লেক্স, রিং, ওয়াইন্ডিং
// কেজি লিখলেই ৮ ঘণ্টার টোটাল বের হবে।

import 'package:flutter/material.dart';
import '../database/kormi_database.dart';
import '../widgets/ocr_camera_button.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  final _db = KormiDatabase();

  // আজকের তারিখ + Shift
  String _date = '2026-11-21';
  String _shift = 'A';

  // ৫টা মেশিনের কেজি, প্রথমে ০
  Map<String, TextEditingController> _controllers = {
    'Carding': TextEditingController(),
    'Drawing': TextEditingController(),
    'Simplex': TextEditingController(),
    'Ring': TextEditingController(),
    'Winding': TextEditingController(),
  };

  // মেশিনের বাংলা নাম
  Map<String, String> _banglaName = {
    'Carding': 'কার্ডিং',
    'Drawing': 'ড্রয়িং',
    'Simplex': 'সিমপ্লেক্স',
    'Ring': 'রিং',
    'Winding': 'ওয়াইন্ডিং',
  };

  // মোট কেজি বের করা
  double get _totalKg {
    double total = 0;
    for (var c in _controllers.values) {
      total += double.tryParse(c.text) ?? 0;
    }
    return total;
  }

  // প্রোডাকশন সেভ করা
  Future<void> _saveProduction() async {
    for (var entry in _controllers.entries) {
      final kg = double.tryParse(entry.value.text) ?? 0;
      if (kg > 0) {
        await _db.saveProduction({
          'date': _date,
          'machine': entry.key,
          'shift': _shift,
          'companyId': 'company_1',
          'unit': '1',
          'kg': kg,
          // ৮ ঘণ্টার শিফট টোটাল, পরে ক্যালকুলেটর থেকে আসবে
          'shiftTotal': kg,
        });
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('প্রোডাকশন সেভ হয়ে গেছে')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A2F),
        title: const Text(
          'উৎপাদন',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // উপরে তারিখ + Shift
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
                // Shift বদলানো
                DropdownButton<String>(
                  value: _shift,
                  dropdownColor: const Color(0xFF0A1A2F),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  items: const [
                    DropdownMenuItem(value: 'A', child: Text('Shift A')),
                    DropdownMenuItem(value: 'B', child: Text('Shift B')),
                    DropdownMenuItem(value: 'C', child: Text('Shift C')),
                  ],
                  onChanged: (v) => setState(() => _shift = v ?? 'A'),
                ),
              ],
            ),
          ),

          // OCR বাটন
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: OcrCameraButton(
              label: 'ছবি দিয়ে প্রোডাকশন এন্ট্রি',
              onImagePicked: (image) {
                if (image != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('প্রোডাকশন ছবি পেয়েছি')),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 10),

          // ৫টা মেশিনের লিস্ট
          Expanded(
            child: ListView(
              children: _controllers.entries.map((e) {
                final machine = e.key;
                final controller = e.value;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _banglaName[machine] ?? machine,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller,
                          keyboardType: TextInputType.number, // শুধু সংখ্যা লেখা যাবে
                          decoration: const InputDecoration(
                            hintText: 'কেজি লিখুন...',
                            border: OutlineInputBorder(),
                            suffixText: 'কেজি',
                          ),
                          onChanged: (_) => setState(() {}), // লিখলেই টোটাল আপডেট হবে
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // নিচে মোট + সেভ
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white12,
            child: Column(
              children: [
                Text(
                  'মোট প্রোডাকশন: $_totalKg কেজি',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                    onPressed: _saveProduction,
                    child: const Text(
                      'প্রোডাকশন সেভ করুন',
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
