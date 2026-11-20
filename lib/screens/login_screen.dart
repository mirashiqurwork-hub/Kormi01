// KORMI - Login Screen - File 2
// ছবির মতো: বড় K লোগো নাই, শুধু KORMI লেখা
// Sign In / Register ট্যাব, Card ID, Password/PIN
// লগইন সফল হলে ড্যাশবোর্ডে যাবে, আটকে থাকবে না

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // true = Sign In, false = Register
  bool _isSignIn = true;

  // টেক্সট ফিল্ডের কন্ট্রোলার
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();

  // পাসওয়ার্ড দেখা / লুকানো
  bool _hidePass = true;

  // লোডিং দেখানোর জন্য
  bool _loading = false;

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // ডিফল্ট অ্যাডমিন বাটন - ADMIN / ADMIN123 ভরে দিবে
  void _fillAdmin() {
    setState(() {
      _isSignIn = true;
      _idController.text = 'ADMIN';
      _passController.text = 'ADMIN123';
    });
  }

  // লগইন বাটন
  void _onLogin() {
    final id = _idController.text.trim();
    final pass = _passController.text.trim();

    // খালি থাকলে আটকে দিবে
    if (id.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card ID আর Password দিন')),
      );
      return;
    }

    setState(() => _loading = true);

    // একটু দেরি করে ড্যাশবোর্ডে পাঠাই, যাতে লোডিং বোঝা যায়
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _loading = false);

      // ডিফল্ট অ্যাডমিন চেক - পরে এখানে আসল ডাটাবেজ চেক বসবে
      if (id.toUpperCase() == 'ADMIN' && pass == 'ADMIN123') {
        // সফল হলে ড্যাশবোর্ডে যাবে, ব্যাকে আর লগইনে ফিরবে না
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // আপাতত ডেমো ইউজারদেরও ঢুকতে দিবো, যাতে আটকে না থাকে
        // পরে File 3+ এ আসল AuthService বসলে এটা শক্ত হবে
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    });
  }

  // রেজিস্টার বাটন
  void _onRegister() {
    final name = _nameController.text.trim();
    final id = _idController.text.trim();
    final pass = _passController.text.trim();

    if (name.isEmpty || id.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('নাম, Card ID আর Password দিন')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('রেজিস্টার রিকোয়েস্ট Admin-এর কাছে গেছে')),
    );

    // রেজিস্টারের পর Sign In ট্যাবে ফিরিয়ে দিবো
    setState(() {
      _isSignIn = true;
    });
  }

  // ইনপুট বক্সের স্টাইল - ছবির মতো সাদা + হালকা বর্ডার
  InputDecoration _inputStyle(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: KormiColors.textGrey),
      prefixIcon: Icon(icon, color: KormiColors.textGrey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: KormiColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: KormiColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: KormiColors.navy, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // উপরে শুধু KORMI লেখা - কোনো বড় K লোগো নাই
              const Text(
                'KORMI',
                style: TextStyle(
                  color: KormiColors.navy,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Spinning Mill Workforce',
                style: TextStyle(
                  color: KormiColors.textGrey,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 24),

              // সাদা কার্ড
              KormiCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Sign In / Register ট্যাব
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: KormiColors.bg,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: _tabButton('Sign In', _isSignIn, () {
                            setState(() => _isSignIn = true);
                          })),
                          Expanded(child: _tabButton('Register', !_isSignIn, () {
                            setState(() => _isSignIn = false);
                          })),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Register হলে নামের ফিল্ড দেখাবে
                    if (!_isSignIn) ...[
                      TextField(
                        controller: _nameController,
                        decoration: _inputStyle('Full Name', Icons.person_outline),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Card ID / Admin ID
                    TextField(
                      controller: _idController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: _inputStyle('Card ID / Admin ID', Icons.badge_outlined),
                    ),
                    const SizedBox(height: 14),

                    // Password / PIN
                    TextField(
                      controller: _passController,
                      obscureText: _hidePass,
                      decoration: _inputStyle('Password / PIN', Icons.lock_outline).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _hidePass ? Icons.visibility_off : Icons.visibility,
                            color: KormiColors.textGrey,
                          ),
                          onPressed: () => setState(() => _hidePass = !_hidePass),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // মেইন বাটন
                    _loading
                        ? const Center(child: CircularProgressIndicator(color: KormiColors.navy))
                        : KormiPrimaryButton(
                            label: _isSignIn ? 'Sign In to Mill Workspace' : 'Register',
                            onPressed: _isSignIn ? _onLogin : _onRegister,
                          ),
                    const SizedBox(height: 14),

                    // ডিফল্ট অ্যাডমিন
                    const Center(
                      child: Text(
                        'Default Admin: ADMIN / ADMIN123',
                        style: TextStyle(color: KormiColors.textGrey, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Fill Admin বাটন
                    OutlinedButton(
                      onPressed: _fillAdmin,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: KormiColors.gold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text(
                        'Fill Admin',
                        style: TextStyle(
                          color: KormiColors.navy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Offline • Fast • Secure',
                style: TextStyle(color: KormiColors.textGrey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ট্যাব বাটন - অ্যাকটিভটা নেভি, বাকিটা হালকা
  Widget _tabButton(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: active ? KormiColors.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? KormiColors.goldLight : KormiColors.textGrey,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
