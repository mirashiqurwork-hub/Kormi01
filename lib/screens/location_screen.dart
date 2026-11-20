// KORMI - Location Screen
// Live Location + Worker Location + Mill Location

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _filter = 'All';
  String _selectedMill = 'All Mills';

  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Tariqul Islam',
      'role': 'CHIEF MILL ADMINISTRATOR',
      'place': 'Unit 1 • Ring Section',
      'time': '2 min ago',
      'status': 'Inside Mill',
      'color': KormiColors.green,
    },
    {
      'name': 'Rahim Uddin',
      'role': 'Shift Incharge - P/B',
      'place': 'Unit 1 • Carding',
      'time': '5 min ago',
      'status': 'Inside Mill',
      'color': KormiColors.green,
    },
    {
      'name': 'Karim Sheikh',
      'role': 'Worker - Ring',
      'place': 'Unit 2 • Ring Section',
      'time': '12 min ago',
      'status': 'Inside Mill',
      'color': KormiColors.green,
    },
    {
      'name': 'Nasir Ahmed',
      'role': 'Officer - Production',
      'place': 'Outside • Kumira Bazar',
      'time': '28 min ago',
      'status': 'Outside',
      'color': KormiColors.red,
    },
    {
      'name': 'Jashim Uddin',
      'role': 'Worker - Packing',
      'place': 'Unit 1 • Packing',
      'time': '1 min ago',
      'status': 'Inside Mill',
      'color': KormiColors.green,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'Inside') {
      return _locations.where((e) => e['status'] == 'Inside Mill').toList();
    }
    if (_filter == 'Outside') {
      return _locations.where((e) => e['status'] == 'Outside').toList();
    }
    return _locations;
  }

  @override
  Widget build(BuildContext context) {
    final inside = _locations.where((e) => e['status'] == 'Inside Mill').length;
    final outside = _locations.length - inside;

    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('আপনার Live Location আপডেট করা হয়েছে')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Map Placeholder - Premium Navy Card
            Container(
              width: double.infinity,
              height: 210,
              decoration: BoxDecoration(
                color: KormiColors.navy,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: KormiColors.gold.withOpacity(0.3)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: KormiColors.gold.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.location_on_outlined, color: KormiColors.goldLight, size: 36),
                        ),
                        const SizedBox(height: 10),
                        const Text('Kumira • Chittagong',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                        const Text('Mill Location • 22.48° N, 91.71° E',
                            style: TextStyle(color: KormiColors.goldLight, fontSize: 12)),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: KormiColors.green, size: 8),
                          SizedBox(width: 6),
                          Text('Live', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: KormiColors.navy)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Row(
                      children: [
                        Expanded(child: _mapStat('Inside', '$inside', KormiColors.green)),
                        const SizedBox(width: 8),
                        Expanded(child: _mapStat('Outside', '$outside', KormiColors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Mill Selector
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: KormiColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMill,
                        isExpanded: true,
                        items: ['All Mills', 'Mill 1 - Kumira', 'Mill 2 - Sitakunda', 'Mill 3 - Bhatiary']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedMill = v!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: KormiPrimaryButton(
                    label: 'Refresh',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Location Refresh করা হয়েছে')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Inside', 'Outside'].map((f) {
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

            // Location List
            ..._filtered.map((loc) {
              final insideMill = loc['status'] == 'Inside Mill';
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: KormiCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: (loc['color'] as Color).withOpacity(0.12),
                        child: Text((loc['name'] as String)[0],
                            style: TextStyle(fontWeight: FontWeight.bold, color: loc['color'] as Color, fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 15)),
                            Text(loc['role'], style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: KormiColors.textGrey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(loc['place'],
                                      style: const TextStyle(color: KormiColors.navy, fontSize: 13)),
                                ),
                              ],
                            ),
                            Text('Updated ${loc['time']}', style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: insideMill ? KormiColors.green.withOpacity(0.12) : KormiColors.red.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(loc['status'],
                            style: TextStyle(
                                color: insideMill ? KormiColors.green : KormiColors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 11)),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            const Text(
              'Location শুধু Admin / Management দেখতে পারবে। Worker শুধু নিজের Location দেখবে।',
              textAlign: TextAlign.center,
              style: TextStyle(color: KormiColors.textGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.circle, color: color, size: 8),
          const SizedBox(width: 6),
          Text('$label: $value', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}
