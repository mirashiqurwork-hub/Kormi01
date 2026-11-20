// Message Service - মেসেজ
// 1-1 + গ্রুপ, টেক্সট, ভয়েস, ছবি, ভিডিও, ফাইল, লাইভ লোকেশন। 1 টিক Sent, 2 টিক Delivered, 2 নীল টিক Read।

import 'package:hive/hive.dart';

class MessageService {
  static const String _boxName = 'kormi_messages';

  // মেসেজ পাঠানো
  static Future<void> sendMessage({
    required String chatId,
    required String senderCard,
    required String senderName,
    required String text,
    String type = 'text', // text, voice, image, video, file, location
    String? filePath,
    String? fileType,
  }) async {
    final box = await Hive.openBox(_boxName);
    final List list = (box.get(chatId) ?? []) as List;
    list.add({
      'senderCard': senderCard,
      'senderName': senderName,
      'text': text,
      'type': type,
      'filePath': filePath,
      'fileType': fileType,
      'time': DateTime.now().toIso8601String(),
      'status': 'sent', // sent -> delivered -> read
    });
    await box.put(chatId, list);
  }

  // চ্যাটের সব মেসেজ - নিচ থেকে শুরু হবে, নিচে নতুন আসবে
  static Future<List<Map>> getMessages(String chatId) async {
    final box = await Hive.openBox(_boxName);
    final List list = (box.get(chatId) ?? []) as List;
    final List<Map> result = [];
    for (final item in list) {
      if (item is Map) result.add(item);
    }
    return result;
  }

  // Read করা - 2 নীল টিক
  static Future<void> markAsRead(String chatId) async {
    final box = await Hive.openBox(_boxName);
    final List list = (box.get(chatId) ?? []) as List;
    for (final item in list) {
      if (item is Map) {
        item['status'] = 'read';
      }
    }
    await box.put(chatId, list);
  }

  // Delivered করা - 2 টিক
  static Future<void> markAsDelivered(String chatId) async {
    final box = await Hive.openBox(_boxName);
    final List list = (box.get(chatId) ?? []) as List;
    for (final item in list) {
      if (item is Map && item['status'] == 'sent') {
        item['status'] = 'delivered';
      }
    }
    await box.put(chatId, list);
  }
}
