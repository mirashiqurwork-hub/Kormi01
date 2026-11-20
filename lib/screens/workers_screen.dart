import 'package:flutter/material.dart';
import '../database/kormi_database.dart';
import '../models/worker_model.dart';

class WorkersScreen extends StatefulWidget {
  const WorkersScreen({super.key});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  List<WorkerModel> _all = [];
  List<WorkerModel> _filtered = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final list = KormiDatabase.getWorkers().map((e) => WorkerModel.fromMap(e)).toList();
    setState(() {
      _all = list;
      _filtered = list;
    });
  }

  void _onSearch(String q) {
    setState(() {
      if (q.isEmpty) {
        _filtered = _all;
      } else {
        _filtered = _all.where((w) => w.fullName.toLowerCase().contains(q.toLowerCase()) || w.cardNumber.contains(q)).toList();
      }
    });
  }

  Future<void> _showAddDialog() async {
    final cardC = TextEditingController();
    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    final nidC = TextEditingController();
    final salaryC = TextEditingController();
    String role = 'Worker';
    String shift = 'General';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Worker'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: cardC, decoration: const InputDecoration(labelText: 'Card Number *')),
                TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Full Name *')),
                TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone')),
                TextField(controller: nidC, decoration: const InputDecoration(labelText: 'NID / Birth Certificate')),
                TextField(controller: salaryC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Salary')),
                DropdownButtonFormField<String>(
                  value: role,
                  items: const [DropdownMenuItem(value: 'Worker', child: Text('Worker')), DropdownMenuItem(value: 'Officer', child: Text('Officer')), DropdownMenuItem(value: 'Management', child: Text('Management'))],
                  onChanged: (v) { role = v ?? 'Worker'; },
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
                DropdownButtonFormField<String>(
                  value: shift,
                  items: const [DropdownMenuItem(value: 'General', child: Text('General')), DropdownMenuItem(value: 'Shift A', child: Text('Shift A')), DropdownMenuItem(value: 'Shift B', child: Text('Shift B')), DropdownMenuItem(value: 'Shift C', child: Text('Shift C'))],
                  onChanged: (v) { shift = v ?? 'General'; },
                  decoration: const InputDecoration(labelText: 'Shift'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (cardC.text.trim().isEmpty || nameC.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card Number ar Name lagbe')));
                  return;
                }
                final w = WorkerModel(cardNumber: cardC.text.trim(), fullName: nameC.text.trim(), nid: nidC.text.trim(), phone: phoneC.text.trim(), dob: '', joiningDate: DateTime.now().toIso8601String().substring(0, 10), salary: salaryC.text.trim(), company: '', role: role, shift: shift);
                await KormiDatabase.saveWorker(w.toMap());
                if (mounted) Navigator.pop(context);
                _load();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(hintText: 'Search by name or card number', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('Kono worker nai. + button e chap diye add koro.'))
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) {
                      final w = _filtered[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(backgroundColor: const Color(0xFF0A1E3C), child: Text(w.fullName.isEmpty ? '?' : w.fullName[0], style: const TextStyle(color: Colors.white))),
                          title: Text(w.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Card: ${w.cardNumber} • ${w.role} • ${w.shift}\nSalary: ${w.salary}'),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await KormiDatabase.deleteWorker(w.cardNumber);
                              _load();
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFF0A1E3C),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Worker', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
