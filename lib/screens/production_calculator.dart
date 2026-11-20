import 'package:flutter/material.dart';
import '../database/kormi_database.dart';

class ProductionCalculator {
  static double calculateEfficiency(double target, double actual) {
    if (target == 0) {
      return 0;
    }
    return (actual / target) * 100;
  }

  static double calculateWastePercentage(double actual, double waste) {
    if (actual == 0) {
      return 0;
    }
    return (waste / actual) * 100;
  }

  static double calculateNetProduction(double actual, double waste) {
    final double net = actual - waste;
    if (net < 0) {
      return 0;
    }
    return net;
  }

  static double calculateTargetForShift(String shift, double baseTarget) {
    if (shift == 'Shift A') {
      return baseTarget;
    } else if (shift == 'Shift B') {
      return baseTarget;
    } else if (shift == 'Shift C') {
      return baseTarget * 0.9;
    } else {
      return baseTarget;
    }
  }

  static double calculateOvertimePay(double hourlyRate, double overtimeHours) {
    return hourlyRate * 1.5 * overtimeHours;
  }

  static Map<String, double> calculateSummary({
    required double target,
    required double actual,
    required double waste,
  }) {
    final double efficiency = calculateEfficiency(target, actual);
    final double wastePercentage = calculateWastePercentage(actual, waste);
    final double net = calculateNetProduction(actual, waste);
    return {
      'efficiency': efficiency,
      'wastePercentage': wastePercentage,
      'net': net,
    };
  }

  static Future<void> saveProduction(Map<String, dynamic> data) async {
    await KormiDatabase.saveProduction(data);
  }

  static Future<void> saveWithCalculation({
    required String machine,
    required String shift,
    required double target,
    required double actual,
    required double waste,
  }) async {
    final double efficiency = calculateEfficiency(target, actual);
    final double net = calculateNetProduction(actual, waste);
    final double wastePercentage = calculateWastePercentage(actual, waste);

    final Map<String, dynamic> data = {
      'machine': machine,
      'shift': shift,
      'target': target,
      'actual': actual,
      'waste': waste,
      'efficiency': efficiency,
      'net': net,
      'wastePercentage': wastePercentage,
      'date': DateTime.now().toIso8601String(),
    };

    await KormiDatabase.saveProduction(data);
  }

  static String getEfficiencyLabel(double efficiency) {
    if (efficiency >= 95) {
      return 'Excellent';
    } else if (efficiency >= 85) {
      return 'Good';
    } else if (efficiency >= 70) {
      return 'Average';
    } else {
      return 'Low';
    }
  }

  static Color getEfficiencyColor(double efficiency) {
    if (efficiency >= 85) {
      return const Color(0xFF2E7D32);
    } else if (efficiency >= 70) {
      return const Color(0xFFE65100);
    } else {
      return const Color(0xFFC62828);
    }
  }
}
