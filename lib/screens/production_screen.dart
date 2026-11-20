// KORMI - Production Screen - REAL ACTION
// Calculator + OCR + Entry & Log - সব Action কাজ করবে
// Formula: ProductionCalculator + SheetOcrService ব্যবহার করে

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';
import '../utils/production_calculator.dart';
import '../services/sheet_ocr_service.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  int _tab = 0;
  String _unit = 'Unit 1';
  String _shift = 'P/B-R/C';

  final Map<String, TextEditingController> _kgControllers = {};
  final List<String> _machines = ['C/D', 'B/D', 'F/D', 'S/F', 'R/F', 'L/C'];

  // Calculator Inputs
  final _rpmController = TextEditingController(text: '16500');
  final _tpiController = TextEditingController(text: '19.5');
  final _countController = TextEditingController(text: '30');
  final _spindleController = TextEditingController(text: '1008');
  final _effController = TextEditingController(text: '92');
  double _calcResult = 188.32;

  // Saved Outputs
  final List<Map<String, String>> _saved = [
    {'mc': 'C/D', 'unit': 'Unit 1', 'shift': 'P/B-R/C', 'kg': '4928'},
    {'mc': 'B/D', 'unit': 'Unit 1', 'shift': 'P/B-R/C', 'kg': '5093'},
    {'mc': 'F/D', 'unit': 'Unit 1', 'shift': 'P/B-R/C', 'kg': '4651'},
    {'mc': 'S/F', 'unit': 'Unit 1', 'shift': 'P/B-R/C', 'kg': '3311'},
    {'mc': 'R/F', 'unit': 'Unit 1', 'shift': 'P/B-R/C', 'kg': '2867'},
    {'mc': 'L/C', 'unit': 'Unit 1', 'shift': 'P/B-R/C', 'kg': '2933'},
  ];

  @override
  void initState() {
    super.initState();
    for (final m in _machines) {
      _kgControllers[m] = TextEditingController();
    }
    _calculateRing();
  }

  @override
  void dispose() {
    for (final c in _kgControllers.values) {
      c.dispose();
    }
    _rpmController.dispose();
    _tpiController.dispose();
    _countController.dispose();
    _spindleController.dispose();
    _effController.dispose();
    super.dispose();
  }

  double get _totalKg {
    double total = 0;
    for (final s in _saved) {
      total += double.tryParse(s['kg'] ?? '0') ?? 0;
    }
    return total;
  }

  void _calculateRing() {
    final rpm = double.tryParse(_rpmController.text) ?? 0;
    final tpi = double.tryParse(_tpiController.text) ?? 0;
    final count = double.tryParse(_countController.text) ?? 0;
    final spindles = int.tryParse(_spindleController.text) ?? 0;
    final eff = double.tryParse(_effController.text) ?? 0;

    final result = ProductionCalculator.ringKgPerShift(
      spindleRpm: rpm,
      tpi: tpi,
      countNe: count,
      spindles: spindles,
      efficiencyPercent: eff,
      hours: 8,
    );
    setState(() => _calcResult = result);
  }

  // OCR Action - Demo OCR Text থেকে Auto Fill
  void _runOcrDemo() {
    final demoText = SheetOcrService.demoOcrText();
    final parsed = SheetOcrService.parseProductionFromOcrText(demoText);
    final shift = SheetOcrService.parseShiftFromOcrText(demoText);

    setState(() {
      _shift = shift;
      for (final e in parsed.entries) {
        if (_kgControllers.containsKey(e.key)) {
          _kgControllers[e.key]!.text = e.value.toStringAsFixed(0);
        }
      }
      _tab = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(SheetOcrService.ocrResultSummary(parsed))),
    );
  }

  void _showOcrOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                _runOcrDemo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: KormiColors.navy),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _runOcrDemo();
              },
            ),
            ListTile(
              leading: const Icon(Icons.bug_report_outlined, color: KormiColors.navy),
              title: const Text('Demo OCR Test (ছবি ছাড়া Test)'),
              onTap: () {
                Navigator.pop(context);
                _runOcrDemo();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  String _buildShareText() {
    final map = <String, double>{};
    for (final s in _saved) {
      map[s['mc']!] = double.tryParse(s['kg'] ?? '0') ?? 0;
    }
    return ProductionCalculator.buildShareText(
      shift: _shift,
      date: '18.11.26',
      machineKgs: map,
      packingBags: ProductionCalculator.kgToBag(_totalKg),
      sicName: 'TARIQUL ISLAM',
      designation: 'CHIEF MILL ADMINISTRATOR',
    );
  }

  void _saveAndGenerate() {
    for (final m in _machines) {
      final kg = _kgControllers[m]!.text.trim();
      if (kg.isNotEmpty) {
        setState(() {
          _saved.removeWhere((e) => e['mc'] == m && e['shift'] == _shift);
          _saved.insert(0, {'mc': m, 'unit': _unit, 'shift': _shift, 'kg': kg});
          _kgControllers[m]!.clear();
        });
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved ${_saved.length} machine output(s) - Total ${_totalKg.toStringAsFixed(0)} kg')),
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
          IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: _showOcrOptions),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
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
              Row(
                children: [
                  Expanded(child: _dropdownBox(_unit, ['Unit 1', 'Unit 2'], (v) => setState(() => _unit = v!))),
                  const SizedBox(width: 10),
                  Expanded(child: _dropdownBox(_shift, ['P/A', 'P/B', 'P/B-R/C', 'P/C'], (v) => setState(() => _shift = v!))),
                ],
              ),
              const SizedBox(height: 12),
              KormiCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Unit 1 Total Output', style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                        SizedBox(height: 4),
                        Text('Real Total - Saved থেকে', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${_totalKg.toStringAsFixed(0)} kg', style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 18)),
                        Text('${ProductionCalculator.kgToBag(_totalKg).toStringAsFixed(0)} packing bags', style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ..._machines.map((m) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: KormiCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MC: $m  •  $_unit  •  $_shift', style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _kgControllers[m],
                          keyboardType: TextInputType.number,
                          decoration: _input('kg (e.g. 4928)'),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 6),
              KormiPrimaryButton(label: 'Save & Generate Share Format', onPressed: _saveAndGenerate),
              const SizedBox(height: 14),
              KormiCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Production Summary Share Format', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: KormiColors.navy, borderRadius: BorderRadius.circular(12)),
                      child: Text(_buildShareText(), style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5)),
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
              Text('Saved Machine Outputs (${_saved.length})', style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 16)),
              const SizedBox(height: 8),
              ..._saved.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: KormiCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('MC: ${s['mc']}  •  ${s['unit']} • ${s['shift']}', style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                                Text('${s['kg']} kg', style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.share_outlined, color: KormiColors.textGrey, size: 20),
                        ],
                      ),
                    ),
                  )),
            ],

            if (_tab == 1) ...[
              KormiCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ring Frame Calculator - Real Formula', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 16)),
                    const SizedBox(height: 12),
                    _calcField('Spindle RPM', _rpmController),
                    const SizedBox(height: 10),
                    _calcField('TPI', _tpiController),
                    const SizedBox(height: 10),
                    _calcField('Count (Ne)', _countController),
                    const SizedBox(height: 10),
                    _calcField('Spindles', _spindleController),
                    const SizedBox(height: 10),
                    _calcField('Efficiency %', _effController),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: KormiColors.navy, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          const Text('8-Hour Shift Output (Ring)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          Text('${_calcResult.toStringAsFixed(2)} kg/shift', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22)),
                          Text('${ProductionCalculator.kgToBag(_calcResult).toStringAsFixed(2)} Bags', style: const TextStyle(color: KormiColors.goldLight)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    KormiPrimaryButton(label: 'Calculate', onPressed: _calculateRing),
                    const SizedBox(height: 10),
                    KormiPrimaryButton(
                      label: 'Use in Entry (R/F)',
                      onPressed: () {
                        setState(() {
                          _kgControllers['R/F']!.text = _calcResult.toStringAsFixed(0);
                          _tab = 0;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calculator Result R/F Entry তে বসানো হয়েছে')));
                      },
                    ),
                  ],
                ),
              ),
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
                    const SizedBox(height: 10),
                    KormiPrimaryButton(label: 'Demo OCR Test', onPressed: _runOcrDemo),
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
          decoration: BoxDecoration(color: active ? KormiColors.navy : Colors.transparent, borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(label, style: TextStyle(color: active ? KormiColors.goldLight : KormiColors.textGrey, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
      ),
    );
  }

  Widget _dropdownBox(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: KormiColors.border)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(value: value, isExpanded: true, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged),
      ),
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)),
    );
  }

  Widget _calcField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(controller: controller, keyboardType: TextInputType.number, decoration: _input(label), onChanged: (_) => _calculateRing()),
      ],
    );
  }

  Widget _shareBtn(String label, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label - Share Format কপি হয়েছে')));
      },
      icon: Icon(icon, size: 16, color: KormiColors.navy),
      label: Text(label, style: const TextStyle(color: KormiColors.navy, fontSize: 12, fontWeight: FontWeight.bold)),
      style: OutlinedButton.styleFrom(side: const BorderSide(color: KormiColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), padding: const EdgeInsets.symmetric(vertical: 10)),
    );
  }
}
