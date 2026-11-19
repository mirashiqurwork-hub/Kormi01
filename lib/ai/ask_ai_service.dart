// ASK AI - ১০০% ফ্রি সার্ভিস
// এই ফাইলে কোনো API Key নাই, কোনো ইন্টারনেট লাগে না, কোনো টাকা লাগে না।
// AI সরাসরি ফোনের Hive বক্স থেকে পড়ে উত্তর দেয়।

import 'package:hive/hive.dart';

// ASK AI-এর মাথা
class AskAiService {
  // প্রশ্ন করলেই এই ফাংশন উত্তর দিবে
  // myRole = Admin / Management / Officer / Worker
  // myUnit, myShift = যেই Officer প্রশ্ন করতেছে, তার নিজের Unit / Shift
  String getAnswer({
    required String question,
    required String myRole,
    required String myUnit,
    required String myShift,
    required String myCompanyId,
  }) {
    // বাংলা প্রশ্নকে ছোট হাতের মতো করে নিই, যাতে মিলাতে সুবিধা হয়
    final q = question.trim();

    // ১. প্রোডাকশন চাইলে
    if (q.contains('প্রোডাকশন') || q.contains('উৎপাদন')) {
      return _answerProduction(q, myRole, myUnit, myShift, myCompanyId);
    }

    // ২. ফোন নম্বর চাইলে
    if (q.contains('ফোন') || q.contains('নম্বর') || q.contains('মোবাইল')) {
      return _answerWorkerPhone(q, myRole, myUnit, myShift, myCompanyId);
    }

    // ৩. কতজন লোক / ম্যানপাওয়ার চাইলে
    if (q.contains('কতজন') || q.contains('ম্যানপাওয়ার') || q.contains('লোক')) {
      return _answerManpower(q, myRole, myUnit, myShift, myCompanyId);
    }

    // কিছুই না মিললে
    return 'দুঃখিত, আমি এইটা বুঝতে পারিনি। আবার একটু সহজ করে বলুন, যেমন - ১০ তারিখের প্রোডাকশন দাও।';
  }

  // প্রোডাকশনের উত্তর
  String _answerProduction(
    String q,
    String myRole,
    String myUnit,
    String myShift,
    String myCompanyId,
  ) {
    // Officer অন্য Unit-এর ডাটা চাইলে দিবো না, এটাই পারমিশন
    if (myRole == 'Officer' && q.contains('ইউনিট') && !q.contains(myUnit)) {
      return 'এই ডাটা আপনার দেখার অনুমতি নাই। আপনি শুধু নিজের Unit-এর ডাটা দেখতে পারবেন।';
    }

    // প্রোডাকশন বক্স থেকে পড়ি
    final box = Hive.box('kormi_production');
    double total = 0;

    // সব এন্ট্রি ঘুরে দেখি, শুধু নিজের কোম্পানিরটা যোগ করি
    for (var i = 0; i < box.length; i++) {
      final item = box.getAt(i) as Map;
      if (item['companyId'] == myCompanyId) {
        total += (item['kg'] as num).toDouble();
      }
    }

    return 'আপনার কোম্পানির মোট প্রোডাকশন এখন পর্যন্ত $total কেজি। তারিখ দিয়ে বললে ওই তারিখেরটা দিবো, যেমন - ১০ তারিখের প্রোডাকশন দাও।';
  }

  // শ্রমিকের ফোন নম্বরের উত্তর
  String _answerWorkerPhone(
    String q,
    String myRole,
    String myUnit,
    String myShift,
    String myCompanyId,
  ) {
    // শ্রমিক শুধু নিজের নম্বর জানতে পারবে
    if (myRole == 'Worker') {
      return 'আপনি শুধু নিজের তথ্য দেখতে পারবেন।';
    }

    // শ্রমিক বক্স থেকে খুঁজি
    final box = Hive.box('kormi_workers');

    for (var i = 0; i < box.length; i++) {
      final worker = box.getAt(i) as Map;
      final name = worker['name'].toString();

      // প্রশ্নে যেই নাম আছে, ওই নাম মিললে
      if (q.contains(name)) {
        // Officer হলে শুধু নিজের Unit / Shift-এর শ্রমিকের নম্বর দিবো
        if (myRole == 'Officer' &&
            (worker['unit'] != myUnit || worker['shift'] != myShift)) {
          return 'এই শ্রমিক আপনার Shift-এর না, তাই নম্বর দিতে পারবো না।';
        }
        return '$name এর ফোন নম্বর হলো ${worker['phone']}';
      }
    }

    return 'এই নামে কোনো শ্রমিক পেলাম না। নামটা ঠিক করে আবার বলুন।';
  }

  // ম্যানপাওয়ার / কতজন লোক-এর উত্তর
  String _answerManpower(
    String q,
    String myRole,
    String myUnit,
    String myShift,
    String myCompanyId,
  ) {
    // হাজিরা বক্স থেকে গুনি
    final box = Hive.box('kormi_attendance');
    int present = 0;

    for (var i = 0; i < box.length; i++) {
      final item = box.getAt(i) as Map;
      if (item['companyId'] == myCompanyId && item['status'] == 'Present') {
        // Officer হলে শুধু নিজের Unit / Shift গুনবো
        if (myRole == 'Officer') {
          if (item['unit'] == myUnit && item['shift'] == myShift) {
            present++;
          }
        } else {
          present++;
        }
      }
    }

    return 'এখন পর্যন্ত হাজির আছে $present জন। তারিখ আর Unit বললে ওইটারটা ঠিক করে দিবো।';
  }

  // ভয়েসে প্রোডাকশন এন্ট্রি বুঝা, যেমন - কার্ডিং ১২০০ কেজি
  // এটা কোনো টাকা লাগা সার্ভারে যায় না, ফোনেই বুঝে
  Map<String, dynamic> parseProductionVoice(String voice) {
    // পরে এইখানে কার্ডিং, ড্রয়িং, সিমপ্লেক্স, রিং, ওয়াইন্ডিং শব্দ খুঁজে সংখ্যা বের করবো
    return {
      'rawVoice': voice, // যা বলছে, ওইটাই রাখি
      'needConfirm': true, // সেভ করার আগে তোমাকে দেখিয়ে কনফার্ম নিবো
    };
  }

  // ভয়েসে ম্যানপাওয়ার এন্ট্রি বুঝা, যেমন - ব্যাক সাইডে ১২ জন, রিং-এ ১৩ জন
  Map<String, dynamic> parseManpowerVoice(String voice) {
    return {
      'rawVoice': voice,
      'needConfirm': true, // সেভ করার আগে সামারি দেখাবো
    };
  }
}
