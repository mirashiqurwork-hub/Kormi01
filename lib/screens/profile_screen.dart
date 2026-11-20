import 'package:flutter/material.dart';
import '../database/kormi_database.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workers = KormiDatabase.getWorkers();
    final production = KormiDatabase.getProduction();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(radius: 50, backgroundColor: Color(0xFF0A1E3C), child: Icon(Icons.person, size: 50, color: Colors.white)),
          const SizedBox(height: 12),
          const Text('Admin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0A1E3C))),
          const Text('KORMI • Spinning Mill', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total Workers'), Text('${workers.length}', style: const TextStyle(fontWeight: FontWeight.bold))]),
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Production Entry'), Text('${production.length}', style: const TextStyle(fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () { Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
