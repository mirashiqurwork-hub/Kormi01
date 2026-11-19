// KORMI - Main File
// এই ফাইল থেকে অ্যাপ চালু হয়। Android + iOS + Computer, ৩টাতেই এই একই ফাইল চলে।

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// KORMI রঙ - Navy + Champagne Gold
// সব স্ক্রিনে এই একই রঙ থাকবে, যাতে দেখতে একরকম লাগে।
class KormiColors {
  static const navy = Color(0xFF0A1A2F); // গাঢ় নীল, ব্যাকগ্রাউন্ড
  static const gold = Color(0xFFD4AF37); // শ্যাম্পেইন গোল্ড, বাটন
  static const white = Color(0xFFFFFFFF);
  static const green = Color(0xFF2ECC71); // হাজির
  static const red = Color(0xFFE74C3C); // অনুপস্থিত
  static const yellow = Color(0xFFF1C40F); // Pending
}

// সেটিংস - ফন্ট সাইজ, পরে প্রোফাইল থেকে বদলানো যাবে
class AppSettings extends ChangeNotifier {
  double fontSize = 16; // সাধারণ মানুষের জন্য বড় লেখা
  void setFontSize(double size) {
    fontSize = size;
    notifyListeners();
  }
}

// অ্যাপ চালু হওয়ার জায়গা
void main() async {
  // Flutter চালু হওয়ার আগে এই লাইন লাগে
  WidgetsFlutterBinding.ensureInitialized();

  // Hive চালু করি - ফোন / কম্পিউটারে ডাটা রাখার জায়গা
  await Hive.initFlutter();

  // ডিসিপ্লিন ভাবে আলাদা আলাদা বক্স খুলি, যাতে ডাটা না মিশে
  await Hive.openBox('kormi_companies'); // কোম্পানি / মিল
  await Hive.openBox('kormi_workers'); // শ্রমিকের তালিকা
  await Hive.openBox('kormi_attendance'); // হাজিরা
  await Hive.openBox('kormi_production'); // প্রোডাকশন
  await Hive.openBox('kormi_messages'); // মেসেজ
  await Hive.openBox('kormi_settings'); // সেটিংস

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettings(),
      child: const KormiApp(),
    ),
  );
}

// পুরো অ্যাপের ডিজাইন এখানে
class KormiApp extends StatelessWidget {
  const KormiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KORMI',
      debugShowCheckedModeBanner: false, // উপরে DEBUG লেখা দেখাবে না
      theme: ThemeData(
        primaryColor: KormiColors.navy,
        scaffoldBackgroundColor: KormiColors.navy,
        // বাংলা ফন্ট, যাতে সাধারণ মানুষ সহজে পড়তে পারে
        textTheme: GoogleFonts.hindSiliguriTextTheme(),
        colorScheme: const ColorScheme.dark(
          primary: KormiColors.gold,
          surface: KormiColors.navy,
        ),
      ),
      home: const LoginScreen(), // প্রথমে লগইন স্ক্রিন আসবে
    );
  }
}

// লগইন স্ক্রিন - সহজ করে বানানো, বড় বাটন + বাংলা লেখা
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // লোগো জায়গা, পরে ফ্যাক্টরি + চিমনির ধোঁয়া আসবে
              const Icon(Icons.factory, size: 70, color: KormiColors.gold),
              const SizedBox(height: 12),
              const Text(
                'KORMI',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: KormiColors.gold,
                ),
              ),
              const Text(
                'স্পিনিং মিল ওয়ার্কফোর্স',
                style: TextStyle(fontSize: 18, color: KormiColors.white),
              ),
              const SizedBox(height: 30),
              // কার্ড নম্বর / আইডি লেখার জায়গা
              const TextField(
                decoration: InputDecoration(
                  labelText: 'কার্ড নম্বর / আইডি',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 12),
              // পাসওয়ার্ড লেখার জায়গা
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'পাসওয়ার্ড',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),
              // বড় লগইন বাটন
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KormiColors.gold,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    // File 3-এ আসল লগইন লজিক আসবে
                  },
                  child: const Text(
                    'লগইন',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Admin: ADMIN / ADMIN123',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
