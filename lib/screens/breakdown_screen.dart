// KORMI - Breakdown Screen - REAL ACTION
// Report Breakdown + Start / In Progress / Fixed + Downtime Calculation

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class BreakdownScreen extends StatefulWidget {
  const BreakdownScreen({super.key});

  @override
  State<BreakdownScreen> createState() => _BreakdownScreenState();
}

class _BreakdownScreenState extends State<BreakdownScreen> {
  String _filter = 'All';
  String _machine = 'R/F';
  String _section = 'RING';
  String _priority = 'High';

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  final List<Map<String, dynamic>> _items = [
    {'id': 'BD-101', 'machine': 'R/F', 'section': 'RING', 'title': 'Spindle Belt Slip', 'desc': 'Ring Frame 12 - Belt slip হচ্ছে, Production কমে গেছে', 'status': 'In Progress', 'priority': 'High', 'reportedBy': 'Rahim Uddin', 'time': '08:15 AM', 'downtimeMin': 45},
    {'id': 'BD-100', 'machine': 'C/D', 'section': 'BACKSIDE', 'title': 'Carding Wire Damage', 'desc': 'Carding machine wire damage', 'status': 'Open', 'priority': 'High', 'reportedBy': 'Karim Sheikh', 'time': '07:40 AM', 'downtimeMin': 80},
    {'id': 'BD-099', 'machine': 'AUTOCONE', 'section': 'AUTOCONE', 'title': 'Yarn Breakage High', 'desc': 'Autocone yarn breakage বেড়ে গেছে', 'status': 'Fixed', 'priority': 'Medium', 'reportedBy': 'Nasir Ahmed', 'time': 'Yesterday', 'downtimeMin': 30},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    var list = _items;
    if (_filter == 'Open') list = list.where((e) => e['status'] == 'Open').toList();
    if (_filter == 'In Progress') list = list.where((e) => e['status'] == 'In Progress').toList();
    if (_filter == 'Fixed') list = list.where((e) => e['status'] == 'Fixed').toList();
    return list;
  }

  int get _openCount => _items.where((e) => e['status'] == 'Open').length;
  int get _progressCount => _items.where((e) => e['status'] == 'In Progress').length;
  int get _fixedCount => _items.where((e) => e['status'] == 'Fixed').length;
  int get _totalDowntime => _items.fold(0, (sum, e) => sum + (e['downtimeMin'] as int));

  void _changeStatus(int index, String newStatus) {
    setState(() => _items[index]['status'] = newStatus);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_items[index]['id']} - $newStatus')));
  }

  void _reportBreakdown() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Breakdown Title লিখুন')));
      return;
    }
    setState(() {
      _items.insert(0, {
        'id': 'BD-${100 + _items.length + 1}',
        'machine': _machine,
        'section': _section,
        'title': _titleController.text.trim(),
        'desc': _descController.text.trim().isEmpty ? 'No description' : _descController.text.trim(),
        'status': 'Open',
        'priority': _priority,
        'reportedBy': 'Tariqul Islam',
        'time': 'Just now',
        'downtimeMin': 0,
      });
      _titleController.clear();
      _descController.clear();
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Breakdown Report করা হয়েছে - Admin কে Alert গেছে')));
  }

  void _showReportSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16, left: 16, right: 16, top: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Report Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: KormiColors.navy)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _dropdown('Machine', _machine, ['C/D', 'B/D', 'F/D', 'S/F', 'R/F', 'L/C', 'AUTOCONE', 'PACKING'], (v) => setState(() => _machine = v!))),
                  const SizedBox(width: 10),
                  Expanded(child: _dropdown('Section', _section, ['BACKSIDE', 'RING', 'AUTOCONE', 'PACKING'], (v) => setState(() => _section = v!))),
                ],
              ),
              const SizedBox(height: 12),
              _dropdown('Priority', _priority, ['High', 'Medium', 'Low'], (v) => setState(() => _priority = v!)),
              const SizedBox(height: 12),
              TextField(controller: _titleController, decoration: _input('Breakdown Title - e.g. Belt Slip')),
              const SizedBox(height: 10),
              TextField(controller: _descController, maxLines: 3, decoration: _input('Description (optional)')),
              const SizedBox(height: 14),
              KormiPrimaryButton(label: 'Submit Breakdown Report', onPressed: _reportBreakdown),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Breakdown'),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: _showReportSheet),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        onPressed: _showReportSheet,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _summary('Open', '$_openCount', KormiColors.red)),
                const SizedBox(width: 8),
                Expanded(child: _summary('In Progress', '$_progressCount', KormiColors.gold)),
                const SizedBox(width: 8),
                Expanded(child: _summary('Fixed', '$_fixedCount', KormiColors.green)),
                const SizedBox(width: 8),
                Expanded(child: _summary('Downtime', '${_totalDowntime}m', KormiColors.navy)),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Open', 'In Progress', 'Fixed'].map((f) {
                  final active = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: active ? KormiColors.navy : Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: KormiColors.border)),
                        child: Text(f, style: TextStyle(color: active ? KormiColors.goldLight : KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            ..._filtered.map((item) {
              final idx = _items.indexOf(item);
              final status = item['status'] as String;
              final priority = item['priority'] as String;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: KormiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: KormiColors.navy, borderRadius: BorderRadius.circular(20)), child: Text(item['id'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 15))),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: priority == 'High' ? KormiColors.red.withOpacity(0.10) : priority == 'Medium' ? KormiColors.gold.withOpacity(0.15) : KormiColors.green.withOpacity(0.10), borderRadius: BorderRadius.circular(20)), child: Text(priority, style: TextStyle(color: priority == 'High' ? KormiColors.red : priority == 'Medium' ? KormiColors.navy : KormiColors.green, fontWeight: FontWeight.bold, fontSize: 11))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(item['desc'], style: const TextStyle(color: KormiColors.textGrey, fontSize: 13)),
                      const SizedBox(height: 6),
                      Text('Machine: ${item['machine']} • Section: ${item['section']}', style: const TextStyle(color: KormiColors.navy, fontSize: 12, fontWeight: FontWeight.bold)),
                      Text('Reported by ${item['reportedBy']} • ${item['time']} • Downtime: ${item['downtimeMin']} min', style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: status == 'Fixed' ? KormiColors.green.withOpacity(0.12) : status == 'In Progress' ? KormiColors.gold.withOpacity(0.15) : KormiColors.red.withOpacity(0.10), borderRadius: BorderRadius.circular(20)),
                              child: Center(child: Text(status, style: TextStyle(color: status == 'Fixed' ? KormiColors.green : status == 'In Progress' ? KormiColors.navy : KormiColors.red, fontWeight: FontWeight.bold, fontSize: 12))),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (status != 'Fixed')
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _changeStatus(idx, status == 'Open' ? 'In Progress' : 'Fixed'),
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: KormiColors.navy), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                child: Text(status == 'Open' ? 'Start Work' : 'Mark Fixed', style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ),
                          if (status == 'Fixed')
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _changeStatus(idx, 'Open'),
                                style: OutlinedButton.styleFrom(side: const BorderSide(color: KormiColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                child: const Text('Reopen', style: TextStyle(color: KormiColors.textGrey, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            const Text('Breakdown Report করলে Admin / Management সঙ্গে সঙ্গে দেখতে পারবে।', textAlign: TextAlign.center, style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _summary(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: KormiColors.border)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
          Text(label, style: const TextStyle(color: KormiColors.textGrey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: KormiColors.border)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(value: value, isExpanded: true, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged),
          ),
        ),
      ],
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
}
