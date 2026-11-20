import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'Worker';
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final List<String> _roles = ['Worker', 'Officer', 'Management', 'Admin'];

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF0A1F44),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _login() async {
    final String loginId = _idController.text.trim();
    final String password = _passwordController.text.trim();

    if (loginId.isEmpty) {
      _showMessage('Card Number / Email দিন');
      return;
    }
    if (password.isEmpty) {
      _showMessage('Password দিন');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (loginId == 'ADMIN' && password == 'ADMIN123' && _selectedRole == 'Admin') {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', 'ADMIN');
        await prefs.setString('userName', 'Admin');
        await prefs.setString('userRole', 'Admin');
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
        return;
      }

      final String usersString = prefs.getString('kormi_users') ?? '[]';
      final List<dynamic> users = jsonDecode(usersString);

      Map<String, dynamic>? foundUser;
      for (final dynamic item in users) {
        final Map<String, dynamic> user = Map<String, dynamic>.from(item);
        final String cardNumber = (user['cardNumber'] ?? '').toString();
        final String email = (user['email'] ?? '').toString();
        final String userPassword = (user['password'] ?? '').toString();
        final String userRole = (user['role'] ?? '').toString();
        if ((cardNumber == loginId || email == loginId) &&
            userPassword == password &&
            userRole == _selectedRole) {
          foundUser = user;
          break;
        }
      }

      if (foundUser == null) {
        _showMessage('ID, Password বা Role ঠিক নেই');
        return;
      }

      final String status = (foundUser['status'] ?? 'pending').toString();
      if (status != 'approved') {
        _showMessage('আপনার অ্যাকাউন্ট এখনো Pending আছে। Admin Approve করলে লগইন করতে পারবেন।');
        return;
      }

      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', (foundUser['cardNumber'] ?? loginId).toString());
      await prefs.setString('userName', (foundUser['fullName'] ?? 'User').toString());
      await prefs.setString('userRole', (foundUser['role'] ?? _selectedRole).toString());

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      _showMessage('লগইন করতে সমস্যা হয়েছে, আবার চেষ্টা করুন');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1F44),
              Color(0xFF132E5E),
              Color(0xFF0A1F44),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: const Color(0xFFD4AF6A).withOpacity(0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 96,
                          height: 96,
                          color: const Color(0xFF0A1F44),
                          child: const Center(
                            child: Text(
                              'K',
                              style: TextStyle(
                                color: Color(0xFFD4AF6A),
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'KORMI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 7,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Color(0xFFD4AF6A),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Spinning Mill Management System',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 26),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.20),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'আপনার Card Number / Email আর Password দিন',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Card Number / Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _idController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Card Number / Email লিখুন',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
                          prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFFD4AF6A)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.20)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.20)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFD4AF6A), width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Password লিখুন',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFD4AF6A)),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white70,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.20)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.20)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFD4AF6A), width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Role',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.20)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedRole,
                            dropdownColor: const Color(0xFF0A1F44),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFD4AF6A)),
                            items: _roles.map((String role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedRole = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF6A),
                            foregroundColor: const Color(0xFF0A1F44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 6,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF0A1F44),
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'নতুন অ্যাকাউন্ট লাগবে? ',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Color(0xFFD4AF6A),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  '© KORMI Spinning Mill • All Rights Reserved',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
