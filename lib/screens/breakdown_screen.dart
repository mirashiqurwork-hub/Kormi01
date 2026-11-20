// KORMI - Breakdown Screen
// Report Machine Breakdown + Breakdown Log + Share Format

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class BreakdownScreen extends StatefulWidget {
  const BreakdownScreen({super.key});

  @override
  State<BreakdownScreen> createState() => _BreakdownScreenState();
}

class _BreakdownScreenState extends State<BreakdownScreen> {
  String _mc = 'C/D';
  String _unit = 'Unit 1';
  String _machineType = 'Ring Frame';
  String _shift = 'P/B-R/C';
  final _machineNoController = TextEditingController(text: 'RF-09');
  final _minutesController = TextEditingController(text: '35');
  final _reporterController = TextEditingController(text: 'Tariqul Islam');
  final _faultController = TextEditingController();

  final List<Map<String, dynamic>> _logs = [
    {
      'title': 'RF-14',
      'type': 'Ring Frame (P/A)',
      'minutes': 45,
      'reason': 'Main drive belt tension slip',
      'resolved': false,
    },
    {
      'title': 'CD-04',
      'type': 'Carding (P/B)',
      'minutes': 25,
      'reason': 'Flat stripping comb motor thermal trip',
      'resolved': false,
    },
  ];

  void _logBreakdown() {
    final minutes = int.tryParse(_minutesController.text.trim()) ?? 0;
    final machineNo = _machineNoController.text.trim();
    final fault = _faultController.text.trim();

    if (machineNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Machine No দিন')),
      );
      return;
    }
    if (minutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Down Minutes দিন')),
      );
      return;
    }

    setState(() {
      _logs.insert(0, {
        'title': machineNo,
        'type': '$_machineType ($_shift)',
        'minutes': minutes,
        'reason': fault.isEmpty ? 'Fault reason লেখা হয়নি' : fault,
        'resolved': false,
      });
      _faultController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Breakdown Logged - $machineNo, $minutes min down')),
    );
  }

  String _buildShareText(Map<String, dynamic> log) {
    return 'Breakdown Report\nMachine: ${log['title']} - ${log['type']}\nDown: ${log['minutes']} min\nReason: ${log['reason']}\nReported By: Tariqul Islam (ADMIN)';
  }

  @override
  void dispose() {
    _machineNoController.dispose();
    _minutesController.dispose();
    _reporterController.dispose();
    _faultController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Breakdown'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Form
            KormiCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Report Machine Breakdown',
                      style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 17)),
                  const SizedBox(height: 14),

                  // MC Name Chips
                  const Text('Select MC Name', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['C/D', 'B/D', 'F/D', 'S/F', 'R/F', 'L/C'].map((m) {
                      final active = _mc == m;
                      return GestureDetector(
                        onTap: () => setState(() => _mc = m),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                          decoration: BoxDecoration(
                            color: active ? KormiColors.navy : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: KormiColors.border),
                          ),
                          child: Text(
                            m,
                            style: TextStyle(
                              color: active ? KormiColors.goldLight : KormiColors.navy,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(child: _dropdownBox(_unit, ['Unit 1', 'Unit 2'], (v) => setState(() => _unit = v!))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _dropdownBox(
                          _machineType,
                          ['Ring Frame', 'Carding', 'Draw Frame', 'Simplex', 'Winding', 'Autocone'],
                          (v) => setState(() => _machineType = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(child: _dropdownBox(_shift, ['P/A', 'P/B', 'P/B-R/C', 'P/C'], (v) => setState(() => _shift = v!))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _machineNoController,
                          decoration: _input('Machine No (RF-09)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minutesController,
                          keyboardType: TextInputType.number,
                          decoration: _input('Down Minutes (35)'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _reporterController,
                          decoration: _input('Reporter Name'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _faultController,
                    maxLines: 3,
                    decoration: _input('Describe fault & stoppage reason...'),
                  ),
                  const SizedBox(height: 14),

                  KormiPrimaryButton(
                    label: 'Log Breakdown & Share Format (${_minutesController.text} min)',
                    onPressed: _logBreakdown,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Breakdown Log
            Text('Breakdown Log (${_logs.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 17)),
            const SizedBox(height: 10),

            ..._logs.map((log) {
              final resolved = log['resolved'] as bool;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: KormiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${log['title']} • ${log['type']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 15),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: resolved ? KormiColors.green.withOpacity(0.12) : KormiColors.red.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              resolved ? 'Resolved' : '${log['minutes']} min down',
                              style: TextStyle(
                                color: resolved ? KormiColors.green : KormiColors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(log['reason'], style: const TextStyle(color: KormiColors.textGrey, fontSize: 13)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(_buildShareText(log))),
                                );
                              },
                              icon: const Icon(Icons.share_outlined, size: 16, color: KormiColors.navy),
                              label: const Text('Share', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: KormiColors.border),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: resolved
                                  ? null
                                  : () {
                                      setState(() => log['resolved'] = true);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${log['title']} Mark Resolved')),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: resolved ? Colors.grey : KormiColors.navy,
                                foregroundColor: KormiColors.goldLight,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text(resolved ? 'Resolved' : 'Mark Resolved',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
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
}
