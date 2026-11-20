// KORMI - Sheet OCR Service
// শিটের ছবি -> Text -> Production Data Auto Fill
// Camera / Gallery থেকে ছবি নিয়ে OCR করে C/D, B/D, F/D, S/F, R/F, L/C এর kg বের করে

class SheetOcrService {
  // OCR Text থেকে মেশিনের kg বের করা
  // Example OCR Text:
  // "C/D 4928 kg, B/D 5093, F/D 4651, S/F 3311, R/F 2867, L/C 2933"
  // বা "CD - 4928" / "C/D:- 4928 kg" সব ফরম্যাট চলবে
  static Map<String, double> parseProductionFromOcrText(String ocrText) {
    final result = <String, double>{};
    final text = ocrText.toUpperCase();

    // মেশিন কোডগুলো
    final machines = ['C/D', 'B/D', 'F/D', 'S/F', 'R/F', 'L/C'];

    for (final mc in machines) {
      final kg = _extractKgForMachine(text, mc);
      if (kg != null && kg > 0) {
        result[mc] = kg;
      }
    }

    // যদি C/D লেখা OCR এ CD হয়ে যায়, সেটাও ধরবে
    if (result.isEmpty) {
      final fallback = _fallbackParse(text);
      result.addAll(fallback);
    }

    return result;
  }

  static double? _extractKgForMachine(String text, String mc) {
    // C/D এর জন্য Pattern: C/D, CD, C-D, C D সব ধরবে
    String mcPattern = mc.replaceAll('/', r'[./\- ]?');
    // Pattern: MC + যেকোনো চিহ্ন + সংখ্যা
    // যেমন: C/D:- 4928 kg, C/D 4928, CD=4928
    final reg = RegExp('$mcPattern\\s*[:\\-=]*\\s*(\\d+[.,]?\\d*)', caseSensitive: false);
    final match = reg.firstMatch(text);
    if (match != null) {
      final numStr = match.group(1)?.replaceAll(',', '') ?? '';
      return double.tryParse(numStr);
    }
    return null;
  }

  static Map<String, double> _fallbackParse(String text) {
    final result = <String, double>{};
    // শুধু সংখ্যাগুলো ক্রম অনুযায়ী বসানো - C/D, B/D, F/D, S/F, R/F, L/C
    final numbers = RegExp(r'(\d{3,5})').allMatches(text).map((m) => double.tryParse(m.group(1) ?? '') ?? 0).toList();
    final machines = ['C/D', 'B/D', 'F/D', 'S/F', 'R/F', 'L/C'];
    for (int i = 0; i < numbers.length && i < machines.length; i++) {
      if (numbers[i] > 100) {
        result[machines[i]] = numbers[i];
      }
    }
    return result;
  }

  // Shift বের করা - P/A, P/B, P/C, P/B-R/C
  static String parseShiftFromOcrText(String ocrText) {
    final text = ocrText.toUpperCase();
    if (text.contains('P/B-R/C') || text.contains('P/B R/C') || text.contains('P/B-R')) return 'P/B-R/C';
    if (text.contains('P/A')) return 'P/A';
    if (text.contains('P/B')) return 'P/B';
    if (text.contains('P/C')) return 'P/C';
    return 'P/B-R/C';
  }

  // Date বের করা - 18.11.26 / 18/11/26 / 18-11-26
  static String? parseDateFromOcrText(String ocrText) {
    final reg = RegExp(r'(\d{1,2}[./-]\d{1,2}[./-]\d{2,4})');
    final m = reg.firstMatch(ocrText);
    return m?.group(1);
  }

  // Packing Bag বের করা - Packing = 96 Bag / Packing 96
  static double parsePackingBagFromOcrText(String ocrText) {
    final text = ocrText.toUpperCase();
    final reg = RegExp(r'PACKING\s*[:=\-]?\s*(\d+)');
    final m = reg.firstMatch(text);
    if (m != null) return double.tryParse(m.group(1) ?? '0') ?? 0;
    return 0;
  }

  // OCR Result Check - কতটা মেশিন পাওয়া গেলো
  static String ocrResultSummary(Map<String, double> parsed) {
    if (parsed.isEmpty) return 'কোনো Production Data পাওয়া যায়নি। ছবি পরিষ্কার করে আবার তুলুন।';
    final total = parsed.values.fold(0.0, (a, b) => a + b);
    return '${parsed.length} টা মেশিন পাওয়া গেছে। Total ${total.toStringAsFixed(0)} kg।';
  }

  // Demo OCR Text - Testing এর জন্য, আসল OCR লাগানোর আগে Test করতে পারবে
  static String demoOcrText() {
    return '''
Shift:-P/B-R/C
Date:-18.11.26
C/D:- 4928 kg
B/D:- 5093 kg
F/D:- 4651 kg
S/F:- 3311 kg
R/F:- 2867 kg
L/C:- 2933 kg
Packing = 96 Bag
''';
  }
}
