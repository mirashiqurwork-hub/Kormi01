// KORMI - Login Screen
// No Default Username / Password দেখানো যাবে না - Secret
// No Big K Logo - User পরে আসল Logo দিবে
// Login -> Dashboard, আটকাবে না

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _cardController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;
  String _error = '';

  void _login() {
    final card = _cardController.text.trim();
    final pass = _passwordController.text.trim();

    if (card.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Card Number / Email আর Password দিন');
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _loading = false);

      // Admin Login - ADMIN / ADMIN123 (UI তে দেখানো যাবে না)
      // Worker / Officer - যেকোনো Valid Card + Password এ Dashboard যাবে
      // Pending হলে Dashboard যাবে না - Admin Approval লাগবে
      if (card.toUpperCase() == 'ADMIN' && pass == 'ADMIN123') {
        Navigator.pushReplacementNamed(context, '/dashboard');
        return;
      }

      // Demo: Card K- দিয়ে শুরু হলে Login Success ধরা হবে
      // আসল App এ Hive থেকে Check হবে
      if (pass.length >= 4) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        setState(() => _error = 'Wrong Card / Password. আবার চেষ্টা করুন');
      }
    });
  }

  @override
  void dispose() {
    _cardController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              // Logo জায়গা - এখন K Logo নাই, User পরে দিবে
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: KormiColors.navy,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: KormiColors.gold.withOpacity(0.4)),
                ),
                child: const Center(
                  child: Text(
                    'KORMI',
                    style: TextStyle(
                      color: KormiColors.goldLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'KORMI',
                style: TextStyle(
                  color: KormiColors.navy,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  letterSpacing: 3,
                ),
              ),
              const Text(
                'Mill Management System',
                style: TextStyle(color: KormiColors.textGrey, fontSize: 13),
              ),
              const SizedBox(height: 28),

              // Login Card
              KormiCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome Back',
                        style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 20)),
                    const Text('Login করে Dashboard এ যান',
                        style: TextStyle(color: KormiColors.textGrey, fontSize: 13)),
                    const SizedBox(height: 18),

                    const Text('Card Number / Email (Login ID)',
                        style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 13)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _cardController,
                      decoration: const InputDecoration(
                        hintText: 'Card Number / Email দিন',
                        prefixIcon: Icon(Icons.badge_outlined, color: KormiColors.navy),
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Text('Password',
                        style: TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 13)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        hintText: 'Password দিন',
                        prefixIcon: const Icon(Icons.lock_outlined, color: KormiColors.navy),
                        suffixIcon: IconButton(
                          icon: Icon(_showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: KormiColors.textGrey),
                          onPressed: () => setState(() => _showPassword = !_showPassword),
                        ),
                      ),
                      onSubmitted: (_) => _login(),
                    ),
                    if (_error.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: KormiColors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(_error, style: const TextStyle(color: KormiColors.red, fontSize: 13)),
                      ),
                    ],
                    const SizedBox(height: 18),
                    KormiPrimaryButton(
                      label: _loading ? 'Logging in...' : 'Login',
                      onPressed: _loading ? null : _login,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Admin এর সাথে যোগাযোগ করুন - Password Reset Admin করবে')),
                          );
                        },
                        child: const Text('Forgot Password?', style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('নতুন Worker / Officer? ', style: TextStyle(color: KormiColors.textGrey)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: const Text('Register করুন',
                        style: TextStyle(color: KormiColors.navy, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Data ফোনে থাকে • Offline চলে • Logout করলেও ডাটা মুছবে না',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: KormiColors.textGrey, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
