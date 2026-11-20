// OCR Service - ক্যামেরা / গ্যালারি থেকে লেখা তোলা
// সব জায়গায় ক্যামেরা আইকন থাকবে। টিপ দিলে Gallery Photo + Take Photo আসবে।

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OcrService {
  static final ImagePicker _picker = ImagePicker();

  // ক্যামেরা / গ্যালারি বেছে নেওয়ার Bottom Sheet
  static Future<String?> pickImageWithChoice(BuildContext context) async {
    String? result;
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFFD4AF37)),
              title: const Text('Gallery থেকে ছবি নিন'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
                if (file != null) result = file.path;
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFD4AF37)),
              title: const Text('ছবি তুলুন'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? file = await _picker.pickImage(source: ImageSource.camera);
                if (file != null) result = file.path;
              },
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.red),
              title: const Text('বাতিল'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
    return result;
  }

  // OCR - এখন ডেমো, পরে আসল OCR লাইব্রেরি লাগবে
  // এই ফাংশন ছবি থেকে টেক্সট বের করে Preview দেখাবে, ইউজার Edit করে Save করবে।
  static Future<List<String>> extractLines(String imagePath) async {
    // TODO: google_mlkit_text_recognition যোগ করলে এখানে আসল OCR হবে
    // এখন খালি লিস্ট ফেরত দিচ্ছি, যাতে অ্যাপ আটকে না থাকে
    return [];
  }

  // Absent List / Present List থেকে নাম আলাদা করা
  // নিয়ম: Present List এ যারা আছে তারা Present, বাকি সবাই Absent। Off আগের মতো Off থাকবে।
  static Map<String, List<String>> splitPresentAbsent({
    required List<String> allCards,
    required List<String> presentCards,
    required List<String> offCards,
  }) {
    final present = <String>[];
    final absent = <String>[];
    for (final card in allCards) {
      if (offCards.contains(card)) continue;
      if (presentCards.contains(card)) {
        present.add(card);
      } else {
        absent.add(card);
      }
    }
    return {'present': present, 'absent': absent};
  }
}
