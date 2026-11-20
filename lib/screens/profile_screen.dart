// KORMI - Profile Screen
// My Profile + Edit Profile + Logout

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController(text: 'Tariqul Islam');
  final _cardController = TextEditingController(text: 'ADMIN');
  final _phoneController = TextEditingController(text: '01800-000000');
  final _companyController = TextEditingController(text: 'Mill 1 - Kumira');

  bool _editing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.check_outlined : Icons.edit_outlined),
            onPressed: () {
              if (_editing) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile Updated')),
                );
              }
              setState(() => _editing = !_editing);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: KormiColors.navy,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: KormiColors.gold.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.white,
                        child: Text('T', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 32)),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Photo Change - Gallery / Camera')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: KormiColors.gold, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt_outlined, size: 14, color: KormiColors.navy),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Tariqul Islam', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: KormiColors.gold.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                    child: const Text('CHIEF MILL ADMINISTRATOR • ADMIN',
                        style: TextStyle(color: KormiColors.goldLight, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                  const SizedBox(height: 8),
                  const Text('Card: ADMIN • Mill 1 - Kumira',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Info Fields
            KormiCard(
              child: Column(
                children: [
                  _field('Full Name', _nameController, Icons.person_outlined),
                  const SizedBox(height: 12),
                  _field('Card Number / Email (Login ID)', _cardController, Icons.badge_outlined),
                  const SizedBox(height: 12),
                  _field('Phone', _phoneController, Icons.phone_outlined),
                  const SizedBox(height: 12),
                  _field('Company / Mill', _companyController, Icons.factory_outlined),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Stats
            Row(
              children: [
                Expanded(child: _statCard('Present', '26 Days', KormiColors.green)),
                const SizedBox(width: 10),
                Expanded(child: _statCard('OT Hours', '18.5 hrs', KormiColors.navy)),
                const SizedBox(width: 10),
                Expanded(child: _statCard('Salary', '৳ 45,000', KormiColors.gold)),
              ],
            ),
            const SizedBox(height: 14),

            if (_editing)
              KormiPrimaryButton(
                label: 'Save Profile',
                onPressed: () {
                  setState(() => _editing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile Saved')),
                  );
                },
              ),
            if (_editing) const SizedBox(height: 12),

            // Menu
            KormiCard(
              child: Column(
                children: [
                  _menuRow(Icons.lock_outlined, 'Change Password', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Change Password - Old + New Password দিন')),
                    );
                  }),
                  const Divider(height: 1),
                  _menuRow(Icons.notifications_outlined, 'Notification Settings', () {}),
                  const Divider(height: 1),
                  _menuRow(Icons.backup_outlined, 'Backup & Restore', () {}),
                  const Divider(height: 1),
                  _menuRow(Icons.help_outline, 'Help & Support', () {}),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Logout - Data মুছবে না, শুধু Lock হবে
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Logout?'),
                      content: const Text('Logout করলে ডাটা মুছবে না, শুধু Lock হবে। আবার Login করলেই সব ফিরে পাবেন।'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: KormiColors.red),
                          child: const Text('Logout', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout_outlined, color: KormiColors.red),
                label: const Text('Logout', style: TextStyle(color: KormiColors.red, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: KormiColors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Version 1.0.0 • KORMI • Data stays on phone',
                style: TextStyle(color: KormiColors.textGrey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: _editing,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: KormiColors.navy, size: 20),
            filled: true,
            fillColor: _editing ? Colors.white : KormiColors.bg,
            contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: KormiColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: KormiColors.border),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return KormiCard(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _menuRow(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: KormiColors.navy),
      title: Text(label, style: const TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, color: KormiColors.textGrey),
      onTap: onTap,
    );
  }
}
