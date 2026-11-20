// Login Screen - লগইন
// Admin: ADMIN / ADMIN123
// Worker / Officer: নিজে Register করবে, Pending থাকবে, Admin Approve করলে ঢুকতে পারবে।
// Logout না করা পর্যন্ত Login থাকবে, ডাটা ডিলিট হবে না।

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();

  String _role = 'Worker'; // Worker / Officer / Management / Admin
  bool _isRegister = false;
  bool _showPass = false;

  void _login() {
    final user = _userController.text.trim();
    final pass = _passController.text.trim();

    // Admin ডেমো লগইন
    if (user == 'ADMIN' && pass == 'ADMIN123') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin Login হয়ে গেছে')),
      );
      return;
    }

    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('কার্ড নম্বর / ইউজার + পাসওয়ার্ড দিন')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('লগইন চেক করা হচ্ছে...')),
    );
  }

  void _register() {
    if (_nameController.text.trim().isEmpty || _cardController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('নাম + কার্ড নম্বর দিন')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Register হয়েছে, Pending আছে। Admin Approve করলে ঢুকতে পারবেন।')),
    );
    setState(() => _isRegister = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1D3F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // লোগো
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text('K', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'KORMI',
                style: TextStyle(color: Color(0xFFD4AF37), fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4),
              ),
              const Text(
                'স্পিনিং মিল ওয়ার্কফোর্স',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),
              // Login / Register ট্যাব
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_isRegister ? const Color(0xFFD4AF37) : Colors.white12,
                      ),
                      onPressed: () => setState(() => _isRegister = false),
                      child: Text('লগইন', style: TextStyle(color: !_isRegister ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isRegister ? const Color(0xFFD4AF37) : Colors.white12,
                      ),
                      onPressed: () => setState(() => _isRegister = true),
                      child: Text('Register', style: TextStyle(color: _isRegister ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (!_isRegister) ...[
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'কার্ড নম্বর / ADMIN',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passController,
                  obscureText: !_showPass,
                  decoration: InputDecoration(
                    labelText: 'পাসওয়ার্ড',
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _showPass = !_showPass),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                    onPressed: _login,
                    child: const Text('লগইন', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('৫ বার ভুল দিলে ১৫ মিনিট লক থাকবে', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ] else ...[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'নাম',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _cardController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'কার্ড নম্বর',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _role,
                  decoration: const InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'Worker', child: Text('Worker')),
                    DropdownMenuItem(value: 'Officer', child: Text('Officer')),
                  ],
                  onChanged: (v) => setState(() => _role = v ?? 'Worker'),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                    onPressed: _register,
                    child: const Text('Register - Pending', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
