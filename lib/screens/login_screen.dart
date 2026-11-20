// KORMI - Login Screen - FINAL
// Admin Credentials UI তে দেখানো নাই - Secret Login
// Card Number / Email + Password দিয়ে Login

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  bool _showPass = false;
  bool _loading = false;

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _login() {
    final id = _idController.text.trim();
    final pass = _passController.text.trim();

    if (id.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card Number / Email + Password লিখুন')));
      return;
    }

    setState(() => _loading = true);

    // Demo Login Logic - আসল App এ এখানে Server / Local DB Check হবে
    // Admin / Worker / Pending Check এখানে হবে
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _loading = false);

      // Secret Admin - UI তে কোথাও লেখা নাই
      if (id == 'ADMIN' && pass == 'ADMIN123') {
        Navigator.pushReplacementNamed(context, '/main');
        return;
      }

      // Pending User Demo - K-1046 Pending
      if (id == 'K-1046') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('আপনার Account Pending - Admin Approval এর জন্য অপেক্ষা করুন')));
        return;
      }

      // অন্য সব Valid User ধরে নেওয়া হলো - Demo
      if (pass.length >= 6) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password ভুল - আবার চেষ্টা করুন')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'KORMI',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 42, letterSpacing: 6),
                ),
              ),
              const SizedBox(height: 8),
              Center(child: Container(width: 80, height: 2, color: KormiColors.gold)),
              const SizedBox(height: 10),
              const Center(child: Text('SPINNING MILL WORKFORCE', style: TextStyle(color: KormiColors.goldLight, fontSize: 11, letterSpacing: 3))),
              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome Back', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 22)),
                    const Text('Card Number / Email দিয়ে Login করুন', style: TextStyle(color: KormiColors.textGrey, fontSize: 13)),
                    const SizedBox(height: 18),
                    const Text('Card Number / Email', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                        hintText: 'e.g. K-1041 / email',
                        prefixIcon: const Icon(Icons.badge_outlined, color: KormiColors.textGrey, size: 20),
                        filled: true,
                        fillColor: KormiColors.bg,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Password', style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passController,
                      obscureText: !_showPass,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline, color: KormiColors.textGrey, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: KormiColors.textGrey),
                          onPressed: () => setState(() => _showPass = !_showPass),
                        ),
                        filled: true,
                        fillColor: KormiColors.bg,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: KormiColors.border)),
                      ),
                      onSubmitted: (_) => _login(),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Forgot Password - Admin এর সাথে যোগাযোগ করুন'))),
                        child: const Text('Forgot Password?', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    KormiPrimaryButton(
                      label: _loading ? 'Logging in...' : 'Login',
                      onPressed: _loading ? () {} : _login,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Account নাই? ", style: TextStyle(color: KormiColors.textGrey, fontSize: 13)),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/register'),
                          child: const Text('Register করুন', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: Text('KORMI v1.0 • Kumira Spinning Mill', style: TextStyle(color: Colors.white54, fontSize: 11))),
            ],
          ),
        ),
      ),
    );
  }
}
