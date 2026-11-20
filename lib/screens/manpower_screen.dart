// KORMI - Manpower Screen
// ড্যাশবোর্ড -> Manpower কার্ডে চাপ দিলে এই পেজ খুলবে
// Section অনুযায়ী Required / Present / Absent + Share Format

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class ManpowerScreen extends StatefulWidget {
  const ManpowerScreen({super.key});

  @override
  State<ManpowerScreen> createState() => _ManpowerScreenState();
}

class _ManpowerScreenState extends State<ManpowerScreen> {
  String _shift = 'P/B';
  String _unit = 'Unit 1';
  DateTime _date = DateTime.now();

  // Section অনুযায়ী ম্যানপাওয়ার - Required / Present
  final Map<String, Map<String, TextEditingController>> _controllers = {};

  final List<String> _sections = ['BACKSIDE', 'RING', 'AUTOCONE', 'PACKING'];

  @override
  void initState() {
    super.initState();
    for (final s in _sections) {
      _controllers[s] = {
        'required': TextEditingController(text: '0'),
        'present': TextEditingController(text: '0'),
      };
    }
    // ডেমো ভ্যালু
    _controllers['BACKSIDE']!['required']!.text = '24';
    _controllers['BACKSIDE']!['present']!.text = '22';
    _controllers['RING']!['required']!.text = '48';
    _controllers['RING']!['present']!.text = '46';
    _controllers['AUTOCONE']!['required']!.text = '18';
    _controllers['AUTOCONE']!['present']!.text = '17';
    _controllers['PACKING']!['required']!.text = '12';
    _controllers['PACKING']!['present']!.text = '11';
  }

  @override
  void dispose() {
    for (final m in _controllers.values) {
      for (final c in m.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  int _totalRequired() {
    int t = 0;
    for (final s in _sections) {
      t += int.tryParse(_controllers[s]!['required']!.text) ?? 0;
    }
    return t;
  }

  int _totalPresent() {
    int t = 0;
    for (final s in _sections) {
      t += int.tryParse(_controllers[s]!['present']!.text) ?? 0;
    }
    return t;
  }

  String _buildShareText() {
    final b = StringBuffer();
    b.writeln('Manpower Summary');
    b.writeln('Shift:-$_shift • Date:-${_date.day}.${_date.month}.${_date.year}');
    b.writeln('Unit:-$_unit');
    for (final s in _sections) {
      final req = _controllers[s]!['required']!.text;
      final pre = _controllers[s]!['present']!.text;
      final abs = (int.tryParse(req) ?? 0) - (int.tryParse(pre) ?? 0);
      b.writeln('$s:- Required $req, Present $pre, Absent $abs');
    }
    b.writeln('Total:- Required ${_totalRequired()}, Present ${_totalPresent()}, Absent ${_totalRequired() - _totalPresent()}');
    b.writeln('*SIC NAME:- TARIQUL ISLAM*');
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    final totalReq = _totalRequired();
    final totalPre = _totalPresent();
    final totalAbs = totalReq - totalPre;

    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Manpower'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Shift + Unit + Date
            KormiCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _dropdownBox(
                          _shift,
                          ['P/A', 'P/B', 'P/C'],
                          (v) => setState(() => _shift = v!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _dropdownBox(
                          _unit,
                          ['Unit 1', 'Unit 2', 'G/F', 'F/F'],
                          (v) => setState(() => _unit = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date: ${_date.day}/${_date.month}/${_date.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy),
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
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Summary
            KormiCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem('Required', '$totalReq', KormiColors.navy),
                  _summaryItem('Present', '$totalPre', KormiColors.green),
                  _summaryItem('Absent', '$totalAbs', KormiColors.red),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Section কার্ড
            ..._sections.map((s) {
              final req = int.tryParse(_controllers[s]!['required']!.text) ?? 0;
              final pre = int.tryParse(_controllers[s]!['present']!.text) ?? 0;
              final abs = req - pre;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: KormiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(s, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: abs == 0 ? KormiColors.green.withOpacity(0.12) : KormiColors.red.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              abs == 0 ? 'Full' : 'Absent $abs',
                              style: TextStyle(
                                color: abs == 0 ? KormiColors.green : KormiColors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controllers[s]!['required'],
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              decoration: _input('Required'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _controllers[s]!['present'],
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              decoration: _input('Present'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 6),

            KormiPrimaryButton(
              label: 'Save Manpower & Share Format',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Manpower Saved - Present $totalPre / Required $totalReq')),
                );
              },
            ),
            const SizedBox(height: 14),

            // Share Format Preview
            KormiCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Manpower Share Format', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: KormiColors.navy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _buildShareText(),
                      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _shareBtn('Copy Text', Icons.copy_outlined)),
                      const SizedBox(width: 8),
                      Expanded(child: _shareBtn('WhatsApp', Icons.chat_outlined)),
                      const SizedBox(width: 8),
                      Expanded(child: _shareBtn('Other Apps', Icons.share_outlined)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 22)),
        Text(label, style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
      ],
    );
  }

  Widget _dropdownBox(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KormiColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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

  Widget _shareBtn(String label, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label - Manpower Format কপি হয়েছে')),
        );
      },
      icon: Icon(icon, size: 16, color: KormiColors.navy),
      label: Text(label, style: const TextStyle(color: KormiColors.navy, fontSize: 12, fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: KormiColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}
