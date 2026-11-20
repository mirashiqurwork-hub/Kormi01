// Manpower Service - ম্যানপাওয়ার গণনা
// Sections Fixed: Back / Ring / A/Cone - সব Unit / Shift এ একই।
// গণনা: Attendance Active + Present শুধু। Absent / Off বাদ।

import 'package:hive/hive.dart';
import 'attendance_service.dart';
import 'worker_service.dart';

class ManpowerService {
  // এক Unit / Shift / Date এর Manpower
  static Future<Map<String, int>> getManpower({
    required String companyId,
    required String unit,
    required String shift, // Permanent Shift P/A, P/B, P/C
    required String date,
  }) async {
    final workers = await WorkerService.getWorkers(companyId: companyId, unit: unit, shift: shift, limit: 1000);
    final att = await AttendanceService.getAttendance(unit: unit, shift: shift, date: date);

    int back = 0;
    int ring = 0;
    int aCone = 0;

    for (final w in workers) {
      if (w['status'] != 'Active') continue;
      final card = w['card']?.toString() ?? '';
      if (att[card] != 'Present') continue; // শুধু Present
      final section = w['section']?.toString() ?? '';
      if (section == 'Back') back++;
      if (section == 'Ring') ring++;
      if (section == 'A/Cone') aCone++;
    }

    return {
      'Back': back,
      'Ring': ring,
      'A/Cone': aCone,
      'Total': back + ring + aCone,
    };
  }

  // Manpower Save - Share এর জন্য
  static Future<void> saveManpower({
    required String companyId,
    required String unit,
    required String shift,
    required String runningShift,
    required String date,
    required Map<String, int> counts,
  }) async {
    final box = await Hive.openBox('kormi_manpower');
    final key = '${date}_${unit}_${shift}_$runningShift';
    await box.put(key, {
      'companyId': companyId,
      'unit': unit,
      'shift': shift,
      'runningShift': runningShift,
      'date': date,
      'counts': counts,
      'time': DateTime.now().toIso8601String(),
    });
  }
}
