// ASK AI Brain - ১০০% ফ্রি
// বাংলা + ইংলিশ + বাঙলিশ, ৩টাই বুঝবে। অল্প বললেও পুরোটা বুঝে নিবে।
// কোনো API Key নাই, কোনো ইন্টারনেট লাগে না, কোনো টাকা লাগে না।

class AskAiBrain {
  // আগের কথা মনে রাখি, যাতে পরে ছোট করে বললেও বুঝতে পারে
  String lastDate = 'আজকে'; // কিছু না বললে আজকে ধরে নিবো
  String lastUnit = '';
  String lastShift = '';

  // বাংলা সংখ্যাকে ইংলিশ সংখ্যা বানাই, যেমন ১০ -> 10
  String _toEnglishNumber(String text) {
    const bangla = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    var result = text;
    for (var i = 0; i < bangla.length; i++) {
      result = result.replaceAll(bangla[i], english[i]);
    }
    return result;
  }

  // সব ভাষাকে এক ভাষায় নিয়ে আসি, যাতে বুঝতে সহজ হয়
  String normalize(String raw) {
    var t = raw.toLowerCase(); // বড় হাতের লেখা ছোট করে নিই
    t = _toEnglishNumber(t); // বাংলা সংখ্যা ইংলিশ করি

    // বাঙলিশ শব্দকে একই মানে নিয়ে আসি
    // যেমন prodakson, utpadon, production সবই প্রোডাকশন
    t = t.replaceAll('prodakson', 'production');
    t = t.replaceAll('prodaction', 'production');
    t = t.replaceAll('utpadon', 'production');
    t = t.replaceAll('উৎপাদন', 'production');
    t = t.replaceAll('প্রোডাকশন', 'production');

    // ফোনের যত নাম আছে, সব এক করি
    t = t.replaceAll('নম্বর', 'number');
    t = t.replaceAll('nombor', 'number');
    t = t.replaceAll('নাম্বার', 'number');
    t = t.replaceAll('ফোন', 'number');
    t = t.replaceAll('mobile', 'number');
    t = t.replaceAll('phone', 'number');

    // লোক / ম্যানপাওয়ার
    t = t.replaceAll('লোক', 'manpower');
    t = t.replaceAll('manpawer', 'manpower');
    t = t.replaceAll('কতজন', 'manpower');
    t = t.replaceAll('kotojon', 'manpower');

    // তারিখের শব্দ
    t = t.replaceAll('আজকে', 'today');
    t = t.replaceAll('ajke', 'today');
    t = t.replaceAll('গতকাল', 'yesterday');
    t = t.replaceAll('gotokal', 'yesterday');
    t = t.replaceAll('তারিখের', 'date');
    t = t.replaceAll('tarikher', 'date');
    t = t.replaceAll('tarikh', 'date');

    return t;
  }

  // সংখ্যা বের করি, যেমন - carding 1200 থেকে 1200 বের করি
  String _findNumber(String text) {
    final match = RegExp(r'(\d+)').firstMatch(text);
    if (match != null) {
      return match.group(1)!;
    }
    return '';
  }

  // তুমি কী চাইতেছো, ওইটা বুঝি
  // return করি - production_query, manpower_query, phone_query, production_entry, manpower_entry
  String findIntent(String raw, String myUnit, String myShift) {
    final t = normalize(raw);

    // ফোন নম্বর চাইলে, যেমন - ফাতেমা নম্বর, fatema number
    if (t.contains('number')) {
      return 'phone_query';
    }

    // ম্যানপাওয়ার চাইলে, যেমন - back 12, ring 13 / কতজন লোক
    if (t.contains('manpower')) {
      // সংখ্যা থাকলে বুঝবো এন্ট্রি করতে চাইতেছে, যেমন back 12
      if (RegExp(r'\d').hasMatch(t)) {
        return 'manpower_entry';
      }
      return 'manpower_query';
    }

    // প্রোডাকশন চাইলে
    if (t.contains('production')) {
      // সংখ্যা থাকলে এন্ট্রি, যেমন carding 1200
      if (RegExp(r'\d').hasMatch(t)) {
        return 'production_entry';
      }
      return 'production_query';
    }

    // শুধু সেকশনের নাম + সংখ্যা বললেও প্রোডাকশন এন্ট্রি ধরে নিবো
    // যেমন - carding 1200, drawing 1100, ring 900
    if (t.contains('carding') ||
        t.contains('drawing') ||
        t.contains('simplex') ||
        t.contains('ring') ||
        t.contains('winding') ||
        t.contains('back') ||
        t.contains('cone')) {
      if (RegExp(r'\d').hasMatch(t)) {
        return 'production_entry';
      }
    }

    return 'unknown';
  }

  // তারিখ, Unit, Shift না বললে নিজে ধরে নিই
  // যেমন তুমি শুধু বললা production dao, আমি ধরে নিবো আজকে, তোমার Unit, তোমার Shift
  Map<String, String> fillMissing(String raw, String myUnit, String myShift) {
    final t = normalize(raw);
    var date = lastDate;
    var unit = myUnit;
    var shift = myShift;

    // তারিখ বললে ওইটা নিই, যেমন 10 tarikher
    final num = _findNumber(t);
    if (t.contains('date') && num.isNotEmpty) {
      date = '$num তারিখ';
      lastDate = date; // মনে রাখলাম, পরে ছোট করে বললেও এই তারিখই ধরবো
    }
    if (t.contains('today')) {
      date = 'আজকে';
      lastDate = date;
    }

    // Unit বললে ওইটা নিই, যেমন unit 1
    if (t.contains('unit')) {
      if (num.isNotEmpty) {
        unit = num;
        lastUnit = unit;
      }
    }

    // Shift বললে ওইটা নিই, যেমন B shift, running A
    if (t.contains('b shift') || t.contains('b-shift')) {
      shift = 'B';
      lastShift = shift;
    }
    if (t.contains('a shift') || t.contains('a-shift')) {
      shift = 'A';
      lastShift = shift;
    }

    return {'date': date, 'unit': unit, 'shift': shift};
  }

  // ছোট করে বললেও পুরোটা বুঝে এক লাইনে উত্তর বানাই
  String smartReply(String raw, String myUnit, String myShift) {
    final intent = findIntent(raw, myUnit, myShift);
    final info = fillMissing(raw, myUnit, myShift);

    if (intent == 'production_query') {
      return 'ঠিক আছে, ${info['date']} এর প্রোডাকশনটা দেখতেছি, একটু দাঁড়ান।';
    }
    if (intent == 'phone_query') {
      return 'ঠিক আছে, নামটা দেখে ফোন নম্বরটা দিতেছি।';
    }
    if (intent == 'manpower_query') {
      return 'ঠিক আছে, ${info['date']} এ ${info['unit']} নম্বর Unit এ কতজন আসছে দেখতেছি।';
    }
    if (intent == 'production_entry') {
      return 'বুঝছি, প্রোডাকশন এন্ট্রি করতেছি। সেভ করার আগে একবার দেখিয়ে নিবো।';
    }
    if (intent == 'manpower_entry') {
      return 'বুঝছি, ম্যানপাওয়ার এন্ট্রি করতেছি। টোটাল সামারি বানিয়ে দেখাবো।';
    }

    return 'একটু সহজ করে আবার বলুন, যেমন - ১০ তারিখের প্রোডাকশন দাও।';
  }
}
