// App Constants - সব রঙ + নাম এক জায়গায়
// Navy #0A1D3F + Champagne Gold #C9A961 / #D4AF37 - এই ডিজাইনই থাকবে।

import 'package:flutter/material.dart';

class AppConstants {
  static const Color navy = Color(0xFF0A1D3F);
  static const Color navyLight = Color(0xFF0A2A5A);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldDark = Color(0xFFC9A961);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Status রঙ
  static const Color presentGreen = Colors.green;
  static const Color absentRed = Colors.red;
  static const Color pendingYellow = Colors.amber;
  static const Color urgentGold = Color(0xFFD4AF37);

  static const String appName = 'KORMI';
  static const String appSub = 'স্পিনিং মিল ওয়ার্কফোর্স';

  // Hive Boxes
  static const String boxCompanies = 'kormi_companies';
  static const String boxWorkers = 'kormi_workers';
  static const String boxAttendance = 'kormi_attendance';
  static const String boxProduction = 'kormi_production';
  static const String boxMessages = 'kormi_messages';
  static const String boxSettings = 'kormi_settings';

  // Sections - সব Unit / Shift এ একই
  static const List<String> sections = ['Back', 'Ring', 'A/Cone'];

  // Roles
  static const List<String> roles = ['Admin', 'Management', 'Officer', 'Worker'];

  // Units
  static const List<String> units = ['Unit 1', 'Unit 2', 'Unit 3'];

  // Permanent Shifts
  static const List<String> permanentShifts = ['P/A', 'P/B', 'P/C'];

  // Running Shifts
  static const List<String> runningShifts = ['R/A', 'R/B', 'R/C'];

  // Bottom Bar ডিফল্ট - Admin বদলাতে পারবে, max 5টা
  static const List<String> bottomBarDefault = ['Home', 'Production', 'Team', 'Profile'];
}
