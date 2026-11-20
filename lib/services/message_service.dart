// KORMI - Message Service
// Chat / Message - Worker <-> Officer <-> Admin
// Offline First - Message ফোনে Save হবে, পরে Sync হবে

class ChatMessage {
  final String id;
  final String senderCard;
  final String senderName;
  final String receiverCard;
  final String text;
  final DateTime time;
  final bool isMe;
  bool isRead;

  ChatMessage({
    required this.id,
    required this.senderCard,
    required this.senderName,
    required this.receiverCard,
    required this.text,
    required this.time,
    required this.isMe,
    this.isRead = false,
  });
}

class Conversation {
  final String otherCard;
  final String otherName;
  final String otherRole;
  final String lastMessage;
  final DateTime lastTime;
  final int unreadCount;
  final bool isGroup;

  Conversation({
    required this.otherCard,
    required this.otherName,
    required this.otherRole,
    required this.lastMessage,
    required this.lastTime,
    this.unreadCount = 0,
    this.isGroup = false,
  });
}

class MessageService {
  // In-Memory Chat Store - পরে Hive দিয়ে Replace হবে, UI একই থাকবে
  static final Map<String, List<ChatMessage>> _chats = {};

  // Message পাঠানো - Validation + Save
  static ChatMessage sendMessage({
    required String myCard,
    required String myName,
    required String toCard,
    required String text,
  }) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw Exception('Message খালি পাঠানো যাবে না');
    }
    if (trimmed.length > 1000) {
      throw Exception('Message অনেক বড়, 1000 অক্ষরের ভিতরে লিখুন');
    }

    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderCard: myCard,
      senderName: myName,
      receiverCard: toCard,
      text: trimmed,
      time: DateTime.now(),
      isMe: true,
      isRead: true,
    );

    _chats.putIfAbsent(toCard, () => []).add(msg);
    return msg;
  }

  // Received Message - অন্যের Message আসলে
  static void receiveMessage(ChatMessage msg) {
    _chats.putIfAbsent(msg.senderCard, () => []).add(msg);
  }

  // একজনের সাথে সব Message
  static List<ChatMessage> getChatWith(String otherCard) {
    final list = _chats[otherCard] ?? [];
    list.sort((a, b) => a.time.compareTo(b.time));
    return List.from(list);
  }

  // Conversation List - Last Message দিয়ে Sort
  static List<Conversation> getConversations({
    required String myCard,
    required Map<String, Map<String, String>> userInfo, // card -> {name, role}
  }) {
    final result = <Conversation>[];
    for (final entry in _chats.entries) {
      final otherCard = entry.key;
      final msgs = entry.value;
      if (msgs.isEmpty) continue;
      msgs.sort((a, b) => a.time.compareTo(b.time));
      final last = msgs.last;
      final info = userInfo[otherCard] ?? {'name': otherCard, 'role': 'Worker'};
      final unread = msgs.where((m) => !m.isMe && !m.isRead).length;
      result.add(Conversation(
        otherCard: otherCard,
        otherName: info['name'] ?? otherCard,
        otherRole: info['role'] ?? 'Worker',
        lastMessage: last.text,
        lastTime: last.time,
        unreadCount: unread,
      ));
    }
    result.sort((a, b) => b.lastTime.compareTo(a.lastTime));
    return result;
  }

  // Mark All Read - Chat খুললে
  static void markAllRead(String otherCard) {
    final list = _chats[otherCard] ?? [];
    for (final m in list) {
      if (!m.isMe) m.isRead = true;
    }
  }

  // Unread Total - Dashboard Badge এর জন্য
  static int totalUnread() {
    int total = 0;
    for (final list in _chats.values) {
      total += list.where((m) => !m.isMe && !m.isRead).length;
    }
    return total;
  }

  // Time Format - "10:42 AM" / "Yesterday"
  static String formatTime(DateTime time) {
    final now = DateTime.now();
    final isToday = time.day == now.day && time.month == now.month && time.year == now.year;
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = time.day == yesterday.day && time.month == yesterday.month && time.year == yesterday.year;

    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final ampm = time.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hour:${time.minute.toString().padLeft(2, '0')} $ampm';

    if (isToday) return timeStr;
    if (isYesterday) return 'Yesterday';
    return '${time.day}/${time.month}/${time.year}';
  }

  // Quick Reply Templates - Production / Breakdown / Manpower
  static List<String> quickReplies() {
    return [
      'Production summary পাঠিয়ে দিয়েছি',
      'Breakdown resolved',
      'Manpower report ready',
      'আগামীকাল মিটিং 10টায়',
      'OK, দেখছি',
    ];
  }

  // Demo Data - Testing এর জন্য
  static void loadDemo(String myCard) {
    if (_chats.isNotEmpty) return;
    final now = DateTime.now();
    _chats['ADMIN'] = [
      ChatMessage(id: '1', senderCard: 'ADMIN', senderName: 'Tariqul Islam', receiverCard: myCard, text: 'আসসালামু আলাইকুম, Production summary পাঠিয়ে দিয়েছি', time: now.subtract(const Duration(minutes: 30)), isMe: false, isRead: false),
      ChatMessage(id: '2', senderCard: myCard, senderName: 'Me', receiverCard: 'ADMIN', text: 'দেখেছি স্যার, Unit 1 Total 39,353 kg হয়েছে', time: now.subtract(const Duration(minutes: 25)), isMe: true, isRead: true),
    ];
  }
}
