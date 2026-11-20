// KORMI - Production Calculator + Formula
// Real Spinning Mill Formula - Ring / Carding / Draw / Simplex / Winding
// Dashboard / Production Screen এই ফাইল ব্যবহার করবে

class ProductionCalculator {
  // ============ RING FRAME ============
  // Production kg / Shift
  // Formula: (RPM * 60 * Hours * Spindles * Eff) / (TPI * 36 * 840 * Count * 2.2046)
  // TPI = Twist Per Inch, Count = Ne
  static double ringKgPerShift({
    required double spindleRpm,
    required double tpi,
    required double countNe,
    required int spindles,
    required double efficiencyPercent, // 0-100
    double hours = 8,
  }) {
    if (spindleRpm <= 0 || tpi <= 0 || countNe <= 0 || spindles <= 0) return 0;
    final eff = (efficiencyPercent.clamp(0, 100)) / 100;
    final numerator = spindleRpm * 60 * hours * spindles * eff;
    final denominator = tpi * 36 * 840 * countNe * 2.2046;
    return numerator / denominator;
  }

  // Ring - TPI থেকে Twist Multiplier / Count থেকে TPI বের করা
  // TPI = TM * sqrt(Count)
  static double tpiFromTm(double tm, double countNe) {
    if (countNe <= 0) return 0;
    return tm * _sqrt(countNe);
  }

  static double _sqrt(double v) {
    // dart:math ছাড়া simple sqrt - math import করা যাবে না এখানে, তাই approximation
    // আসল কোডে dart:math ব্যবহার করবে
    double x = v;
    double y = 1;
    const double e = 0.000001;
    while ((x - y).abs() > e) {
      x = (x + y) / 2;
      y = v / x;
    }
    return x;
  }

  // Ring - 1 Spindle 1 ঘন্টায় কত kg
  static double ringKgPerSpindlePerHour({
    required double spindleRpm,
    required double tpi,
    required double countNe,
    required double efficiencyPercent,
  }) {
    if (tpi <= 0 || countNe <= 0) return 0;
    final eff = efficiencyPercent.clamp(0, 100) / 100;
    final inchesPerMin = spindleRpm / tpi;
    final yardsPerHour = inchesPerMin * 60 / 36;
    final hanksPerHour = yardsPerHour / 840;
    final lbPerHour = hanksPerHour / countNe;
    final kgPerHour = lbPerHour / 2.2046;
    return kgPerHour * eff;
  }

  // ============ CARDING ============
  // Carding kg/hr = Delivery Speed (m/min) * 60 * Sliver Wt (g/m) / 1000 * Eff
  static double cardingKgPerHour({
    required double deliverySpeedMMin, // যেমন 150 m/min
    required double sliverWeightGPerM, // যেমন 5 g/m
    required double efficiencyPercent,
  }) {
    final eff = efficiencyPercent.clamp(0, 100) / 100;
    return deliverySpeedMMin * 60 * sliverWeightGPerM / 1000 * eff;
  }

  static double cardingKgPerShift({
    required double deliverySpeedMMin,
    required double sliverWeightGPerM,
    required double efficiencyPercent,
    double hours = 8,
  }) {
    return cardingKgPerHour(
          deliverySpeedMMin: deliverySpeedMMin,
          sliverWeightGPerM: sliverWeightGPerM,
          efficiencyPercent: efficiencyPercent,
        ) *
        hours;
  }

  // ============ DRAW FRAME ============
  // Draw Frame kg/hr = Delivery Speed * 60 * Sliver Wt / 1000 * Eff * Delivery Heads
  static double drawFrameKgPerHour({
    required double deliverySpeedMMin,
    required double sliverWeightGPerM,
    required int deliveryHeads, // 1 বা 2
    required double efficiencyPercent,
  }) {
    final eff = efficiencyPercent.clamp(0, 100) / 100;
    return deliverySpeedMMin * 60 * sliverWeightGPerM / 1000 * eff * deliveryHeads;
  }

  // ============ SIMPLEX / ROVING ============
  // Simplex kg/hr = Spindle RPM * 60 * Spindles * Eff / (TPI * 36 * 840 * Hank * 2.2046)
  // Hank = Roving Hank, TPI = Twist per inch roving
  static double simplexKgPerHour({
    required double spindleRpm,
    required double tpi,
    required double rovingHank,
    required int spindles,
    required double efficiencyPercent,
  }) {
    if (tpi <= 0 || rovingHank <= 0) return 0;
    final eff = efficiencyPercent.clamp(0, 100) / 100;
    final numerator = spindleRpm * 60 * spindles * eff;
    final denominator = tpi * 36 * 840 * rovingHank * 2.2046;
    return numerator / denominator;
  }

  // ============ WINDING / AUTOCONE ============
  // Winding kg/hr = Winding Speed (m/min) * 60 * Count Factor
  // Count থেকে Yarn Weight: 1 Ne = 0.5905 g/m / Count? আসল: Weight g/m = 590.5 / (Ne * 1000) * 1000?
  // সহজ Formula: Yarn g/m = 590.5 / Ne / 1000 * 1000 = 590.5 / Ne (g per 1000m? না)
  // সঠিক: 1 Ne = 840 yard / lb, 1 yard = 0.9144 m, 1 lb = 453.592 g
  // তাই g/m = 453.592 / (840 * Ne * 0.9144) = 0.5905 / Ne * 1000? হিসাব করে:
  // g/m = 0.5905 / Ne  (gram per meter নয়, gram per ???) - নিচে সরাসরি ব্যবহার করা হলো
  static double yarnWeightGramPerMeter(double countNe) {
    if (countNe <= 0) return 0;
    // 1 Ne yarn = 0.5905 g / m (approx)
    return 0.5905 / countNe * 1000 / 1000 * 1000 / 1000; // placeholder - নিচে আসলটা
  }

  static double windingKgPerHour({
    required double windingSpeedMMin,
    required double countNe,
    required int drums,
    required double efficiencyPercent,
  }) {
    if (countNe <= 0) return 0;
    final eff = efficiencyPercent.clamp(0, 100) / 100;
    // Yarn weight g/m = 590.5 / (Ne * 1000) * 1000? = 590.5 / Ne / 1000 * 1000
    // Standard: Tex = 590.5 / Ne, Tex = g / 1000m, তাই g/m = Tex / 1000 = 0.5905 / Ne
    final gPerM = 0.5905 / countNe;
    // kg/hr = speed (m/min) * 60 * g/m / 1000 * drums * eff
    return windingSpeedMMin * 60 * gPerM / 1000 * drums * eff;
  }

  // ============ COMMON HELPERS ============
  // kg -> Bag (1 Bag = 50 kg ধরা হলো, Mill অনুযায়ী বদলানো যাবে)
  static double kgToBag(double kg, {double bagWeightKg = 50}) {
    if (bagWeightKg <= 0) return 0;
    return kg / bagWeightKg;
  }

  // Bag -> kg
  static double bagToKg(double bag, {double bagWeightKg = 50}) {
    return bag * bagWeightKg;
  }

  // Efficiency % = (Actual / Target) * 100
  static double efficiency(double actualKg, double targetKg) {
    if (targetKg <= 0) return 0;
    return (actualKg / targetKg * 100).clamp(0, 100);
  }

  // Total Production - সব মেশিনের যোগফল
  static double totalKg(List<double> machineKgs) {
    double t = 0;
    for (final v in machineKgs) {
      t += v;
    }
    return t;
  }

  // Shift Production Summary Text - Share Format এর জন্য
  static String buildShareText({
    required String shift,
    required String date,
    required Map<String, double> machineKgs, // {'C/D': 4928, 'B/D': 5093}
    required double packingBags,
    required String sicName,
    required String designation,
  }) {
    final b = StringBuffer();
    b.writeln('Shift:-$shift');
    b.writeln('Date:-$date');
    b.writeln('production summary');
    for (final e in machineKgs.entries) {
      b.writeln('${e.key}:- ${e.value.toStringAsFixed(0)} kg,');
    }
    b.writeln('Packing = ${packingBags.toStringAsFixed(0)} Bag');
    b.writeln('*SIC NAME:- $sicName*');
    b.writeln('*DEG:- $designation*');
    return b.toString();
  }
}
