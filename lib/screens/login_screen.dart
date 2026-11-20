// KORMI - Login Screen
// ADMIN দিয়ে লগইন হলে সরাসরি Dashboard এ যাবে
// আগে শুধু মেসেজ দেখাতো, Dashboard এ যেতো না - এটাই আটকে যাওয়ার কারণ ছিল

import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ID আর Password এর Controller
  final TextEditingController _idController =
      TextEditingController(text: 'ADMIN');
  final TextEditingController _passController =
      TextEditingController(text: 'ADMIN123');

  bool _isLoginTab = true; // উপরে লগইন / Register ট্যাব
  bool _obscurePass = true; // পাসওয়ার্ড লুকানো / দেখানো
  bool _loading = false;

  // ভুল পাসওয়ার্ড গোনার জন্য
  int _wrongCount = 0;
  bool _isLocked = false;

  // লগইন বাটনে চাপ দিলে এই ফাংশন চলবে
  void _doLogin() {
    if (_isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('১৫ মিনিট লক আছে, একটু পরে চেষ্টা করুন')),
      );
      return;
    }

    final String id = _idController.text.trim();
    final String pass = _passController.text.trim();

    // ADMIN চেক - বড় হাতের ADMIN ই দিতে হবে
    if (id == 'ADMIN' && pass == 'ADMIN123') {
      // ১. সফল মেসেজ দেখানো
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin Login হয়ে গেছে')),
      );

      // ২. একটু পরে Dashboard এ পাঠানো - এটাই আগে মিসিং ছিল
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );
      });
    } else {
      // ভুল হলে গোনা
      _wrongCount++;
      if (_wrongCount >= 5) {
        setState(() {
          _isLocked = true;
        });
        // ১৫ মিনিট পর আবার খুলবে
        Future.delayed(const Duration(minutes: 15), () {
          if (mounted) {
            setState(() {
              _isLocked = false;
              _wrongCount = 0;
            });
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('৫ বার ভুল দিয়েছেন, ১৫ মিনিট লক')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ভুল ID / Password - $_wrongCount বার')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1E4A), // গাঢ় নীল Background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // K লোগো
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Center(
                  child: Text(
                    'K',
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'KORMI',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                  letterSpacing: 6,
                ),
              ),
              const Text(
                'স্পিনিং মিল ওয়ার্কফোর্স',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 30),

              // লগইন / Register ট্যাব
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isLoginTab = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoginTab
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFF2A2A4A),
                        foregroundColor:
                            _isLoginTab ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('লগইন',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isLoginTab = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_isLoginTab
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFF2A2A4A),
                        foregroundColor:
                            !_isLoginTab ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Register',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // কার্ড নম্বর / ADMIN ফিল্ড
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'কার্ড নম্বর / ADMIN',
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // পাসওয়ার্ড ফিল্ড
              TextField(
                controller: _passController,
                obscureText: _obscurePass,
                decoration: InputDecoration(
                  labelText: 'পাসওয়ার্ড',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePass
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // লগইন বাটন
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _doLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text('লগইন',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '৫ বার ভুল দিলে ১৫ মিনিট লক থাকবে',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
