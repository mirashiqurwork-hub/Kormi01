// KORMI - Production Screen
// Entry & Log / Calculators / Sheet OCR
// Save & Generate Share Format + Saved Machine Outputs

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  int _tab = 0;
  String _unit = 'Unit 1';
  String _shift = 'P/B-R/C';

  // মেশিন ইনপুট
  final Map<String, TextEditingController> _kgControllers = {};
  final Map<String, TextEditingController> _bagControllers = {};

  final List<String> _machines = ['C/D', 'B/D', 'F/D', 'S/F', 'R/F', 'L/C'];

  // সেভ করা আউটপুট
  final List<Map<String, String>> _saved = [
    {'mc': 'C/D', 'unit': 'Unit 1', 'shift': 'P/B-R/C', 'kg': '4928', 'bag': '0'},
    {'mc': 'B/D', 'unit': 'Unit 1', 'shift': 'P/B-R/C', 'kg': '5093', 'bag': '0'},
    {'mc': 'F/D', 'unit': 'Unit 1', 'shift': 'P/B-R/C', 'kg': '4651', 'bag': '0'},
    {'mc': 'S/F', 'unit': 'Unit 1', 'shift': 'P/B-R/C', 'kg': '3311', 'bag': '0'},
    {'mc': 'R/F', 'unit': 'Unit 1', 'shift': 'P/B-R/C', 'kg': '2867', 'bag': '0'},
    {'mc': 'L/C', 'unit': 'Unit 1', 'shift': 'P/B-R/C', 'kg': '2933', 'bag': '0'},
  ];

  @override
  void initState() {
    super.initState();
    for (final m in _machines) {
      _kgControllers[m] = TextEditingController();
      _bagControllers[m] = TextEditingController(text: '0');
    }
  }

  @override
  void dispose() {
    for (final c in _kgControllers.values) {
      c.dispose();
    }
    for (final c in _bagControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  double get _totalKg {
    double total = 0;
    for (final s in _saved) {
      total += double.tryParse(s['kg'] ?? '0') ?? 0;
    }
    return total;
  }

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
            const Text('Sheet OCR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: KormiColors.navy)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: KormiColors.navy),
              title: const Text('Select Photo from Gallery'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gallery থেকে শিটের ছবি সিলেক্ট করুন')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: KormiColors.navy),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ক্যামেরা দিয়ে শিটের ছবি তুলুন')),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // শেয়ার ফরম্যাট তৈরি
  String _buildShareText() {
    final buffer = StringBuffer();
    buffer.writeln('Shift:-$_shift');
    buffer.writeln('Date:-18.11.26');
    buffer.writeln('production summary');
    for (final s in _saved) {
      buffer.writeln('${s['mc']}:- ${s['kg']} kg,');
    }
    buffer.writeln('Packing = 00 Bag');
    buffer.writeln('*SIC NAME:- TARIQUL ISLAM*');
    buffer.writeln('*DEG:- CHIEF MILL ADMINISTRATOR*');
    return buffer.toString();
  }

  void _saveAndGenerate() {
    // নতুন ইনপুট থাকলে সেভ লিস্টে যোগ করি
    for (final m in _machines) {
      final kg = _kgControllers[m]!.text.trim();
      if (kg.isNotEmpty) {
        setState(() {
          _saved.removeWhere((e) => e['mc'] == m && e['shift'] == _shift);
          _saved.insert(0, {
            'mc': m,
            'unit': _unit,
            'shift': _shift,
            'kg': kg,
            'bag': _bagControllers[m]!.text.trim().isEmpty ? '0' : _bagControllers[m]!.text.trim(),
          });
          _kgControllers[m]!.clear();
        });
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved ${_saved.length} machine output(s) ready to share.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Production'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: _showOcrOptions,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // ট্যাব
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: KormiColors.border),
              ),
              child: Row(
                children: [
                  _tabBtn('Entry & Log', 0),
                  _tabBtn('Calculators', 1),
                  _tabBtn('Sheet OCR', 2),
                ],
              ),
            ),
            const SizedBox(height: 14),

            if (_tab == 0) ...[
              // Unit + Shift
              Row(
                children: [
                  Expanded(
                    child: _dropdownBox(
                      _unit,
                      ['Unit 1', 'Unit 2'],
                      (v) => setState(() => _unit = v!),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _dropdownBox(
                      _shift,
                      ['P/A', 'P/B', 'P/B-R/C', 'P/C'],
                      (v) => setState(() => _shift = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Total
              KormiCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Unit 1 Total Output', style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                        SizedBox(height: 4),
                        Text('39,353.7 kg', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 19)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${_totalKg.toStringAsFixed(0)} kg', style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                        const Text('96 packing bags', style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // মেশিন ইনপুট
              ..._machines.map((m) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: KormiCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MC: $m  •  $_unit  •  $_shift',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _kgControllers[m],
                                keyboardType: TextInputType.number,
                                decoration: _input('kg (e.g. 4928)'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _bagControllers[m],
                                keyboardType: TextInputType.number,
                                decoration: _input('Bag'),
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
                label: 'Save & Generate Share Format',
                onPressed: _saveAndGenerate,
              ),
              const SizedBox(height: 14),

              // শেয়ার ফরম্যাট প্রিভিউ
              KormiCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Production Summary Share Format',
                        style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
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
              const SizedBox(height: 14),

              // Saved Machine Outputs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Saved Machine Outputs (${_saved.length})',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 16)),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Latest Share Format কপি করা হয়েছে')),
                      );
                    },
                    child: const Text('Share Latest', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              ..._saved.map((s) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: KormiCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('MC: ${s['mc']}  •  ${s['unit']} • ${s['shift']}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                              Text('${s['kg']} kg  •  ${s['bag']} Bag',
                                  style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.share_outlined, color: KormiColors.textGrey, size: 20),
                      ],
                    ),
                  ),
                );
              }),
            ],

            if (_tab == 1) ...[
              const KormiCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Spinning Mill Machine Calculator',
                        style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 16)),
                    SizedBox(height: 12),
                    Text('Drawing / Simplex / Ring / Winding', style: TextStyle(color: KormiColors.textGrey)),
                    SizedBox(height: 12),
                    Text('Spindle RPM: 16500  •  TPI: 19.5  •  Count: 30 Ne'),
                    Text('Spindles: 1008  •  Efficiency: 92%'),
                    SizedBox(height: 12),
                    Text('8-Hour Shift Output (Ring)', style: TextStyle(color: KormiColors.textGrey)),
                    Text('188.32 kg/shift', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 22)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const KormiPrimaryButton(label: 'Use in Entry', onPressed: null),
            ],

            if (_tab == 2) ...[
              KormiCard(
                child: Column(
                  children: [
                    const Icon(Icons.camera_alt_outlined, size: 48, color: KormiColors.navy),
                    const SizedBox(height: 10),
                    const Text('Sheet OCR', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 18)),
                    const Text('শিটের ছবি তুললেই প্রোডাকশন ডাটা অটো বসে যাবে', style: TextStyle(color: KormiColors.textGrey)),
                    const SizedBox(height: 14),
                    KormiPrimaryButton(label: 'Open Camera / Gallery', onPressed: _showOcrOptions),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tabBtn(String label, int index) {
    final active = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? KormiColors.navy : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? KormiColors.goldLight : KormiColors.textGrey,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
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

  Widget _shareBtn(String label, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label - Share Format কপি হয়েছে')),
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
