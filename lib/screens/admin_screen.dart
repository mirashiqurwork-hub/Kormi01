// KORMI - Admin Screen
// Admin Panel: Shifts / Access / Mills / Backup / Audit / Companies
// শুধু ADMIN / Management দেখতে পারবে

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _tab = 0;

  // Access - Pending Approvals
  final List<Map<String, dynamic>> _pending = [
    {'name': 'Karim Sheikh', 'card': 'K-1042', 'role': 'Worker', 'company': 'Mill 1 - Kumira', 'approved': false},
    {'name': 'Nasir Ahmed', 'card': 'K-1043', 'role': 'Officer', 'company': 'Mill 1 - Kumira', 'approved': false},
  ];

  // Mills
  final List<Map<String, String>> _mills = [
    {'name': 'Mill 1 - Kumira', 'workers': '124', 'status': 'Active'},
    {'name': 'Mill 2 - Sitakunda', 'workers': '86', 'status': 'Active'},
    {'name': 'Mill 3 - Bhatiary', 'workers': '42', 'status': 'Active'},
  ];

  // Shifts
  final List<Map<String, String>> _shifts = [
    {'name': 'P/A', 'time': '06:00 AM - 02:00 PM', 'workers': '48'},
    {'name': 'P/B', 'time': '02:00 PM - 10:00 PM', 'workers': '52'},
    {'name': 'P/C', 'time': '10:00 PM - 06:00 AM', 'workers': '44'},
    {'name': 'P/B-R/C', 'time': '02:00 PM - 06:00 AM', 'workers': '18'},
  ];

  // Audit Log
  final List<Map<String, String>> _audit = [
    {'action': 'Approved Worker K-1042', 'by': 'ADMIN', 'time': '10:42 AM'},
    {'action': 'Added New Company - Mill 3', 'by': 'ADMIN', 'time': '09:15 AM'},
    {'action': 'Breakdown Logged RF-14', 'by': 'Tariqul Islam', 'time': '08:30 AM'},
    {'action': 'Production Saved Unit 1', 'by': 'Rahim Uddin', 'time': 'Yesterday'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Admin Panel'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: KormiColors.border),
              ),
              child: Row(
                children: [
                  _tabBtn('Access', 0),
                  _tabBtn('Shifts', 1),
                  _tabBtn('Mills', 2),
                  _tabBtn('Audit', 3),
                ],
              ),
            ),
            const SizedBox(height: 14),

            if (_tab == 0) ...[
              // Pending Approvals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pending Approvals (${_pending.length})',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 17)),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All Pending Approved')),
                      );
                    },
                    child: const Text('Approve All', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._pending.map((p) {
                final approved = p['approved'] as bool;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: KormiCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 15)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: approved ? KormiColors.green.withOpacity(0.12) : KormiColors.gold.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(approved ? 'Approved' : 'Pending',
                                  style: TextStyle(
                                      color: approved ? KormiColors.green : KormiColors.gold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Card: ${p['card']} • Role: ${p['role']} • ${p['company']}',
                            style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: approved
                                    ? null
                                    : () {
                                        setState(() => p['approved'] = true);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('${p['name']} Approved')),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: KormiColors.navy,
                                  foregroundColor: KormiColors.goldLight,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                                child: Text(approved ? 'Approved' : 'Approve',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() => _pending.remove(p));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${p['name']} Rejected')),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: KormiColors.border),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                                child: const Text('Reject', style: TextStyle(color: KormiColors.red, fontWeight: FontWeight.bold)),
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
              // Company Management
              KormiCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Companies', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 16)),
                    const SizedBox(height: 10),
                    ..._mills.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(m['name']!, style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                              Text('${m['workers']} Workers', style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                            ],
                          ),
                        )),
                    const SizedBox(height: 10),
                    KormiPrimaryButton(
                      label: '+ Add New Company',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Add Company - শুধু Admin করতে পারবে')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],

            if (_tab == 1) ...[
              const Text('Shift Management', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 17)),
              const SizedBox(height: 10),
              ..._shifts.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: KormiCard(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(color: KormiColors.navy, borderRadius: BorderRadius.circular(12)),
                            child: Text(s['name']!, style: const TextStyle(color: KormiColors.goldLight, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s['time']!, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                                Text('${s['workers']} Workers', style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.edit_outlined, color: KormiColors.textGrey, size: 20),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 8),
              KormiPrimaryButton(
                label: '+ Add New Shift',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add Shift - Admin Only')),
                  );
                },
              ),
            ],

            if (_tab == 2) ...[
              const Text('Mills / Companies', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 17)),
              const SizedBox(height: 10),
              ..._mills.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: KormiCard(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: KormiColors.navy.withOpacity(0.1),
                            child: const Icon(Icons.factory_outlined, color: KormiColors.navy),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy)),
                                Text('${m['workers']} Workers • ${m['status']}',
                                    style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: KormiColors.textGrey),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 8),
              KormiCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Backup & Data', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 16)),
                    const SizedBox(height: 10),
                    const Text('ডাটা ফোনে থাকে, Logout করলেও মুছবে না। শুধু Lock হবে।',
                        style: TextStyle(color: KormiColors.textGrey, fontSize: 13)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _backupBtn('Backup Now', Icons.backup_outlined)),
                        const SizedBox(width: 8),
                        Expanded(child: _backupBtn('Restore', Icons.restore_outlined)),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            if (_tab == 3) ...[
              const Text('Audit Log', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 17)),
              const SizedBox(height: 10),
              ..._audit.map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: KormiCard(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: KormiColors.navy.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.history_outlined, color: KormiColors.navy, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a['action']!, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 14)),
                                Text('By ${a['by']} • ${a['time']}', style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 8),
              const Text('সব Action Audit Log-এ Save থাকে। কে কী করলো Admin দেখতে পারবে।',
                  textAlign: TextAlign.center, style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
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
            child: Text(label,
                style: TextStyle(
                    color: active ? KormiColors.goldLight : KormiColors.textGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
        ),
      ),
    );
  }

  Widget _backupBtn(String label, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label - Backup তৈরি হচ্ছে...')));
      },
      icon: Icon(icon, size: 18, color: KormiColors.navy),
      label: Text(label, style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 13)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: KormiColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 11),
      ),
    );
  }
}
