// KORMI - Location Screen - REAL ACTION
// LocationService দিয়ে Inside / Outside + Distance Real Check

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';
import '../services/location_service.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _filter = 'All';
  String _selectedMill = 'Mill 1 - Kumira';

  // My Current Location - Demo, আসল GPS এলে এখানে GPS Lat/Lng বসবে
  double _myLat = 22.4825;
  double _myLng = 91.7135;

  final List<Map<String, dynamic>> _workers = [
    {'name': 'Tariqul Islam', 'role': 'CHIEF MILL ADMINISTRATOR', 'lat': 22.4825, 'lng': 91.7135, 'time': '2 min ago'},
    {'name': 'Rahim Uddin', 'role': 'Shift Incharge - P/B', 'lat': 22.4828, 'lng': 91.7130, 'time': '5 min ago'},
    {'name': 'Karim Sheikh', 'role': 'Worker - Ring', 'lat': 22.5925, 'lng': 91.6620, 'time': '12 min ago'},
    {'name': 'Nasir Ahmed', 'role': 'Officer - Production', 'lat': 22.5000, 'lng': 91.7300, 'time': '28 min ago'},
    {'name': 'Jashim Uddin', 'role': 'Worker - Packing', 'lat': 22.4820, 'lng': 91.7140, 'time': '1 min ago'},
  ];

  MillLocation get _currentMill {
    return LocationService.mills.firstWhere(
      (m) => m.name == _selectedMill,
      orElse: () => LocationService.mills.first,
    );
  }

  List<Map<String, dynamic>> get _filtered {
    final withStatus = _workers.map((w) {
      final mill = LocationService.findCurrentMill(w['lat'], w['lng']);
      final status = mill != null ? 'Inside Mill' : 'Outside';
      final millName = mill?.name ?? 'Outside';
      final dist = LocationService.distanceInMeters(w['lat'], w['lng'], _currentMill.lat, _currentMill.lng);
      return {...w, 'status': status, 'millName': millName, 'distance': dist};
    }).toList();

    if (_filter == 'Inside') return withStatus.where((e) => e['status'] == 'Inside Mill').toList();
    if (_filter == 'Outside') return withStatus.where((e) => e['status'] == 'Outside').toList();
    return withStatus;
  }

  void _refreshMyLocation({bool inside = true}) {
    final demo = inside ? LocationService.demoInsideLocation() : LocationService.demoOutsideLocation();
    setState(() {
      _myLat = demo['lat']!;
      _myLng = demo['lng']!;
    });
    final mill = LocationService.findCurrentMill(_myLat, _myLng);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mill != null ? 'আপনি Inside - ${mill.name}' : 'আপনি Outside - Mill এর বাইরে')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final insideCount = _workers.where((w) => LocationService.findCurrentMill(w['lat'], w['lng']) != null).length;
    final outsideCount = _workers.length - insideCount;
    final myMill = LocationService.findCurrentMill(_myLat, _myLng);
    final myStatus = myMill != null ? 'Inside - ${myMill.name}' : 'Outside';

    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Location'),
        actions: [
          IconButton(icon: const Icon(Icons.my_location_outlined), onPressed: () => _refreshMyLocation(inside: true)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // My Location Card - Real Check
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KormiColors.navy,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: KormiColors.gold.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('My Live Location', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: myMill != null ? KormiColors.green : KormiColors.red, borderRadius: BorderRadius.circular(20)),
                        child: Text(myMill != null ? 'Inside' : 'Outside', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(myStatus, style: const TextStyle(color: KormiColors.goldLight, fontSize: 13)),
                  Text('Lat: $_myLat, Lng: $_myLng', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _refreshMyLocation(inside: true),
                          style: ElevatedButton.styleFrom(backgroundColor: KormiColors.gold, foregroundColor: KormiColors.navy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                          child: const Text('Inside Test', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _refreshMyLocation(inside: false),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                          child: const Text('Outside Test', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Mill Selector + Counts
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: KormiColors.border)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMill,
                        isExpanded: true,
                        items: LocationService.mills.map((m) => DropdownMenuItem(value: m.name, child: Text(m.name, style: const TextStyle(fontSize: 13)))).toList(),
                        onChanged: (v) => setState(() => _selectedMill = v!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: KormiColors.border)),
                  child: Text('In: $insideCount • Out: $outsideCount', style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 14),

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
                        decoration: BoxDecoration(color: active ? KormiColors.navy : Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: KormiColors.border)),
                        child: Text(f, style: TextStyle(color: active ? KormiColors.goldLight : KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            ..._filtered.map((loc) {
              final inside = loc['status'] == 'Inside Mill';
              final dist = loc['distance'] as double;
              final distText = dist < 1000 ? '${dist.toStringAsFixed(0)}m' : '${(dist / 1000).toStringAsFixed(1)}km';
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: KormiCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: (inside ? KormiColors.green : KormiColors.red).withOpacity(0.12),
                        child: Text((loc['name'] as String)[0], style: TextStyle(fontWeight: FontWeight.bold, color: inside ? KormiColors.green : KormiColors.red, fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 15)),
                            Text(loc['role'], style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                            const SizedBox(height: 2),
                            Text('${loc['millName']} • $distText দূরে', style: const TextStyle(color: KormiColors.navy, fontSize: 13)),
                            Text('Updated ${loc['time']}', style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: inside ? KormiColors.green.withOpacity(0.12) : KormiColors.red.withOpacity(0.10), borderRadius: BorderRadius.circular(20)),
                        child: Text(inside ? 'Inside' : 'Outside', style: TextStyle(color: inside ? KormiColors.green : KormiColors.red, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            const Text('Location শুধু Admin / Management দেখতে পারবে। Worker শুধু নিজের Location দেখবে।', textAlign: TextAlign.center, style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
