// Gboard Mic Button
// গুগল কিবোর্ডের মতো মাইক বাটন।
// ASK AI সহ যেকোনো জায়গায় এই একই বাটন থাকবে।

import 'package:flutter/material.dart';

// গুগল কিবোর্ডের মতো মাইক বাটন
class GboardMicButton extends StatelessWidget {
  const GboardMicButton({
    super.key,
    required this.onTap, // টিপ দিলে কী হবে
    required this.isListening, // এখন শুনতেছে কিনা
  });

  // টিপ দিলে এই ফাংশন চলবে
  final VoidCallback onTap;

  // true মানে এখন শুনতেছে, লাল হয়ে থাকবে
  final bool isListening;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // টিপ দিলে মাইক চালু হবে
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // চাপ দিলে একটু নড়বে
        width: 64, // গুগল কিবোর্ডের মতো বড় রাখছি, আঙুলে লাগবে
        height: 64,
        decoration: BoxDecoration(
          // শুনতেছে না থাকলে সাদা / হালকা ধূসর, গুগল কিবোর্ডের মতো
          // শুনতেছে থাকলে লাল, যাতে বুঝা যায় রেকর্ড হচ্ছে
          color: isListening ? Colors.red : const Color(0xFFF1F3F4),
          shape: BoxShape.circle, // গোল বাটন
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        // মাঝখানে মাইক আইকন, গুগল কিবোর্ডের মতোই
        // উপরে গোল ক্যাপসুল, নিচে U আকৃতির হোল্ডার + ছোট স্ট্যান্ড
        child: Icon(
          isListening ? Icons.stop : Icons.mic, // শুনলে স্টপ, না শুনলে মাইক
          color: isListening ? Colors.white : const Color(0xFF3C4043),
          size: 32, // বড় করে রাখছি, যাতে দূর থেকেও দেখা যায়
        ),
      ),
    );
  }
}

// এই বাটনটা ASK AI স্ক্রিনে এইভাবে বসাবা:
// GboardMicButton(
//   onTap: _startListening, // মাইক চালু করার ফাংশন
//   isListening: _isListening, // শুনতেছে কিনা
// )
