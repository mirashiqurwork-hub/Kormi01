// Overtime Screen - ওভারটাইম
// Date / Unit / Permanent Shift দিয়ে ওভারটাইম। Night Bill কোম্পানি অনুযায়ী আলাদা। OCR দিয়ে লিস্ট তোলা যাবে।

import 'package:flutter/material.dart';

class OvertimeScreen extends StatefulWidget {
  const OvertimeScreen({super.key});

  @override
  State<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> {
  String _unit = 'Unit 1';
  String _shift = 'P/B';
  DateTime _date = DateTime.now();

  // ডেমো ওভারটাইম লিস্ট
  List<Map<String, dynamic>> _list = [
    {'name': 'ফাতেমা আক্তার', 'card': '101', 'hours': 2, 'night': true},
    {'name': 'মোঃ রহিম', 'card': '102', 'hours': 3, 'night': false},
  ];

  void _addOvertime() {
    setState(() {
      _list.add({'name': 'নতুন শ্রমিক', 'card': '103', 'hours': 2, 'night': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateText = '${_date.day}-${_date.month}-${_date.year}';
    return Scaffold(
      backgroundColor: const Color(0xFF0A1D3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1D3F),
        title: const Text(
          'ওভারটাইম',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Color(0xFFD4AF37)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Date / Unit / Shift
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _unit,
                    decoration: const InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'Unit 1', child: Text('Unit 1')),
                      DropdownMenuItem(value: 'Unit 2', child: Text('Unit 2')),
                    ],
                    onChanged: (v) => setState(() => _unit = v ?? 'Unit 1'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _shift,
                    decoration: const InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'P/A', child: Text('P/A')),
                      DropdownMenuItem(value: 'P/B', child: Text('P/B')),
                      DropdownMenuItem(value: 'P/C', child: Text('P/C')),
                    ],
                    onChanged: (v) => setState(() => _shift = v ?? 'P/B'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                      child: Text(dateText, textAlign: TextAlign.center),
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
                    title: Text('${item['card']} - ${item['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('ঘণ্টা: ${item['hours']} | Night: ${item['night'] ? 'হ্যাঁ' : 'না'}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _list.removeAt(index)),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                      onPressed: _addOvertime,
                      child: const Text('যোগ করুন', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () {},
                      child: const Text('শেয়ার', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
