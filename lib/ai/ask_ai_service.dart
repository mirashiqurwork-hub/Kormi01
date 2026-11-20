import 'package:hive_flutter/hive_flutter.dart';

class AskAiService {
  static Box? _box;

  static Future<void> init() async {
    if (Hive.isBoxOpen('ask_ai_box')) {
      _box = Hive.box('ask_ai_box');
    } else {
      _box = await Hive.openBox('ask_ai_box');
    }
  }

  static Future<void> _ensureBox() async {
    if (_box == null) {
      await init();
    }
  }

  static Future<String> askQuestion(String question) async {
    await _ensureBox();
    final String q = question.toLowerCase();
    String answer = '';

    if (q.contains('attendance') || q.contains('hajira')) {
      answer = 'Attendance দেখতে Attendance ট্যাবে যাও। সেখানে প্রতিদিনের Present / Absent / Late এর হিসাব পাবা।';
    } else if (q.contains('salary') || q.contains('beton') || q.contains('bdt')) {
      answer = 'Salary হিসাব Workers প্রোফাইলে পাবা। Basic + Overtime + Bonus মিলিয়ে Total Salary হিসাব হয়।';
    } else if (q.contains('production') || q.contains('utpadon')) {
      answer = 'Production দেখতে Production ট্যাবে যাও। সেখানে Shift অনুযায়ী Target vs Actual Production দেখতে পাবা।';
    } else if (q.contains('worker') || q.contains('kormi') || q.contains('kormi')) {
      answer = 'Workers দেখতে Workers ট্যাবে যাও। সেখানে Card Number দিয়ে Search করে যেকোনো Worker এর ডিটেইলস দেখতে পাবা।';
    } else if (q.contains('breakdown') || q.contains('machine') || q.contains('nusto')) {
      answer = 'Breakdown রিপোর্ট করতে Breakdown ট্যাবে যাও। Machine Number, Reason আর Time দিয়ে রিপোর্ট জমা দাও।';
    } else if (q.contains('leave') || q.contains('chuti')) {
      answer = 'Leave এর জন্য Admin কে জানাও। Admin Panel থেকে Leave Approve করা হয়।';
    } else if (q.contains('hello') || q.contains('hi') || q.contains('salam') || q.contains('assalam')) {
      answer = 'Assalamualaikum! আমি KORMI Assistant। Attendance, Salary, Production, Workers নিয়ে যেকোনো প্রশ্ন করো।';
    } else {
      answer = 'তোমার প্রশ্নটা পাইছি: "$question"। এই বিষয়ে বিস্তারিত তথ্য Dashboard, Workers বা Production ট্যাবে পাবা। আরো স্পষ্ট করে লিখলে আমি আরো ভালো উত্তর দিতে পারবো।';
    }

    final List<dynamic> history = _box!.get('history', defaultValue: []) as List<dynamic>;
    history.add({
      'question': question,
      'answer': answer,
      'time': DateTime.now().toIso8601String(),
    });
    await _box!.put('history', history);

    return answer;
  }

  static List<Map<String, dynamic>> getHistory() {
    final List<dynamic> list = _box?.get('history', defaultValue: []) as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> clearHistory() async {
    await _ensureBox();
    await _box!.put('history', []);
  }
}
