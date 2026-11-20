import 'package:flutter/material.dart';
import '../database/kormi_database.dart';

class ProductionScreen extends StatefulWidget {
  const ProductionScreen({super.key});

  @override
  State<ProductionScreen> createState() => _ProductionScreenState();
}

class _ProductionScreenState extends State<ProductionScreen> {
  final TextEditingController _machineController = TextEditingController();
  final TextEditingController _shiftController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _actualController = TextEditingController();
  final TextEditingController _wasteController = TextEditingController();

  String _selectedShift = 'General';
  bool _isSaving = false;
  List<Map<String, dynamic>> _productionList = [];

  final List<String> _shifts = ['General', 'Shift A', 'Shift B', 'Shift C'];

  @override
  void initState() {
    super.initState();
    _loadProduction();
  }

  @override
  void dispose() {
    _machineController.dispose();
    _shiftController.dispose();
    _targetController.dispose();
    _actualController.dispose();
    _wasteController.dispose();
    super.dispose();
  }

  void _loadProduction() {
    setState(() {
      _productionList = KormiDatabase.getProduction();
    });
  }

  double _calculateEfficiency() {
    final double target = double.tryParse(_targetController.text) ?? 0;
    final double actual = double.tryParse(_actualController.text) ?? 0;
    if (target == 0) {
      return 0;
    }
    return (actual / target) * 100;
  }

  Future<void> _saveProduction() async {
    if (_machineController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Machine Number দাও')),
      );
      return;
    }
    if (_targetController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Target দাও')),
      );
      return;
    }
    if (_actualController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actual Production দাও')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final double target = double.tryParse(_targetController.text) ?? 0;
    final double actual = double.tryParse(_actualController.text) ?? 0;
    final double waste = double.tryParse(_wasteController.text) ?? 0;
    final double efficiency = _calculateEfficiency();

    final Map<String, dynamic> data = {
      'machine': _machineController.text.trim(),
      'shift': _selectedShift,
      'target': target,
      'actual': actual,
      'waste': waste,
      'efficiency': efficiency,
      'date': DateTime.now().toIso8601String(),
    };

    await KormiDatabase.saveProduction(data);

    setState(() {
      _isSaving = false;
    });

    _machineController.clear();
    _targetController.clear();
    _actualController.clear();
    _wasteController.clear();
    _loadProduction();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Production Save হয়েছে')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1E3C),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Production Entry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Shift অনুযায়ী Production জমা দাও',
                  style: TextStyle(
                    color: Color(0xFFD4AF6A),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _machineController,
            decoration: InputDecoration(
              labelText: 'Machine Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedShift,
                isExpanded: true,
                items: _shifts.map((String shift) {
                  return DropdownMenuItem<String>(
                    value: shift,
                    child: Text(shift),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedShift = value;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _targetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Target (Kg)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _actualController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Actual Production (Kg)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _wasteController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Waste (Kg)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveProduction,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A1E3C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Save Production',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Today Production List',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A1E3C),
            ),
          ),
          const SizedBox(height: 12),
          if (_productionList.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'এখনো কোনো Production জমা হয় নাই।',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ..._productionList.map((Map<String, dynamic> item) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A1E3C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.factory,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Machine: ${item['machine'] ?? ''} - ${item['shift'] ?? ''}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Target: ${item['target'] ?? 0} Kg | Actual: ${item['actual'] ?? 0} Kg',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${(item['efficiency'] ?? 0).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A1E3C),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
