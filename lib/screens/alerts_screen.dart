// KORMI - Alerts Screen
// Breakdown / Manpower / Approval / Production Alerts

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _filter = 'All';

  final List<Map<String, dynamic>> _alerts = [
    {
      'title': 'Breakdown - RF-14',
      'desc': 'Ring Frame RF-14 - 45 min down, Main drive belt slip',
      'time': '10:42 AM • Today',
      'type': 'Breakdown',
      'icon': Icons.warning_amber_rounded,
      'color': KormiColors.red,
      'unread': true,
    },
    {
      'title': 'Pending Approval - 2 Workers',
      'desc': 'Karim Sheikh (K-1042) ar Nasir Ahmed (K-1043) approval er jonno wait kortese',
      'time': '09:15 AM • Today',
      'type': 'Approval',
      'icon': Icons.person_add_outlined,
      'color': KormiColors.gold,
      'unread': true,
    },
    {
      'title': 'Manpower Short - RING Section',
      'desc': 'RING - Required 48, Present 46, Absent 2 (P/B Shift)',
      'time': '08:30 AM • Today',
      'type': 'Manpower',
      'icon': Icons.groups_outlined,
      'color': KormiColors.navy,
      'unread': true,
    },
    {
      'title': 'Production Saved - Unit 1',
      'desc': 'Unit 1 Total 39,353 kg saved, Share Format ready',
      'time': 'Yesterday • 06:20 PM',
      'type': 'Production',
      'icon': Icons.factory_outlined,
      'color': KormiColors.green,
      'unread': false,
    },
    {
      'title': 'Breakdown Resolved - CD-04',
      'desc': 'Carding CD-04 resolved, 25 min down chilo',
      'time': 'Yesterday • 04:10 PM',
      'type': 'Breakdown',
      'icon': Icons.check_circle_outlined,
      'color': KormiColors.green,
      'unread': false,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'All') return _alerts;
    if (_filter == 'Unread') return _alerts.where((e) => e['unread'] == true).toList();
    return _alerts.where((e) => e['type'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _alerts.where((e) => e['unread'] == true).length;

    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Alerts'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (final a in _alerts) {
                  a['unread'] = false;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All Alerts Mark as Read')),
              );
            },
            child: const Text('Mark All Read', style: TextStyle(color: KormiColors.goldLight, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary
          Padding(
            padding: const EdgeInsets.all(14),
            child: KormiCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem('Total', '${_alerts.length}', KormiColors.navy),
                  _summaryItem('Unread', '$unreadCount', KormiColors.red),
                  _summaryItem('Today', '3', KormiColors.green),
                ],
              ),
            ),
          ),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: ['All', 'Unread', 'Breakdown', 'Manpower', 'Approval', 'Production'].map((f) {
                final active = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? KormiColors.navy : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: KormiColors.border),
                      ),
                      child: Text(f,
                          style: TextStyle(
                              color: active ? KormiColors.goldLight : KormiColors.navy,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('Kono Alert nai', style: TextStyle(color: KormiColors.textGrey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final a = _filtered[index];
                      final unread = a['unread'] as bool;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: KormiCard(
                          onTap: () {
                            setState(() => a['unread'] = false);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  color: (a['color'] as Color).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(a['icon'] as IconData, color: a['color'] as Color, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(a['title'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: KormiColors.navy,
                                                  fontSize: 14,
                                                  decoration: TextDecoration.none)),
                                        ),
                                        if (unread)
                                          Container(
                                            width: 9,
                                            height: 9,
                                            decoration: const BoxDecoration(color: KormiColors.red, shape: BoxShape.circle),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(a['desc'], style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(a['time'], style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
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
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 22)),
        Text(label, style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
      ],
    );
  }
}
