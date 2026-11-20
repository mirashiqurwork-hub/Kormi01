import 'package:flutter/material.dart';
import '../database/kormi_database.dart';
import 'production_calculator.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  final TextEditingController _machineC = TextEditingController();
  final TextEditingController _targetC = TextEditingController();
  final TextEditingController _actualC = TextEditingController();
  final TextEditingController _wasteC = TextEditingController();
  String _shift = 'General';
  List<Map<String, dynamic>> _list = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() { _list = KormiDatabase.getProduction(); });
  }

  double get _efficiency {
    final t = double.tryParse(_targetC.text) ?? 0;
    final a = double.tryParse(_actualC.text) ?? 0;
    return ProductionCalculator.calculateEfficiency(t, a);
  }

  double get _net {
    final a = double.tryParse(_actualC.text) ?? 0;
    final w = double.tryParse(_wasteC.text) ?? 0;
    return ProductionCalculator.calculateNetProduction(a, w);
  }

  Future<void> _save() async {
    if (_machineC.text.trim().isEmpty || _targetC.text.trim().isEmpty || _actualC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Machine, Target, Actual lagbe')));
      return;
    }
    setState(() { _saving = true; });
    await KormiDatabase.saveProduction({'machine': _machineC.text.trim(), 'shift': _shift, 'target': double.tryParse(_targetC.text) ?? 0, 'actual': double.tryParse(_actualC.text) ?? 0, 'waste': double.tryParse(_wasteC.text) ?? 0, 'efficiency': _efficiency, 'net': _net, 'date': DateTime.now().toIso8601String()});
    setState(() { _saving = false; });
    _machineC.clear();
    _targetC.clear();
    _actualC.clear();
    _wasteC.clear();
    _load();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Production Save hoyeche')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF0A1E3C), borderRadius: BorderRadius.circular(16)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Production Entry', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Machine + Shift + Calculator', style: TextStyle(color: Color(0xFFD4AF6A), fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(controller: _machineC, decoration: InputDecoration(labelText: 'Machine Number', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _shift,
              items: const [DropdownMenuItem(value: 'General', child: Text('General')), DropdownMenuItem(value: 'Shift A', child: Text('Shift A')), DropdownMenuItem(value: 'Shift B', child: Text('Shift B')), DropdownMenuItem(value: 'Shift C', child: Text('Shift C'))],
              onChanged: (v) { setState(() { _shift = v ?? 'General'; }); },
              decoration: InputDecoration(labelText: 'Shift', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(controller: _targetC, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), decoration: InputDecoration(labelText: 'Target (Kg)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white)),
            const SizedBox(height: 10),
            TextField(controller: _actualC, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), decoration: InputDecoration(labelText: 'Actual (Kg)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white)),
            const SizedBox(height: 10),
            TextField(controller: _wasteC, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), decoration: InputDecoration(labelText: 'Waste (Kg)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFF6F1E7), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFD4AF6A))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Production Calculator', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A1E3C))),
                  const SizedBox(height: 6),
                  Text('Efficiency: ${_efficiency.toStringAsFixed(1)}% • ${ProductionCalculator.getEfficiencyLabel(_efficiency)}'),
                  Text('Net Production: ${_net.toStringAsFixed(1)} Kg'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _saving ? null : _save, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A1E3C)), child: Text(_saving ? 'Saving...' : 'Save Production', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            const SizedBox(height: 16),
            const Text('Production List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0A1E3C))),
            const SizedBox(height: 8),
            if (_list.isEmpty) const Text('Ekhono kono production nai.'),
            ..._list.map((e) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.factory, color: Color(0xFF0A1E3C)),
                  title: Text('Machine: ${e['machine']} • ${e['shift']}'),
                  subtitle: Text('Target: ${e['target']} Kg • Actual: ${e['actual']} Kg • Waste: ${e['waste']} Kg'),
                  trailing: Text('${(e['efficiency'] is num ? (e['efficiency'] as num).toDouble() : 0).toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
