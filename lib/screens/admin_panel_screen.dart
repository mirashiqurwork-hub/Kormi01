// KORMI - Admin Panel Screen - REAL ACTION
// Pending Approval + User Management + Approve / Reject - সব Real

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _tab = 0;
  String _filter = 'All';

  final List<Map<String, String>> _pending = [
    {'card': 'K-1046', 'name': 'Mizanur Rahman', 'role': 'Worker - Helper', 'section': 'AUTOCONE', 'shift': 'P/B-R/C', 'phone': '01811-567890', 'date': '18.11.26', 'type': 'Registration'},
    {'card': 'K-1048', 'name': 'Shafiqul Islam', 'role': 'Worker - OP', 'section': 'RING', 'shift': 'P/A', 'phone': '01811-789012', 'date': '18.11.26', 'type': 'Registration'},
    {'card': 'K-1043', 'name': 'Nasir Ahmed', 'role': 'Officer - Production', 'section': 'BACKSIDE', 'shift': 'P/A', 'phone': '01811-345678', 'date': '17.11.26', 'type': 'Role Change'},
  ];

  final List<Map<String, String>> _users = [
    {'card': 'ADMIN', 'name': 'Tariqul Islam', 'role': 'CHIEF MILL ADMINISTRATOR', 'section': 'ALL SECTION', 'status': 'Active'},
    {'card': 'K-1041', 'name': 'Rahim Uddin', 'role': 'Shift Incharge', 'section': 'RING', 'status': 'Active'},
    {'card': 'K-1042', 'name': 'Karim Sheikh', 'role': 'Worker - OP', 'section': 'RING', 'status': 'Active'},
    {'card': 'K-1043', 'name': 'Nasir Ahmed', 'role': 'Officer - Production', 'section': 'BACKSIDE', 'status': 'Active'},
    {'card': 'K-1045', 'name': 'Jashim Uddin', 'role': 'Worker - Packing', 'section': 'PACKING', 'status': 'Active'},
  ];

  final List<Map<String, String>> _audit = [
    {'action': 'Approved K-1046 Registration', 'by': 'Tariqul Islam', 'time': 'Today 08:20 AM'},
    {'action': 'OT Approved - K-1045', 'by': 'Tariqul Islam', 'time': 'Today 08:05 AM'},
    {'action': 'Breakdown BD-101 Fixed', 'by': 'Rahim Uddin', 'time': 'Yesterday 06:30 PM'},
  ];

  void _approve(int idx) {
    final item = _pending[idx];
    setState(() {
      _pending.removeAt(idx);
      _users.insert(0, {'card': item['card']!, 'name': item['name']!, 'role': item['role']!, 'section': item['section']!, 'status': 'Active'});
      _audit.insert(0, {'action': 'Approved ${item['card']} - ${item['name']}', 'by': 'Tariqul Islam', 'time': 'Just now'});
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['name']} Approved - এখন Login করতে পারবে')));
  }

  void _reject(int idx) {
    final item = _pending[idx];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reject?'),
        content: Text('${item['name']} (${item['card']}) কে Reject করবেন?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() {
                _pending.removeAt(idx);
                _audit.insert(0, {'action': 'Rejected ${item['card']} - ${item['name']}', 'by': 'Tariqul Islam', 'time': 'Just now'});
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['name']} Rejected')));
            },
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _approveAll() {
    if (_pending.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('কোনো Pending নাই')));
      return;
    }
    setState(() {
      for (final p in _pending) {
        _users.add({'card': p['card']!, 'name': p['name']!, 'role': p['role']!, 'section': p['section']!, 'status': 'Active'});
        _audit.insert(0, {'action': 'Approved ${p['card']} - ${p['name']}', 'by': 'Tariqul Islam', 'time': 'Just now'});
      }
      _pending.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('সব Pending Approved')));
  }

  void _toggleUserStatus(int idx) {
    setState(() {
      _users[idx]['status'] = _users[idx]['status'] == 'Active' ? 'Inactive' : 'Active';
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_users[idx]['name']} - ${_users[idx]['status']}')));
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _filter == 'All' ? _users : _users.where((u) => u['status'] == _filter).toList();

    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(backgroundColor: KormiColors.navy, foregroundColor: KormiColors.goldLight, title: const Text('Admin Panel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: KormiColors.border)),
              child: Row(
                children: [
                  _tabBtn('Pending', 0, _pending.length),
                  _tabBtn('Users', 1, _users.length),
                  _tabBtn('Audit Log', 2, _audit.length),
                ],
              ),
            ),
            const SizedBox(height: 14),

            if (_tab == 0) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: KormiColors.navy, borderRadius: BorderRadius.circular(20), border: Border.all(color: KormiColors.gold.withOpacity(0.3))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_pending.length} Pending Approval', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        const Text('Approve করলে Login করতে পারবে', style: TextStyle(color: KormiColors.goldLight, fontSize: 12)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _approveAll,
                      style: ElevatedButton.styleFrom(backgroundColor: KormiColors.gold, foregroundColor: KormiColors.navy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      child: const Text('Approve All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (_pending.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text('কোনো Pending Approval নাই 🎉', style: TextStyle(color: KormiColors.textGrey)),
                ),
              ..._pending.map((p) {
                final idx = _pending.indexOf(p);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: KormiCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(backgroundColor: KormiColors.navy.withOpacity(0.1), child: Text(p['name']![0], style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold))),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${p['name']} • ${p['card']}', style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 15)),
                                  Text('${p['role']} • ${p['section']} • ${p['shift']}', style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                                  Text('${p['phone']} • ${p['type']} • ${p['date']}', style: const TextStyle(color: KormiColors.navy, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: ElevatedButton(onPressed: () => _approve(idx), style: ElevatedButton.styleFrom(backgroundColor: KormiColors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text('Approve', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)))),
                            const SizedBox(width: 8),
                            Expanded(child: OutlinedButton(onPressed: () => _reject(idx), style: OutlinedButton.styleFrom(side: const BorderSide(color: KormiColors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text('Reject', style: TextStyle(color: KormiColors.red, fontWeight: FontWeight.bold, fontSize: 13)))),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],

            if (_tab == 1) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Active', 'Inactive'].map((f) {
                    final active = _filter == f;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: active ? KormiColors.navy : Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: KormiColors.border)), child: Text(f, style: TextStyle(color: active ? KormiColors.goldLight : KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 12))),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              ...filteredUsers.map((u) {
                final idx = _users.indexOf(u);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: KormiCard(
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: KormiColors.navy.withOpacity(0.1), child: Text(u['name']![0], style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${u['name']} • ${u['card']}', style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 14)),
                              Text('${u['role']} • ${u['section']}', style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleUserStatus(idx),
                          child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: u['status'] == 'Active' ? KormiColors.green.withOpacity(0.12) : KormiColors.red.withOpacity(0.10), borderRadius: BorderRadius.circular(20)), child: Text(u['status']!, style: TextStyle(color: u['status'] == 'Active' ? KormiColors.green : KormiColors.red, fontWeight: FontWeight.bold, fontSize: 11))),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              const Text('Status এ চাপ দিলে Active / Inactive হবে। Inactive হলে Login করতে পারবে না।', textAlign: TextAlign.center, style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
            ],

            if (_tab == 2) ...[
              ..._audit.map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: KormiCard(
                      child: Row(
                        children: [
                          const CircleAvatar(backgroundColor: KormiColors.navy, child: Icon(Icons.history_outlined, color: KormiColors.goldLight, size: 18)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a['action']!, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 13)),
                                Text('By ${a['by']} • ${a['time']}', style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 8),
              KormiPrimaryButton(
                label: 'Clear Audit Log',
                onPressed: () {
                  setState(() => _audit.clear());
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Audit Log Clear করা হয়েছে')));
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tabBtn(String label, int index, int count) {
    final active = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: active ? KormiColors.navy : Colors.transparent, borderRadius: BorderRadius.circular(30)),
          child: Center(child: Text('$label ($count)', style: TextStyle(color: active ? KormiColors.goldLight : KormiColors.textGrey, fontWeight: FontWeight.bold, fontSize: 12))),
        ),
      ),
    );
  }
}
