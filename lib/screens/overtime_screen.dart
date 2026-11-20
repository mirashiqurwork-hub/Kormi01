// KORMI - Overtime (OT) Screen
// OT Entry + OT List + Share Format

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class OvertimeScreen extends StatefulWidget {
  const OvertimeScreen({super.key});

  @override
  State<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> {
  String _worker = 'Karim Sheikh (K-1042)';
  String _shift = 'P/B';
  DateTime _date = DateTime.now();
  final _hoursController = TextEditingController(text: '2.5');
  final _rateController = TextEditingController(text: '85');

  final List<Map<String, dynamic>> _otList = [
    {'name': 'Karim Sheikh', 'card': 'K-1042', 'date': '18.11.26', 'shift': 'P/B', 'hours': 2.5, 'rate': 85, 'total': 212.5},
    {'name': 'Jashim Uddin', 'card': 'K-1045', 'date': '18.11.26', 'shift': 'P/B', 'hours': 3.0, 'rate': 85, 'total': 255.0},
    {'name': 'Rahim Uddin', 'card': 'K-1041', 'date': '17.11.26', 'shift': 'P/A', 'hours': 2.0, 'rate': 90, 'total': 180.0},
  ];

  double get _totalHours => _otList.fold(0.0, (s, e) => s + (e['hours'] as double));
  double get _totalAmount => _otList.fold(0.0, (s, e) => s + (e['total'] as double));

  double get _currentTotal {
    final h = double.tryParse(_hoursController.text) ?? 0;
    final r = double.tryParse(_rateController.text) ?? 0;
    return h * r;
  }

  void _saveOt() {
    final h = double.tryParse(_hoursController.text) ?? 0;
    final r = double.tryParse(_rateController.text) ?? 0;
    if (h <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OT Hours দিন')),
      );
      return;
    }
    setState(() {
      _otList.insert(0, {
        'name': _worker.split(' (').first,
        'card': 'K-1042',
        'date': '${_date.day}.${_date.month}.${_date.year}',
        'shift': _shift,
        'hours': h,
        'rate': r,
        'total': h * r,
      });
      _hoursController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OT Saved - ${h} hrs, ৳ ${h * r}')),
    );
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Overtime (OT)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Summary
            KormiCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem('Total Hours', '${_totalHours.toStringAsFixed(1)} hrs', KormiColors.navy),
                  _summaryItem('Total Amount', '৳ ${_totalAmount.toStringAsFixed(0)}', KormiColors.green),
                  _summaryItem('Entries', '${_otList.length}', KormiColors.gold),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // OT Entry Form
            KormiCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('OT Entry', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 17)),
                  const SizedBox(height: 14),
                  _dropdownBox(
                    _worker,
                    ['Karim Sheikh (K-1042)', 'Jashim Uddin (K-1045)', 'Rahim Uddin (K-1041)', 'Nasir Ahmed (K-1043)'],
                    (v) => setState(() => _worker = v!),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _dropdownBox(_shift, ['P/A', 'P/B', 'P/C', 'P/B-R/C'], (v) => setState(() => _shift = v!)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _date,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(const Duration(days: 30)),
                            );
                            if (picked != null) setState(() => _date = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: KormiColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 18, color: KormiColors.navy),
                                const SizedBox(width: 8),
                                Text('${_date.day}/${_date.month}/${_date.year}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _hoursController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          decoration: _input('OT Hours (2.5)'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _rateController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          decoration: _input('Rate / Hour (85)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: KormiColors.navy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total OT Amount', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text('৳ ${_currentTotal.toStringAsFixed(0)}',
                            style: const TextStyle(color: KormiColors.goldLight, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  KormiPrimaryButton(label: 'Save OT & Share Format', onPressed: _saveOt),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // OT List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('OT List (${_otList.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 17)),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('OT Share Format কপি হয়েছে')),
                    );
                  },
                  child: const Text('Share All', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ..._otList.map((ot) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: KormiCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: KormiColors.navy.withOpacity(0.1),
                        child: Text((ot['name'] as String)[0],
                            style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${ot['name']} • ${ot['card']}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                            Text('${ot['date']} • Shift ${ot['shift']} • ${ot['hours']} hrs @ ৳ ${ot['rate']}',
                                style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text('৳ ${(ot['total'] as double).toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 15)),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
        Text(label, style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
      ],
    );
  }

  Widget _dropdownBox(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KormiColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: KormiColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: KormiColors.border),
      ),
    );
  }
}
