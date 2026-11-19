// OCR Camera Button
// সব মডিউলে OCR-এর জন্য এই একই বাটন থাকবে।
// টিপ দিলে ২টা অপশন আসবে - গ্যালারি আর ক্যামেরা।

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// এই বাটনটা যেকোনো স্ক্রিনে বসানো যাবে
class OcrCameraButton extends StatelessWidget {
  const OcrCameraButton({
    super.key,
    required this.onImagePicked, // ছবি পাওয়ার পর এই ফাংশন চলবে
    this.label = 'OCR - ছবি দিয়ে এন্ট্রি',
  });

  // ছবি পাওয়ার পর কী হবে, যেই স্ক্রিনে বসাবো সেই স্ক্রিন ঠিক করবে
  final void Function(XFile? image) onImagePicked;

  // বাটনের পাশে কী লেখা থাকবে
  final String label;

  // টিপ দিলে নিচ থেকে ২টা অপশন দেখাই
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A1A2F), // Navy ব্যাকগ্রাউন্ড
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text(
                'ছবি কোথা থেকে নিবেন?',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 10),
              // অপশন ১ - গ্যালারি
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFD4AF37)),
                title: const Text(
                  'গ্যালারি থেকে ছবি নিন',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                onTap: () async {
                  Navigator.pop(context); // অপশন বন্ধ করি
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.gallery, // গ্যালারি থেকে
                  );
                  onImagePicked(image); // ছবি পাঠিয়ে দিই
                },
              ),
              // অপশন ২ - ক্যামেরা
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFD4AF37)),
                title: const Text(
                  'ছবি তুলুন',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                onTap: () async {
                  Navigator.pop(context); // অপশন বন্ধ করি
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.camera, // ক্যামেরা দিয়ে
                  );
                  onImagePicked(image); // ছবি পাঠিয়ে দিই
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showOptions(context), // টিপ দিলে ২টা অপশন আসবে
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFD4AF37), // Champagne Gold বাটন
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt, color: Colors.black, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
