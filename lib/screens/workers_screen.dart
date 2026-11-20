// KORMI - Workers Screen - File 6
// ড্যাশবোর্ড -> Workers কার্ডে চাপ দিলে এই পেজ খুলবে
// লিস্ট + সার্চ + Add Worker (Admin Add User)

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';
import 'register_screen.dart';

class WorkersScreen extends StatefulWidget {
  const WorkersScreen({super.key});

  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
  String _search = '';
  String _filter = 'All';

  // ডেমো ডাটা - পরে আসল ডাটাবেজ থেকে আসবে
  final List<Map<String, String>> _allWorkers = [
    {'name': 'Tariqul Islam', 'id': 'ADMIN', 'role': 'Admin', 'desg': 'Admin', 'shift': 'P/B-R/C', 'section': 'ALL SECTION', 'unit': 'UNIT-01', 'status': 'Active'},
    {'name': 'Engr. Mahmudul Hasan', 'id': 'MGT-01', 'role': 'Management', 'desg': 'PM', 'shift': '-', 'section': '-', 'unit': 'ALL UNIT', 'status': 'Active'},
    {'name': 'Sajjad Hossain', 'id': 'OFF-12', 'role': 'Officer', 'desg': 'PO', 'shift': 'P/B', 'section': 'RING', 'unit': 'UNIT-01', 'status': 'Active'},
    {'name': 'Md. Rahim Mia', 'id': 'W-104', 'role': 'Worker', 'desg': 'OP', 'shift': 'P/A', 'section': 'RING', 'unit': 'UNIT-01', 'status': 'Active'},
    {'name': 'Fatema Begum', 'id': 'W-105', 'role': 'Worker', 'desg': 'HELPER', 'shift': 'P/B', 'section': 'PACKING', 'unit': 'UNIT-01', 'status': 'Active'},
    {'name': 'Rashedul Karim', 'id': 'W-106', 'role': 'Worker', 'desg': 'JR.A.OP', 'shift': 'P/C', 'section': 'BACKSIDE', 'unit': 'UNIT-02', 'status': 'Pending'},
    {'name': 'Farhana Yasmin', 'id': 'OFF-19', 'role': 'Officer', 'desg': 'APO', 'shift': 'P/A', 'section': 'ALL SECTION', 'unit': 'UNIT-02', 'status': 'Pending'},
    {'name': 'Kamrul Hasan', 'id': 'W-107', 'role': 'Worker', 'desg': 'SR.HELPER', 'shift': 'P/B', 'section': 'AUTOCONE', 'unit': 'G/F', 'status': 'Active'},
    {'name': 'Nasrin Akter', 'id': 'W-108', 'role': 'Worker', 'desg': 'LINE-MAN', 'shift': 'P/A', 'section': 'RING', 'unit': 'F/F', 'status': 'Active'},
  ];

  List<Map<String, String>> get _filtered {
    return _allWorkers.where((w) {
      final matchSearch = _search.isEmpty ||
          w['name']!.toLowerCase().contains(_search.toLowerCase()) ||
          w['id']!.toLowerCase().contains(_search.toLowerCase());
      final matchFilter = _filter == 'All' || w['role'] == _filter;
      return matchSearch && matchFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Workers'),
      ),
      body: Column(
        children: [
          // সার্চ
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search Name / Card ID',
                prefixIcon: const Icon(Icons.search, color: KormiColors.textGrey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: KormiColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: KormiColors.border),
                ),
              ),
            ),
          ),
          // ফিল্টার চিপ
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: ['All', 'Worker', 'Officer', 'Management', 'Admin'].map((f) {
                final active = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: active,
                    selectedColor: KormiColors.navy,
                    labelStyle: TextStyle(
                      color: active ? KormiColors.goldLight : KormiColors.navy,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Colors.white,
                    onSelected: (_) => setState(() => _filter = f),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          // লিস্ট
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final w = _filtered[i];
                final isPending = w['status'] == 'Pending';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: KormiCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: KormiColors.navy,
                          child: Text(
                            w['name']!.substring(0, 1),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      w['name']!,
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isPending ? Colors.orange.withOpacity(0.15) : KormiColors.green.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      w['status']!,
                                      style: TextStyle(
                                        color: isPending ? Colors.orange : KormiColors.green,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${w['id']} • ${w['role']} • ${w['desg']}',
                                style: const TextStyle(color: KormiColors.textGrey, fontSize: 12),
                              ),
                              Text(
                                'Shift ${w['shift']} • ${w['section']} • ${w['unit']}',
                                style: const TextStyle(color: KormiColors.textGrey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Add Worker - Admin Add User
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Worker', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
