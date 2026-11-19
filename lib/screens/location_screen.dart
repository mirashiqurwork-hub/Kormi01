// Location Screen - লোকেশন
// কে কোথায় আছে, লাইভ লোকেশন দেখা যাবে।

import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // ডেমো লোকেশন লিস্ট
  List<Map<String, String>> _locations = [
    {'name': 'ফাতেমা আক্তার', 'unit': 'Unit 1', 'place': 'মিলের ভিতরে - রিং সেকশন', 'time': '৫ মিনিট আগে'},
    {'name': 'মোঃ রহিম', 'unit': 'Unit 1', 'place': 'মিলের ভিতরে - ব্যাক সাইড', 'time': '২ মিনিট আগে'},
    {'name': 'করিম মিয়া', 'unit': 'Unit 2', 'place': 'মিলের বাইরে', 'time': '১০ মিনিট আগে'},
  ];

  bool _liveOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A2F),
        title: const Text(
          'লোকেশন',
          style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // উপরে ম্যাপের জায়গা, পরে আসল ম্যাপ আসবে
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.4)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 50, color: Color(0xFFD4AF37)),
                SizedBox(height: 8),
                Text(
                  'ম্যাপ এখানে দেখা যাবে',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Private করার পর আসল ম্যাপ চালু হবে',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          // লাইভ লোকেশন অন / অফ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'আমার লাইভ লোকেশন শেয়ার করুন',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Switch(
                  value: _liveOn,
                  activeColor: const Color(0xFFD4AF37),
                  onChanged: (v) => setState(() => _liveOn = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // কে কোথায় আছে লিস্ট
          Expanded(
            child: ListView.builder(
              itemCount: _locations.length,
              itemBuilder: (context, index) {
                final item = _locations[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFD4AF37),
                      child: Icon(Icons.location_on, color: Colors.black),
                    ),
                    title: Text(
                      item['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${item['unit']} - ${item['place']}'),
                    trailing: Text(item['time']!, style: const TextStyle(fontSize: 12)),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
