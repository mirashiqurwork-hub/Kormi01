import 'package:flutter/material.dart';
import '../database/kormi_database.dart';
import 'workers_screen.dart';
import 'attendance_screen.dart';
import 'production_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalWorkers = 0;
  int _presentToday = 0;
  double _todayProduction = 0;
  double _todayTarget = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final workers = KormiDatabase.getWorkers();
    final attendance = KormiDatabase.getAttendance();
    final production = KormiDatabase.getProduction();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    int present = 0;
    for (final a in attendance) {
      final d = (a['date'] ?? '').toString();
      if (d.startsWith(today) && (a['status'] ?? '') == 'Present') {
        present++;
      }
    }
    double prod = 0;
    double target = 0;
    for (final p in production) {
      final d = (p['date'] ?? '').toString();
      if (d.startsWith(today)) {
        prod += (p['actual'] is num) ? (p['actual'] as num).toDouble() : double.tryParse(p['actual'].toString()) ?? 0;
        target += (p['target'] is num) ? (p['target'] as num).toDouble() : double.tryParse(p['target'].toString()) ?? 0;
      }
    }
    setState(() {
      _totalWorkers = workers.length;
      _presentToday = present;
      _todayProduction = prod;
      _todayTarget = target;
    });
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0A1E3C))),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(String title, String sub, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD4AF6A).withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF0A1E3C), size: 26),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _todayTarget == 0 ? 0 : (_todayProduction / _todayTarget).clamp(0, 1);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1E3C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) {
                        return const Center(child: Text('KORMI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF0A1E3C))));
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('KORMI', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('Spinning Mill • Today Overview', style: TextStyle(color: Color(0xFFD4AF6A), fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _statCard('Total Workers', '$_totalWorkers', Icons.people, const Color(0xFF0A1E3C)),
              const SizedBox(width: 12),
              _statCard('Present Today', '$_presentToday', Icons.check_circle, Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statCard('Production', '${_todayProduction.toStringAsFixed(0)} Kg', Icons.factory, Colors.orange),
              const SizedBox(width: 12),
              _statCard('Target', '${_todayTarget.toStringAsFixed(0)} Kg', Icons.flag, const Color(0xFFD4AF6A)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Today Production', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A1E3C))),
                    Text('${(progress * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A1E3C))),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(value: progress, minHeight: 10, backgroundColor: Colors.grey.shade200, valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF6A))),
                ),
                const SizedBox(height: 8),
                Text('$_todayProduction Kg / $_todayTarget Kg', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0A1E3C))),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _actionCard('Add Worker', 'New worker add koro', Icons.person_add, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkersScreen()));
              }),
              _actionCard('Attendance', 'Present / Absent dao', Icons.check_circle, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen()));
              }),
              _actionCard('Production', 'Production entry dao', Icons.factory, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductionScreen()));
              }),
              _actionCard('Calculator', 'Efficiency hisab koro', Icons.calculate, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductionScreen()));
              }),
              _actionCard('Workers List', 'Sob worker dekho', Icons.list, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkersScreen()));
              }),
              _actionCard('My Profile', 'Profile dekho', Icons.person, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              }),
            ],
          ),
        ],
      ),
    );
  }
}
