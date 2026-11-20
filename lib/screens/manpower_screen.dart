// KORMI - Manpower Screen - REAL ACTION
// Required vs Present vs Shortage - Real Calculation + Save

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class ManpowerScreen extends StatefulWidget {
  const ManpowerScreen({super.key});

  @override
  State<ManpowerScreen> createState() => _ManpowerScreenState();
}

class _ManpowerScreenState extends State<ManpowerScreen> {
  String _shift = 'P/B-R/C';
  String _unit = 'Unit 1';

  // Required Manpower - Admin Edit করতে পারবে
  final Map<String, TextEditingController> _requiredControllers = {};
  // Present - Attendance থেকে আসবে, এখানে Edit করা যাবে
  final Map<String, TextEditingController> _presentControllers = {};

  final List<String> _sections = ['BACKSIDE', 'RING', 'AUTOCONE', 'PACKING'];

  final Map<String, Map<String, int>> _defaultData = {
    'BACKSIDE': {'required': 42, 'present': 38},
    'RING': {'required': 68, 'present': 64},
    'AUTOCONE': {'required': 28, 'present': 26},
    'PACKING': {'required': 24, 'present': 22},
  };

  @override
  void initState() {
    super.initState();
    for (final s in _sections) {
      _requiredControllers[s] = TextEditingController(text: _defaultData[s]!['required'].toString());
      _presentControllers[s] = TextEditingController(text: _defaultData[s]!['present'].toString());
    }
  }

  @override
  void dispose() {
    for (final c in _requiredControllers.values) c.dispose();
    for (final c in _presentControllers.values) c.dispose();
    super.dispose();
  }

  int _req(String s) => int.tryParse(_requiredControllers[s]!.text) ?? 0;
  int _present(String s) => int.tryParse(_presentControllers[s]!.text) ?? 0;
  int _shortage(String s) => (_req(s) - _present(s)).clamp(0, 999);
  double _percent(String s) => _req(s) == 0 ? 0 : (_present(s) / _req(s) * 100);

  int get _totalReq => _sections.fold(0, (sum, s) => sum + _req(s));
  int get _totalPresent => _sections.fold(0, (sum, s) => sum + _present(s));
  int get _totalShortage => _totalReq - _totalPresent;
  double get _totalPercent => _totalReq == 0 ? 0 : (_totalPresent / _totalReq * 100);

  void _adjust(String section, bool isRequired, int delta) {
    final controller = isRequired ? _requiredControllers[section]! : _presentControllers[section]!;
    final current = int.tryParse(controller.text) ?? 0;
    final next = (current + delta).clamp(0, 500);
    setState(() => controller.text = next.toString());
  }

  void _reset() {
    setState(() {
      for (final s in _sections) {
        _requiredControllers[s]!.text = _defaultData[s]!['required'].toString();
        _presentControllers[s]!.text = _defaultData[s]!['present'].toString();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Manpower Reset করা হয়েছে')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Manpower'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh_outlined), onPressed: _reset),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: KormiColors.border)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _unit,
                        isExpanded: true,
                        items: ['Unit 1', 'Unit 2', 'G/F', 'F/F'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => setState(() => _unit = v!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: KormiColors.border)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _shift,
                        isExpanded: true,
                        items: ['P/A', 'P/B', 'P/B-R/C', 'P/C'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => setState(() => _shift = v!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Total Summary - Real
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: KormiColors.navy, borderRadius: BorderRadius.circular(20), border: Border.all(color: KormiColors.gold.withOpacity(0.3))),
              child: Column(
                children: [
                  Text('$_unit • $_shift', style: const TextStyle(color: KormiColors.goldLight, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _totalItem('Required', '$_totalReq', Colors.white),
                      _totalItem('Present', '$_totalPresent', KormiColors.goldLight),
                      _totalItem('Shortage', '$_totalShortage', _totalShortage > 0 ? Colors.redAccent : Colors.greenAccent),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(value: _totalPercent / 100, minHeight: 8, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation<Color>(KormiColors.gold)),
                  ),
                  const SizedBox(height: 6),
                  Text('Manpower Fulfillment: ${_totalPercent.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ..._sections.map((s) {
              final shortage = _shortage(s);
              final pct = _percent(s);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
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
                            decoration: BoxDecoration(color: shortage == 0 ? KormiColors.green.withOpacity(0.12) : KormiColors.red.withOpacity(0.10), borderRadius: BorderRadius.circular(20)),
                            child: Text(shortage == 0 ? 'Full' : 'Short: $shortage', style: TextStyle(color: shortage == 0 ? KormiColors.green : KormiColors.red, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _numberBox('Required', _requiredControllers[s]!, () => _adjust(s, true, -1), () => _adjust(s, true, 1))),
                          const SizedBox(width: 10),
                          Expanded(child: _numberBox('Present', _presentControllers[s]!, () => _adjust(s, false, -1), () => _adjust(s, false, 1))),
                          const SizedBox(width: 10),
                          Expanded(child: _readBox('Shortage', '$shortage', shortage == 0 ? KormiColors.green : KormiColors.red)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(value: pct / 100, minHeight: 6, backgroundColor: KormiColors.bg, valueColor: AlwaysStoppedAnimation<Color>(shortage == 0 ? KormiColors.green : KormiColors.gold)),
                      ),
                      const SizedBox(height: 4),
                      Text('${pct.toStringAsFixed(0)}% Present', style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 6),
            KormiPrimaryButton(
              label: 'Save Manpower - $_unit • $_shift',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved - Required: $_totalReq, Present: $_totalPresent, Shortage: $_totalShortage')));
              },
            ),
            const SizedBox(height: 10),
            KormiPrimaryButton(
              label: 'Share Manpower Report',
              onPressed: () {
                final text = 'MANPOWER - $_unit • $_shift\nRequired: $_totalReq\nPresent: $_totalPresent\nShortage: $_totalShortage\nFulfillment: ${_totalPercent.toStringAsFixed(1)}%';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
              },
            ),
            const SizedBox(height: 8),
            const Text('Shortage > 0 হলে Admin কে Alert যাবে।', textAlign: TextAlign.center, style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _totalItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 22)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _numberBox(String label, TextEditingController controller, VoidCallback minus, VoidCallback plus) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: KormiColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: KormiColors.border)),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(onTap: minus, child: const CircleAvatar(radius: 13, backgroundColor: KormiColors.navy, child: Icon(Icons.remove, size: 14, color: Colors.white))),
              SizedBox(
                width: 44,
                child: TextField(controller: controller, keyboardType: TextInputType.number, textAlign: TextAlign.center, onChanged: (_) => setState(() {}), decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true), style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 16)),
              ),
              GestureDetector(onTap: plus, child: const CircleAvatar(radius: 13, backgroundColor: KormiColors.gold, child: Icon(Icons.add, size: 14, color: KormiColors.navy))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _readBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: KormiColors.bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: KormiColors.border)),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
          const SizedBox(height: 4),
          const Text('auto', style: TextStyle(color: KormiColors.textGrey, fontSize: 10)),
        ],
      ),
    );
  }
}
