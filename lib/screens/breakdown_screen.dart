// Breakdown Screen - ব্রেকডাউন
// মেশিন বন্ধ থাকলে কারণ + কতক্ষণ বন্ধ ছিল লিখে রাখা যাবে।

import 'package:flutter/material.dart';

class BreakdownScreen extends StatefulWidget {
  const BreakdownScreen({super.key});

  @override
  State<BreakdownScreen> createState() => _BreakdownScreenState();
}

class _BreakdownScreenState extends State<BreakdownScreen> {
  String _machine = 'Carding';
  Map<String, String> _banglaName = {
    'Carding': 'কার্ডিং',
    'Drawing': 'ড্রয়িং',
    'Simplex': 'সিমপ্লেক্স',
    'Ring': 'রিং',
    'Winding': 'ওয়াইন্ডিং',
  };

  final _reasonController = TextEditingController();
  final _minutesController = TextEditingController();
  List<Map<String, String>> _list = [];

  void _addBreakdown() {
    if (_reasonController.text.trim().isEmpty) return;
    setState(() {
      _list.add({
        'machine': _banglaName[_machine] ?? _machine,
        'reason': _reasonController.text.trim(),
        'minutes': _minutesController.text.trim().isEmpty ? '0' : _minutesController.text.trim(),
      });
      _reasonController.clear();
      _minutesController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A2F),
        title: const Text(
          'ব্রেকডাউন',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
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
                const SizedBox(height: 10),
                TextField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'কী সমস্যা হইছে? লিখুন',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _minutesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'কত মিনিট বন্ধ ছিল',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    suffixText: 'মিনিট',
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                    onPressed: _addBreakdown,
                    child: const Text(
                      'ব্রেকডাউন যোগ করুন',
                      style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                final item = _list[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.build, color: Colors.red),
                    title: Text(
                      '${item['machine']} - ${item['reason']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('বন্ধ ছিল: ${item['minutes']} মিনিট'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
