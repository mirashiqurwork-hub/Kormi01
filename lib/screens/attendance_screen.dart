// KORMI - Attendance Screen - REAL ACTION
// Check-In / Check-Out + Present / Absent / Late + Real Summary

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _date = '18.11.26';
  String _shift = 'P/B-R/C';
  String _filter = 'All';
  final _searchController = TextEditingController();

  // Real Attendance State - Card -> Status
  // Status: Present / Absent / Late / Leave / Not Marked
  final Map<String, String> _status = {
    'K-1041': 'Present',
    'K-1042': 'Present',
    'K-1043': 'Late',
    'K-1045': 'Absent',
  };

  final Map<String, String> _checkIn = {
    'K-1041': '08:02 AM',
    'K-1042': '08:00 AM',
    'K-1043': '08:35 AM',
  };

  final List<Map<String, String>> _workers = [
    {'card': 'K-1041', 'name': 'Rahim Uddin', 'role': 'Shift Incharge - P/B', 'section': 'RING'},
    {'card': 'K-1042', 'name': 'Karim Sheikh', 'role': 'Worker - Ring', 'section': 'RING'},
    {'card': 'K-1043', 'name': 'Nasir Ahmed', 'role': 'Officer - Production', 'section': 'BACKSIDE'},
    {'card': 'K-1045', 'name': 'Jashim Uddin', 'role': 'Worker - Packing', 'section': 'PACKING'},
    {'card': 'K-1046', 'name': 'Mizanur Rahman', 'role': 'Helper - Autocone', 'section': 'AUTOCONE'},
    {'card': 'K-1047', 'name': 'Abdul Kader', 'role': 'OP - Ring', 'section': 'RING'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _statusOf(String card) => _status[card] ?? 'Not Marked';

  int get _present => _workers.where((w) => _statusOf(w['card']!) == 'Present' || _statusOf(w['card']!) == 'Late').length;
  int get _absent => _workers.where((w) => _statusOf(w['card']!) == 'Absent').length;
  int get _late => _workers.where((w) => _statusOf(w['card']!) == 'Late').length;
  int get _notMarked => _workers.where((w) => _statusOf(w['card']!) == 'Not Marked').length;

  List<Map<String, String>> get _filtered {
    var list = _workers;
    if (_filter == 'Present') list = list.where((w) => _statusOf(w['card']!) == 'Present').toList();
    if (_filter == 'Late') list = list.where((w) => _statusOf(w['card']!) == 'Late').toList();
    if (_filter == 'Absent') list = list.where((w) => _statusOf(w['card']!) == 'Absent').toList();
    if (_filter == 'Not Marked') list = list.where((w) => _statusOf(w['card']!) == 'Not Marked').toList();
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((w) => w['name']!.toLowerCase().contains(q) || w['card']!.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  void _mark(String card, String status) {
    setState(() {
      _status[card] = status;
      if (status == 'Present' && !_checkIn.containsKey(card)) {
        _checkIn[card] = '08:00 AM';
      }
      if (status == 'Late' && !_checkIn.containsKey(card)) {
        _checkIn[card] = '08:35 AM';
      }
      if (status == 'Absent') {
        _checkIn.remove(card);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$card - $status')));
  }

  void _markAllPresent() {
    setState(() {
      for (final w in _workers) {
        if (_statusOf(w['card']!) == 'Not Marked') {
          _status[w['card']!] = 'Present';
          _checkIn[w['card']!] = '08:00 AM';
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('সব Not Marked কে Present করা হয়েছে')));
  }

  void _showMarkSheet(String card, String name) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: KormiColors.navy)),
            Text('Card: $card • Shift: $_shift', style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
            const SizedBox(height: 12),
            ...['Present', 'Late', 'Absent', 'Leave'].map((s) => ListTile(
                  leading: Icon(s == 'Present' ? Icons.check_circle_outline : s == 'Late' ? Icons.schedule_outlined : s == 'Absent' ? Icons.cancel_outlined : Icons.event_busy_outlined, color: KormiColors.navy),
                  title: Text(s),
                  onTap: () {
                    Navigator.pop(context);
                    _mark(card, s);
                  },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String s) {
    if (s == 'Present') return KormiColors.green;
    if (s == 'Late') return KormiColors.gold;
    if (s == 'Absent') return KormiColors.red;
    if (s == 'Leave') return KormiColors.textGrey;
    return KormiColors.textGrey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Attendance'),
        actions: [
          IconButton(icon: const Icon(Icons.done_all_outlined), onPressed: _markAllPresent),
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
                        value: _shift,
                        isExpanded: true,
                        items: ['P/A', 'P/B', 'P/B-R/C', 'P/C'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => setState(() => _shift = v!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: KormiColors.border)),
                  child: Text(_date, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Summary - Real Count
            Row(
              children: [
                Expanded(child: _summaryCard('Present', '$_present', KormiColors.green)),
                const SizedBox(width: 8),
                Expanded(child: _summaryCard('Absent', '$_absent', KormiColors.red)),
                const SizedBox(width: 8),
                Expanded(child: _summaryCard('Late', '$_late', KormiColors.gold)),
                const SizedBox(width: 8),
                Expanded(child: _summaryCard('Pending', '$_notMarked', KormiColors.textGrey)),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by Name / Card...',
                prefixIcon: const Icon(Icons.search_outlined, color: KormiColors.textGrey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: KormiColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: KormiColors.border)),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Present', 'Late', 'Absent', 'Not Marked'].map((f) {
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
            ..._filtered.map((w) {
              final card = w['card']!;
              final status = _statusOf(card);
              final checkIn = _checkIn[card] ?? '--:--';
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: KormiCard(
                  onTap: () => _showMarkSheet(card, w['name']!),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: KormiColors.navy.withOpacity(0.1), child: Text(w['name']![0], style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${w['name']} • $card', style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 14)),
                            Text('${w['role']} • ${w['section']}', style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                            Text('Check-In: $checkIn', style: const TextStyle(color: KormiColors.navy, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: _statusColor(status).withOpacity(0.12), borderRadius: BorderRadius.circular(20)), child: Text(status, style: TextStyle(color: _statusColor(status), fontWeight: FontWeight.bold, fontSize: 11))),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _quickBtn('P', () => _mark(card, 'Present'), KormiColors.green),
                              const SizedBox(width: 4),
                              _quickBtn('A', () => _mark(card, 'Absent'), KormiColors.red),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            KormiPrimaryButton(
              label: 'Save Attendance - $_shift • $_date',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved - Present: $_present, Absent: $_absent, Late: $_late, Pending: $_notMarked')));
              },
            ),
            const SizedBox(height: 8),
            const Text('Present + Late = Working, Absent = Salary থেকে কাটবে।', textAlign: TextAlign.center, style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: KormiColors.border)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 18)),
          Text(label, style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _quickBtn(String label, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
      ),
    );
  }
}
