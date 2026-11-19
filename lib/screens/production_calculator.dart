// Production Calculator - প্রোডাকশন হিসাব
// ৫টা মেশিন: কার্ডিং, ড্রয়িং, সিমপ্লেক্স, রিং, ওয়াইন্ডিং
// TPI = TM x sqrt(Count), Kg/hr + ৮ ঘণ্টার টোটাল দেখাবে।

import 'dart:math';
import 'package:flutter/material.dart';
import '../database/kormi_database.dart';

class ProductionCalculator extends StatefulWidget {
  const ProductionCalculator({super.key});

  @override
  State<ProductionCalculator> createState() => _ProductionCalculatorState();
}

class _ProductionCalculatorState extends State<ProductionCalculator> {
  final _db = KormiDatabase();

  // কোন মেশিন বাছা হইছে
  String _machine = 'Carding';
  Map<String, String> _banglaName = {
    'Carding': 'কার্ডিং',
    'Drawing': 'ড্রয়িং',
    'Simplex': 'সিমপ্লেক্স',
    'Ring': 'রিং',
    'Winding': 'ওয়াইন্ডিং',
  };

  // ইনপুট গুলা
  final _speedController = TextEditingController(); // ডেলিভারি স্পিড m/min
  final _countController = TextEditingController(); // কাউন্ট
  final _tmController = TextEditingController(); // TM
  final _efficiencyController = TextEditingController(text: '90'); // এফিসিয়েন্সি %

  // রেজাল্ট
  double _tpi = 0;
  double _kgPerHr = 0;
  double _shiftTotal = 0;

  // হিসাব করা
  void _calculate() {
    final speed = double.tryParse(_speedController.text) ?? 0;
    final count = double.tryParse(_countController.text) ?? 0;
    final tm = double.tryParse(_tmController.text) ?? 0;
    final eff = double.tryParse(_efficiencyController.text) ?? 90;

    if (count <= 0 || speed <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('স্পিড আর কাউন্ট ঠিক করে লিখুন')),
      );
      return;
    }

    // TPI = TM x sqrt(Count) - তুমি যেভাবে বলছিলা
    final tpi = tm * sqrt(count);

    // Kg/hr এর হিসাব, মেশিন অনুযায়ী ফ্যাক্টর আলাদা
    // এইটা স্ট্যান্ডার্ড স্পিনিং ফর্মুলার সহজ রূপ, মিল অনুযায়ী মিলিয়ে নেওয়া যাবে
    double kgHr = 0;
    if (_machine == 'Carding') {
      // কার্ডিং: স্পিড * এফিসিয়েন্সি / কাউন্ট ফ্যাক্টর
      kgHr = (speed * 60 * (eff / 100)) / (count * 0.8 + 1);
    } else if (_machine == 'Drawing') {
      kgHr = (speed * 60 * (eff / 100)) / (count * 0.7 + 1);
    } else if (_machine == 'Simplex') {
      // সিমপ্লেক্স: TPI দিয়ে হিসাব
      kgHr = (speed * 60 * (eff / 100)) / (tpi * 2.5 + 1);
    } else if (_machine == 'Ring') {
      // রিং: স্পিন্ডেল স্পিড / TPI
      kgHr = (speed * 60 * (eff / 100)) / (tpi * 3.0 + 1);
    } else if (_machine == 'Winding') {
      // ওয়াইন্ডিং: m/min vs yd/min, এখানে m/min ধরা হইছে
      // ১ মিটার = ১.০৯৩৬ গজ, চাইলে yd/min-এও দেখা যাবে
      kgHr = (speed * 60 * (eff / 100)) / (count * 0.6 + 1);
    }

    setState(() {
      _tpi = tpi;
      _kgPerHr = kgHr;
      _shiftTotal = kgHr * 8; // ৮ ঘণ্টার শিফট টোটাল
    });
  }

  // ক্যালকুলেটর থেকে সরাসরি এন্ট্রিতে পাঠানো
  Future<void> _sendToEntry() async {
    if (_kgPerHr <= 0) return;
    await _db.saveProduction({
      'date': '2026-11-21',
      'machine': _machine,
      'shift': 'A',
      'companyId': 'company_1',
      'unit': '1',
      'kg': _shiftTotal,
      'shiftTotal': _shiftTotal,
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ক্যালকুলেটর থেকে এন্ট্রিতে পাঠিয়ে দেওয়া হইছে')),
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
          'প্রোডাকশন ক্যালকুলেটর',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // মেশিন বাছা
            DropdownButtonFormField<String>(
              value: _machine,
              decoration: const InputDecoration(
                labelText: 'মেশিন বাছুন',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: _banglaName.entries.map((e) {
                return DropdownMenuItem(value: e.key, child: Text(e.value));
              }).toList(),
              onChanged: (v) => setState(() => _machine = v ?? 'Carding'),
            ),
            const SizedBox(height: 12),

            // স্পিড
            TextField(
              controller: _speedController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'ডেলিভারি স্পিড (m/min)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // কাউন্ট
            TextField(
              controller: _countController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'কাউন্ট',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // TM
            TextField(
              controller: _tmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'TM',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // এফিসিয়েন্সি
            TextField(
              controller: _efficiencyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'এফিসিয়েন্সি %',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // হিসাব বাটন
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                onPressed: _calculate,
                child: const Text(
                  'হিসাব করুন',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // রেজাল্ট বক্স
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TPI: ${_tpi.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 17)),
                  const SizedBox(height: 6),
                  Text('Kg/hr: ${_kgPerHr.toStringAsFixed(2)} কেজি', style: const TextStyle(color: Colors.white, fontSize: 17)),
                  const SizedBox(height: 6),
                  Text('৮ ঘণ্টার টোটাল: ${_shiftTotal.toStringAsFixed(2)} কেজি', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 19, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // এন্ট্রিতে পাঠানো
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _sendToEntry,
                child: const Text('এন্ট্রিতে পাঠান', style: TextStyle(color: Colors.white, fontSize: 17)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
