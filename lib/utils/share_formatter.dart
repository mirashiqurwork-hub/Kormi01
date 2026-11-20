// Share Formatter - শেয়ার করার ফরমেট
// Manpower: UNIT, তারিখ, Shift P/B - R/C, সেকশন হিসাব, Total। + দিয়ে বাড়তি নম্বর হবে না।
// Production: প্রতি Shift আলাদা শেয়ার।

class ShareFormatter {
  // Manpower Share
  // উদাহরণ:
  // UNIT 1
  // তারিখ: 20-11-2026
  // Shift P/B - R/C
  // Back: 12
  // Ring: 20
  // A/Cone: 8
  // Total: 40
  static String formatManpower({
    required String unit,
    required String date,
    required String permanentShift, // P/A, P/B, P/C
    required String runningShift, // R/A, R/B, R/C
    required int back,
    required int ring,
    required int aCone,
  }) {
    final total = back + ring + aCone;
    return '''$unit
তারিখ: $date
Shift $permanentShift - $runningShift
Back: $back
Ring: $ring
A/Cone: $aCone
Total: $total''';
  }

  // Production Share - এক Shift এর
  // উদাহরণ:
  // UNIT 1 - Shift B
  // তারিখ: 20-11-2026
  // Carding: 1200 Kg
  // Drawing: 1150 Kg
  // ...
  static String formatProduction({
    required String unit,
    required String date,
    required String shift,
    required Map<String, String> machines, // {'Carding': '1200 Kg', 'Drawing': '1150 Kg'}
  }) {
    final buffer = StringBuffer();
    buffer.writeln(unit);
    buffer.writeln('তারিখ: $date');
    buffer.writeln('Shift: $shift');
    buffer.writeln('----------------');
    machines.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    return buffer.toString().trim();
  }

  // Attendance Share
  static String formatAttendance({
    required String unit,
    required String date,
    required String shift,
    required int present,
    required int absent,
    required int off,
  }) {
    return '''$unit
তারিখ: $date
Shift: $shift
Present: $present
Absent: $absent
Off: $off''';
  }

  // Breakdown Share
  static String formatBreakdown({
    required String unit,
    required String date,
    required String machine,
    required String reason,
    required String duration,
  }) {
    return '''$unit
তারিখ: $date
মেশিন: $machine
কারণ: $reason
বন্ধ ছিল: $duration''';
  }
}
