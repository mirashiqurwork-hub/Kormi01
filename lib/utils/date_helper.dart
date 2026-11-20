// Date Helper - তারিখ ফরমেট
// সব জায়গায় একই ফরমেট: DD-MM-YYYY

class DateHelper {
  // DateTime -> 20-11-2026
  static String format(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d-$m-$y';
  }

  // 20-11-2026 -> YYYY-MM-DD (Hive Key এর জন্য)
  static String toKey(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$y-$m-$d';
  }

  // আজকের তারিখ
  static String today() {
    return format(DateTime.now());
  }

  static String todayKey() {
    return toKey(DateTime.now());
  }

  // শুক্রবার কিনা - সাপ্তাহিক ছুটি
  static bool isFriday(DateTime date) {
    return date.weekday == DateTime.friday;
  }

  // বাংলা সংখ্যা - 0-9 -> ০-৯
  static String toBanglaNumber(String input) {
    const eng = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const ban = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    String result = input;
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(eng[i], ban[i]);
    }
    return result;
  }

  // English সংখ্যা - ০-৯ -> 0-9
  static String toEnglishNumber(String input) {
    const eng = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const ban = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    String result = input;
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(ban[i], eng[i]);
    }
    return result;
  }
}
