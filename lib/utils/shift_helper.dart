// Shift Helper - Shift Rotation
// শুক্রবার Rotation। Permanent Shift নাম একই থাকবে, শুধু Running Shift ঘুরবে।
// নিয়ম: Night -> B, B -> সকাল, সকাল -> Night।

class ShiftHelper {
  // Permanent Shift: P/A, P/B, P/C
  // Running Shift: R/A (সকাল), R/B (B), R/C (Night)

  // একটা Running Shift এর পরেরটা কী হবে
  static String nextRunningShift(String current) {
    // current: R/A = সকাল, R/B = B, R/C = Night
    if (current == 'R/C') return 'R/B'; // Night -> B
    if (current == 'R/B') return 'R/A'; // B -> সকাল
    if (current == 'R/A') return 'R/C'; // সকাল -> Night
    return current;
  }

  // নাম দিয়ে দেখানো
  static String runningShiftName(String running) {
    if (running == 'R/A') return 'সকাল';
    if (running == 'R/B') return 'B';
    if (running == 'R/C') return 'Night';
    return running;
  }

  // Permanent থেকে Running এর ডিফল্ট মিলানো
  static String permanentToRunning(String permanent) {
    if (permanent == 'P/A') return 'R/A';
    if (permanent == 'P/B') return 'R/B';
    if (permanent == 'P/C') return 'R/C';
    return permanent;
  }

  // শুক্রবার কিনা চেক
  static bool isFriday(DateTime date) {
    return date.weekday == DateTime.friday;
  }

  // আজকের Running Shift বের করা - Rotation হিসাব
  // startDate: যেদিন থেকে Rotation শুরু, startRunning: ঐ দিনের Running
  static String runningForDate({
    required DateTime date,
    required DateTime startDate,
    required String startRunning,
  }) {
    // কয়টা শুক্রবার পার হইছে
    int fridays = 0;
    DateTime d = DateTime(startDate.year, startDate.month, startDate.day);
    final target = DateTime(date.year, date.month, date.day);
    while (d.isBefore(target)) {
      d = d.add(const Duration(days: 1));
      if (isFriday(d)) fridays++;
    }
    String result = startRunning;
    for (int i = 0; i < fridays; i++) {
      result = nextRunningShift(result);
    }
    return result;
  }

  // Share এর জন্য ফরমেট: Shift P/B - R/C
  static String formatShift(String permanent, String running) {
    return 'Shift $permanent - $running';
  }

  // সব Shift লিস্ট
  static List<String> get permanentList => ['P/A', 'P/B', 'P/C'];
  static List<String> get runningList => ['R/A', 'R/B', 'R/C'];
}
