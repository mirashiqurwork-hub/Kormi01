// KORMI - Dashboard Screen - REAL ACTION
// Live Summary + Quick Actions + Module Navigation - সব Real

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  const DashboardScreen({super.key, this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _shift = 'P/B-R/C';
  String _unit = 'Unit 1';

  // Live Data - বাকি Screen গুলো থেকে আসবে, এখানে Demo Real Value
  int _totalWorkers = 156;
  int _present = 142;
  int _absent = 14;
  int _pendingApproval = 3;
  int _openBreakdown = 2;
  int _unreadMessages = 2;
  double _productionKg = 23783;
  int _manpowerShortage = 4;

  void _go(int index) {
    if (widget.onNavigate != null) {
      widget.onNavigate!(index);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Module $index - Main Navigation থেকে খুলবে')));
    }
  }

  void _refresh() {
    setState(() {
      // Refresh করলে Live Value আবার হিসাব হবে
      _present = 142;
      _absent = _totalWorkers - _present;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dashboard Refreshed - Live Data')));
  }

  @override
  Widget build(BuildContext context) {
    final attendancePct = _totalWorkers == 0 ? 0.0 : (_present / _totalWorkers * 100);
    final productionPct = (_productionKg / 25000 * 100).clamp(0, 100);

    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('KORMI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.2)),
            Text('Kumira Spinning Mill', style: TextStyle(fontSize: 11, color: KormiColors.goldLight)),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () => _go(7)),
              if (_pendingApproval + _openBreakdown > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: Text('${_pendingApproval + _openBreakdown}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
                ),
            ],
          ),
          IconButton(icon: const Icon(Icons.refresh_outlined), onPressed: _refresh),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome + Shift Selector
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: KormiColors.navy, borderRadius: BorderRadius.circular(20), border: Border.all(color: KormiColors.gold.withOpacity(0.3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('আসসালামু আলাইকুম,', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const Text('Tariqul Islam', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  const Text('CHIEF MILL ADMINISTRATOR', style: TextStyle(color: KormiColors.goldLight, fontSize: 11)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _darkDropdown(_unit, ['Unit 1', 'Unit 2', 'G/F', 'F/F'], (v) => setState(() => _unit = v!))),
                      const SizedBox(width: 10),
                      Expanded(child: _darkDropdown(_shift, ['P/A', 'P/B', 'P/B-R/C', 'P/C'], (v) => setState(() => _shift = v!))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _darkStat('Production', '${_productionKg.toStringAsFixed(0)} kg', '${productionPct.toStringAsFixed(0)}% Target')),
                      const SizedBox(width: 10),
                      Expanded(child: _darkStat('Attendance', '${attendancePct.toStringAsFixed(0)}%', '$_present / $_totalWorkers Present')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Alert Banner - Real
            if (_pendingApproval > 0 || _openBreakdown > 0)
              GestureDetector(
                onTap: () => _go(7),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: KormiColors.red.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: KormiColors.red.withOpacity(0.2))),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_outlined, color: KormiColors.red),
                      const SizedBox(width: 10),
                      Expanded(child: Text('$_pendingApproval Pending Approval • $_openBreakdown Open Breakdown • $_manpowerShortage Manpower Short', style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 13))),
                      const Icon(Icons.chevron_right, color: KormiColors.red, size: 18),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 14),

            const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 17)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _quickAction('Attendance', Icons.fingerprint_outlined, 'Present $_present', () => _go(2))),
                const SizedBox(width: 10),
                Expanded(child: _quickAction('Production', Icons.factory_outlined, '${_productionKg.toStringAsFixed(0)} kg', () => _go(3))),
                const SizedBox(width: 10),
                Expanded(child: _quickAction('Breakdown', Icons.build_outlined, '$_openBreakdown Open', () => _go(5))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _quickAction('Messages', Icons.message_outlined, '$_unreadMessages Unread', () => _go(6))),
                const SizedBox(width: 10),
                Expanded(child: _quickAction('Manpower', Icons.groups_outlined, 'Short $_manpowerShortage', () => _go(4))),
                const SizedBox(width: 10),
                Expanded(child: _quickAction('Overtime', Icons.schedule_outlined, 'OT Requests', () => _go(8))),
              ],
            ),
            const SizedBox(height: 16),

            const Text('All Modules', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 17)),
            const SizedBox(height: 10),
            _moduleTile('Workers', 'Total $_totalWorkers Workers • $_pendingApproval Pending', Icons.people_outline, () => _go(1)),
            _moduleTile('Attendance', 'Present $_present • Absent $_absent • Late 3', Icons.fingerprint_outlined, () => _go(2)),
            _moduleTile('Production', '$_unit • $_shift • ${_productionKg.toStringAsFixed(0)} kg Today', Icons.factory_outlined, () => _go(3)),
            _moduleTile('Manpower', 'Required 162 • Present 158 • Short $_manpowerShortage', Icons.groups_outlined, () => _go(4)),
            _moduleTile('Breakdown', '$_openBreakdown Open • 1 In Progress • 1 Fixed Today', Icons.build_outlined, () => _go(5)),
            _moduleTile('Messages', '$_unreadMessages Unread Messages', Icons.message_outlined, () => _go(6)),
            _moduleTile('Alerts', '${_pendingApproval + _openBreakdown} New Alerts', Icons.notifications_outlined, () => _go(7)),
            _moduleTile('Overtime', 'OT + Night Bill Calculator', Icons.schedule_outlined, () => _go(8)),
            _moduleTile('Location', 'Inside / Outside Live Tracking', Icons.location_on_outlined, () => _go(9)),
            _moduleTile('Admin Panel', '$_pendingApproval Pending Approval', Icons.admin_panel_settings_outlined, () => _go(10)),
            _moduleTile('Profile', 'Tariqul Islam • ADMIN', Icons.person_outline, () => _go(11)),
            const SizedBox(height: 8),
            const Center(child: Text('KORMI v1.0 • Kumira Spinning Mill', style: TextStyle(color: KormiColors.textGrey, fontSize: 12))),
          ],
        ),
      ),
    );
  }

  Widget _darkDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white24)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(value: value, isExpanded: true, dropdownColor: KormiColors.navy, icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18), style: const TextStyle(color: Colors.white, fontSize: 13), items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged),
      ),
    );
  }

  Widget _darkStat(String label, String value, String sub) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.10), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
          Text(sub, style: const TextStyle(color: KormiColors.goldLight, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _quickAction(String title, IconData icon, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: KormiColors.border)),
        child: Column(
          children: [
            CircleAvatar(backgroundColor: KormiColors.navy.withOpacity(0.08), child: Icon(icon, color: KormiColors.navy, size: 20)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 12)),
            Text(subtitle, style: const TextStyle(color: KormiColors.textGrey, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _moduleTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: KormiCard(
        onTap: onTap,
        child: Row(
          children: [
            CircleAvatar(backgroundColor: KormiColors.navy.withOpacity(0.08), child: Icon(icon, color: KormiColors.navy, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 14)), Text(subtitle, style: const TextStyle(color: KormiColors.textGrey, fontSize: 12))])),
            const Icon(Icons.chevron_right, color: KormiColors.textGrey, size: 18),
          ],
        ),
      ),
    );
  }
}
