import 'package:flutter/material.dart';
import '../database/kormi_database.dart';
import '../models/worker_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<WorkerModel> _workers = [];
  Map<String, String> _status = {};
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final list = KormiDatabase.getWorkers().map((e) => WorkerModel.fromMap(e)).toList();
    setState(() {
      _workers = list;
      for (final w in list) {
        _status[w.cardNumber] = _status[w.cardNumber] ?? 'Present';
      }
    });
  }

  Future<void> _save() async {
    setState(() { _saving = true; });
    final dateStr = _date.toIso8601String().substring(0, 10);
    for (final w in _workers) {
      await KormiDatabase.saveAttendance({'cardNumber': w.cardNumber, 'name': w.fullName, 'date': dateStr, 'status': _status[w.cardNumber] ?? 'Present', 'shift': w.shift});
    }
    setState(() { _saving = false; });
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance Save hoyeche')));
  }

  Widget _chip(String card, String value, String label, Color color) {
    final selected = _status[card] == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: color,
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
      onSelected: (_) { setState(() { _status[card] = value; }); },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date: ${_date.toIso8601String().substring(0, 10)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(onPressed: () async {
                  final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2024), lastDate: DateTime(2030));
                  if (picked != null) setState(() { _date = picked; });
                }, child: const Text('Change Date')),
              ],
            ),
          ),
          Expanded(
            child: _workers.isEmpty
                ? const Center(child: Text('Age Worker add koro, tarpor Attendance dite parba.'))
                : ListView.builder(
                    itemCount: _workers.length,
                    itemBuilder: (context, i) {
                      final w = _workers[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(w.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Card: ${w.cardNumber} • ${w.shift}'),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: [
                                  _chip(w.cardNumber, 'Present', 'Present', Colors.green),
                                  _chip(w.cardNumber, 'Absent', 'Absent', Colors.red),
                                  _chip(w.cardNumber, 'Late', 'Late', Colors.orange),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A1E3C)),
                child: Text(_saving ? 'Saving...' : 'Save Attendance', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
