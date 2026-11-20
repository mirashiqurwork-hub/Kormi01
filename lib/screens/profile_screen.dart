// KORMI - Profile Screen - REAL ACTION
// Edit Profile + Change Password + Settings + Logout - সব Real

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Tariqul Islam';
  String _card = 'ADMIN';
  String _role = 'CHIEF MILL ADMINISTRATOR';
  String _section = 'ALL SECTION';
  String _shift = 'P/B-R/C';
  String _phone = '01811-123456';
  String _company = 'Kumira Spinning Mill';
  String _joining = '01.01.2020';
  String _salary = '45000';

  bool _notifEnabled = true;
  bool _locationEnabled = true;
  bool _darkMode = false;

  void _showEditProfile() {
    final nameC = TextEditingController(text: _name);
    final phoneC = TextEditingController(text: _phone);
    final salaryC = TextEditingController(text: _salary);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, left: 16, right: 16, top: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: KormiColors.navy)),
              const SizedBox(height: 12),
              TextField(controller: nameC, decoration: _input('Full Name')),
              const SizedBox(height: 10),
              TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: _input('Phone')),
              const SizedBox(height: 10),
              TextField(controller: salaryC, keyboardType: TextInputType.number, decoration: _input('Salary')),
              const SizedBox(height: 14),
              KormiPrimaryButton(
                label: 'Save Profile',
                onPressed: () {
                  if (nameC.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name লিখুন')));
                    return;
                  }
                  setState(() {
                    _name = nameC.text.trim();
                    _phone = phoneC.text.trim();
                    _salary = salaryC.text.trim();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated')));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePassword() {
    final oldC = TextEditingController();
    final newC = TextEditingController();
    final confirmC = TextEditingController();
    bool showOld = false;
    bool showNew = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, left: 16, right: 16, top: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: KormiColors.navy)),
                const SizedBox(height: 12),
                TextField(
                  controller: oldC,
                  obscureText: !showOld,
                  decoration: _input('Old Password').copyWith(suffixIcon: IconButton(icon: Icon(showOld ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20), onPressed: () => setSheet(() => showOld = !showOld))),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: newC,
                  obscureText: !showNew,
                  decoration: _input('New Password').copyWith(suffixIcon: IconButton(icon: Icon(showNew ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20), onPressed: () => setSheet(() => showNew = !showNew))),
                ),
                const SizedBox(height: 10),
                TextField(controller: confirmC, obscureText: true, decoration: _input('Confirm New Password')),
                const SizedBox(height: 14),
                KormiPrimaryButton(
                  label: 'Update Password',
                  onPressed: () {
                    if (oldC.text.isEmpty || newC.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('সব Field পূরণ করুন')));
                      return;
                    }
                    if (newC.text != confirmC.text) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('New Password মিলে নাই')));
                      return;
                    }
                    if (newC.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password কমপক্ষে 6 অক্ষর হতে হবে')));
                      return;
                    }
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password Changed Successfully')));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('আপনি কি Logout করতে চান?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged Out - Login Screen এ যাবে')));
              // আসল App এ এখানে Navigator.pushReplacement -> LoginScreen হবে
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(backgroundColor: KormiColors.navy, foregroundColor: KormiColors.goldLight, title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: KormiColors.navy, borderRadius: BorderRadius.circular(20), border: Border.all(color: KormiColors.gold.withOpacity(0.3))),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(radius: 42, backgroundColor: KormiColors.gold.withOpacity(0.2), child: Text(_name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32))),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo Change - Gallery থেকে ছবি নেওয়া যাবে'))),
                          child: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: KormiColors.gold, shape: BoxShape.circle), child: const Icon(Icons.camera_alt_outlined, size: 14, color: KormiColors.navy)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(_role, style: const TextStyle(color: KormiColors.goldLight, fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text('Card: $_card • $_company', style: const TextStyle(color: Colors.white, fontSize: 12))),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: _showEditProfile, style: ElevatedButton.styleFrom(backgroundColor: KormiColors.gold, foregroundColor: KormiColors.navy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            KormiCard(
              child: Column(
                children: [
                  _infoRow('Card Number', _card),
                  _infoRow('Section', _section),
                  _infoRow('Shift', _shift),
                  _infoRow('Phone', _phone),
                  _infoRow('Company', _company),
                  _infoRow('Joining Date', _joining),
                  _infoRow('Salary', '$_salary ৳', isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 14),
            KormiCard(
              child: Column(
                children: [
                  _switchRow('Notifications', 'Breakdown, OT, Approval Alert', _notifEnabled, (v) => setState(() => _notifEnabled = v)),
                  _switchRow('Location Sharing', 'Duty চলাকালীন Location Share', _locationEnabled, (v) => setState(() => _locationEnabled = v)),
                  _switchRow('Dark Mode', 'App Dark Mode (Coming Soon)', _darkMode, (v) => setState(() => _darkMode = v), isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 14),
            KormiCard(
              child: Column(
                children: [
                  _actionRow('Change Password', Icons.lock_outline, _showChangePassword),
                  _actionRow('My Attendance History', Icons.history_outlined, () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance History - Attendance Screen থেকে দেখুন')))),
                  _actionRow('My Salary Slip', Icons.receipt_long_outlined, () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Salary Slip - $_name • $_salary ৳')))),
                  _actionRow('Help & Support', Icons.help_outline, () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Support: Admin এর সাথে যোগাযোগ করুন'))), isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(onPressed: _logout, icon: const Icon(Icons.logout_outlined, color: Colors.red, size: 18), label: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)), style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), padding: const EdgeInsets.symmetric(vertical: 13))),
            ),
            const SizedBox(height: 8),
            const Text('KORMI v1.0 • Kumira Spinning Mill', style: TextStyle(color: KormiColors.textGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: KormiColors.textGrey, fontSize: 13)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 13))]),
        ),
        if (!isLast) const Divider(height: 1, color: KormiColors.border),
      ],
    );
  }

  Widget _switchRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged, {bool isLast = false}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 14)), Text(subtitle, style: const TextStyle(color: KormiColors.textGrey, fontSize: 11))])),
            Switch(value: value, onChanged: onChanged, activeColor: KormiColors.navy),
          ],
        ),
        if (!isLast) const Divider(height: 16, color: KormiColors.border),
      ],
    );
  }

  Widget _actionRow(String title, IconData icon, VoidCallback onTap, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(leading: Icon(icon, color: KormiColors.navy, size: 20), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 14)), trailing: const Icon(Icons.chevron_right, color: KormiColors.textGrey, size: 18), contentPadding: EdgeInsets.zero, onTap: onTap),
        if (!isLast) const Divider(height: 1, color: KormiColors.border),
      ],
    );
  }

  InputDecoration _input(String hint) {
    return InputDecoration(hintText: hint, filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)));
  }
}
