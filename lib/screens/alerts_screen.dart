// KORMI - Alerts Screen - REAL ACTION
// Alert Read / Delete / Filter - সব Real

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
    {'title': 'Breakdown Reported - R/F', 'desc': 'Ring Frame 12 - Belt slip, Production কমে গেছে', 'time': '08:15 AM', 'type': 'Breakdown', 'isRead': false, 'priority': 'High'},
    {'title': 'Manpower Shortage - PACKING', 'desc': 'PACKING এ 2 জন Short - Required 24, Present 22', 'time': '08:00 AM', 'type': 'Manpower', 'isRead': false, 'priority': 'Medium'},
    {'title': 'New Registration Pending', 'desc': 'Mizanur Rahman (K-1046) Approval এর জন্য অপেক্ষা করছে', 'time': '07:45 AM', 'type': 'Approval', 'isRead': false, 'priority': 'High'},
    {'title': 'OT Request Pending', 'desc': 'Karim Sheikh - 2h OT Approval বাকি', 'time': 'Yesterday', 'type': 'OT', 'isRead': true, 'priority': 'Medium'},
    {'title': 'Production Target Achieved', 'desc': 'Unit 1 - আজকের Target 95% Complete', 'time': 'Yesterday', 'type': 'Production', 'isRead': true, 'priority': 'Low'},
    {'title': 'Worker Outside Mill', 'desc': 'Karim Sheikh Mill এর বাইরে আছে', 'time': 'Yesterday', 'type': 'Location', 'isRead': true, 'priority': 'Medium'},
  ];

  List<Map<String, dynamic>> get _filtered {
    var list = _alerts;
    if (_filter == 'Unread') list = list.where((e) => e['isRead'] == false).toList();
    if (_filter == 'Read') list = list.where((e) => e['isRead'] == true).toList();
    if (_filter == 'High') list = list.where((e) => e['priority'] == 'High').toList();
    return list;
  }

  int get _unreadCount => _alerts.where((e) => e['isRead'] == false).length;

  void _markRead(int idx) {
    setState(() => _alerts[idx]['isRead'] = true);
  }

  void _markAllRead() {
    setState(() {
      for (final a in _alerts) a['isRead'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('সব Alert Read করা হয়েছে')));
  }

  void _deleteAlert(int idx) {
    final item = _alerts[idx];
    setState(() => _alerts.removeAt(idx));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['title']} Deleted'), action: SnackBarAction(label: 'Undo', onPressed: () => setState(() => _alerts.insert(idx, item)))));
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear All Alerts?'),
        content: const Text('সব Alert মুছে যাবে।'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () { setState(() => _alerts.clear()); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('সব Alert Clear করা হয়েছে'))); }, child: const Text('Clear', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  IconData _iconFor(String type) {
    if (type == 'Breakdown') return Icons.build_outlined;
    if (type == 'Manpower') return Icons.groups_outlined;
    if (type == 'Approval') return Icons.person_add_outlined;
    if (type == 'OT') return Icons.schedule_outlined;
    if (type == 'Production') return Icons.factory_outlined;
    if (type == 'Location') return Icons.location_on_outlined;
    return Icons.notifications_outlined;
  }

  Color _colorFor(String priority) {
    if (priority == 'High') return KormiColors.red;
    if (priority == 'Medium') return KormiColors.gold;
    return KormiColors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Alerts'),
        actions: [
          TextButton(onPressed: _markAllRead, child: const Text('Mark All Read', style: TextStyle(color: KormiColors.goldLight, fontWeight: FontWeight.bold, fontSize: 12))),
          IconButton(icon: const Icon(Icons.delete_sweep_outlined), onPressed: _clearAll),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: KormiColors.navy, borderRadius: BorderRadius.circular(16), border: Border.all(color: KormiColors.gold.withOpacity(0.3))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$_unreadCount Unread Alerts', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Total: ${_alerts.length}', style: const TextStyle(color: KormiColors.goldLight, fontSize: 13)),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: ['All', 'Unread', 'Read', 'High'].map((f) {
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
          const SizedBox(height: 10),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('কোনো Alert নাই', style: TextStyle(color: KormiColors.textGrey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) {
                      final a = _filtered[i];
                      final idx = _alerts.indexOf(a);
                      final isRead = a['isRead'] as bool;
                      return Dismissible(
                        key: ValueKey(a['title'] + a['time']),
                        direction: DismissDirection.endToStart,
                        background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), decoration: BoxDecoration(color: KormiColors.red, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.delete_outline, color: Colors.white)),
                        onDismissed: (_) => _deleteAlert(idx),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: KormiCard(
                            onTap: () => _markRead(idx),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(backgroundColor: _colorFor(a['priority']).withOpacity(0.12), child: Icon(_iconFor(a['type']), color: _colorFor(a['priority']), size: 20)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: Text(a['title'], style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 14, decoration: isRead ? null : TextDecoration.none))),
                                          if (!isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: KormiColors.red, shape: BoxShape.circle)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(a['desc'], style: TextStyle(color: isRead ? KormiColors.textGrey : KormiColors.navy, fontSize: 12)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text('${a['type']} • ${a['time']}', style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                                          const SizedBox(width: 8),
                                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: _colorFor(a['priority']).withOpacity(0.12), borderRadius: BorderRadius.circular(20)), child: Text(a['priority'], style: TextStyle(color: _colorFor(a['priority']), fontWeight: FontWeight.bold, fontSize: 10))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const Padding(
            padding: EdgeInsets.all(14),
            child: Text('Alert ডানে Swipe করলে Delete হবে। Alert এ চাপ দিলে Read হবে।', textAlign: TextAlign.center, style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
