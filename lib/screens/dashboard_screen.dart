// KORMI - Dashboard Screen - File 3
// ছবির মতো: উপরে ডার্ক নেভি হেডার, নিচে সাদা কার্ড
// কার্ডে চাপ দিলে মডিউল খুলবে, শুধু SnackBar না

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // বটম বারে কোনটা সিলেক্টেড
  int _bottomIndex = 0;

  // মডিউল খোলা - আপাতত Coming Soon পেজে যাবে
  // পরে আসল মডিউল ফাইল এলে এই ফাংশনটা আপডেট হবে
  void _openModule(String title, String route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ModuleComingSoon(title: title, route: route),
      ),
    );
  }

  // বটম বার চাপ দিলে
  void _onBottomTap(int index) {
    setState(() => _bottomIndex = index);
    if (index == 1) {
      _openModule('Messages', '/messages');
    } else if (index == 2) {
      _openModule('Mill Alerts & Notices', '/alerts');
    } else if (index == 3) {
      _openModule('Admin', '/admin');
    }
    // index 0 = Home, এই পেজেই থাকবে
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      // উপরের ডার্ক নেভি অংশ
      body: Column(
        children: [
          // ---- Top Header ----
          Container(
            width: double.infinity,
            color: KormiColors.navy,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KORMI • Normal
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '09:45',
                        style: TextStyle(color: KormiColors.goldLight, fontSize: 13),
                      ),
                      Text(
                        'KORMI  •  Normal',
                        style: TextStyle(
                          color: KormiColors.gold,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: KormiColors.gold,
                        child: Text(
                          'TI',
                          style: TextStyle(
                            color: KormiColors.navy,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tariqul Islam',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ADMIN • Shift P/B-R/C • Unit 1',
                              style: TextStyle(color: KormiColors.goldLight, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.notifications_none, color: KormiColors.goldLight),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ---- Body ----
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // আজকের হিসাব - ২টা কার্ড
                  Row(
                    children: [
                      Expanded(
                        child: KormiCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Present Today', style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                              SizedBox(height: 4),
                              Text('128', style: TextStyle(color: KormiColors.navy, fontSize: 24, fontWeight: FontWeight.bold)),
                              Text('Total 142', style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: KormiCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Production Today', style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                              SizedBox(height: 4),
                              Text('39,353 kg', style: TextStyle(color: KormiColors.navy, fontSize: 20, fontWeight: FontWeight.bold)),
                              Text('Unit 1 • P/B-R/C', style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // মডিউল গ্রিড - ছবির মতো
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.45,
                    children: [
                      _moduleCard(Icons.groups_outlined, 'Workers', '142 Workers', () => _openModule('Workers', '/workers')),
                      _moduleCard(Icons.fingerprint, 'Attendance', 'Present / Absent', () => _openModule('Attendance', '/attendance')),
                      _moduleCard(Icons.factory_outlined, 'Production', 'Entry • Calculator', () => _openModule('Production', '/production')),
                      _moduleCard(Icons.people_outline, 'Manpower', 'Shift Manpower', () => _openModule('Manpower', '/manpower')),
                      _moduleCard(Icons.build_outlined, 'Breakdown', '2 Active', () => _openModule('Breakdown', '/breakdown')),
                      _moduleCard(Icons.chat_bubble_outline, 'Messages', '2 Unread', () => _openModule('Messages', '/messages')),
                      _moduleCard(Icons.location_on_outlined, 'Location', 'GPS Check-In', () => _openModule('Location', '/location')),
                      _moduleCard(Icons.shield_outlined, 'Admin', 'Shifts • Access', () => _openModule('Admin', '/admin')),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ASK AI কার্ড
                  KormiCard(
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: KormiColors.navy,
                          child: Icon(Icons.mic_none, color: KormiColors.goldLight),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ASK AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: KormiColors.navy)),
                              Text('বাংলা / English / Banglish - মুখে বললেই হবে', style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => _openModule('ASK AI', '/ask-ai'),
                          child: const Text('Open', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ---- Bottom Bar - ছবির মতো ----
      bottomNavigationBar: Container(
        color: KormiColors.navy,
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomItem(Icons.home_outlined, 'Home', 0, null),
            _bottomItem(Icons.chat_bubble_outline, 'Chat', 1, '2'),
            _bottomItem(Icons.notifications_none, 'Alerts', 2, '•'),
            _bottomItem(Icons.shield_outlined, 'Admin', 3, null),
          ],
        ),
      ),
    );
  }

  // মডিউল কার্ড
  Widget _moduleCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: KormiCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: KormiColors.navy, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: KormiColors.navy)),
            Text(subtitle, style: const TextStyle(color: KormiColors.textGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // বটম বার আইটেম
  Widget _bottomItem(IconData icon, String label, int index, String? badge) {
    final active = _bottomIndex == index;
    return GestureDetector(
      onTap: () => _onBottomTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: active ? KormiColors.gold : KormiColors.goldLight.withOpacity(0.6), size: 26),
              if (badge != null)
                Positioned(
                  right: -8,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: badge == '•' ? KormiColors.red : KormiColors.gold,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge == '•' ? '' : badge,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: KormiColors.navy),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: active ? KormiColors.gold : KormiColors.goldLight.withOpacity(0.6),
              fontSize: 12,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// অস্থায়ী পেজ - আসল মডিউল ফাইল না আসা পর্যন্ত
// পরে এই ক্লাসটা লাগবে না, আসল মডিউল খুলবে
class _ModuleComingSoon extends StatelessWidget {
  final String title;
  final String route;
  const _ModuleComingSoon({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.construction_outlined, size: 48, color: KormiColors.navy),
              const SizedBox(height: 14),
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: KormiColors.navy)),
              const SizedBox(height: 8),
              Text(
                'এই মডিউলটা পরের ফাইলে আসবে\nRoute: $route',
                textAlign: TextAlign.center,
                style: const TextStyle(color: KormiColors.textGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
