// Messages Screen - মেসেজ
// WhatsApp এর মতো। ১-১ + গ্রুপ, টেক্সট, ভয়েস, ছবি, ফাইল।

import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // ডেমো চ্যাট লিস্ট
  List<Map<String, String>> _chats = [
    {'name': '১ নম্বর ইউনিট গ্রুপ', 'last': 'আজকের প্রোডাকশন ১২০০ কেজি', 'time': '১০:৩০', 'online': 'true'},
    {'name': 'ফাতেমা আক্তার', 'last': 'স্যার, কাল ছুটি লাগবে', 'time': '০৯:১৫', 'online': 'false'},
    {'name': 'রিং সেকশন গ্রুপ', 'last': 'মেশিন ৫ বন্ধ আছে', 'time': '০৮:৪০', 'online': 'true'},
  ];

  // চ্যাটের ভিতরে মেসেজ
  List<Map<String, dynamic>> _messages = [
    {'text': 'আসসালামু আলাইকুম, আজকের প্রোডাকশন কত?', 'isMe': false, 'tick': 'read'},
    {'text': '১২০০ কেজি হইছে', 'isMe': true, 'tick': 'read'},
  ];

  final _controller = TextEditingController();
  bool _isTyping = false;
  String _selectedChat = '';

  void _openChat(String name) {
    setState(() => _selectedChat = name);
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({'text': _controller.text.trim(), 'isMe': true, 'tick': 'sent'});
      _controller.clear();
    });
  }

  // টিক চিহ্ন: ১টা = Sent, ২টা = Delivered, ২টা নীল = Read
  Widget _tickIcon(String tick) {
    if (tick == 'sent') {
      return const Icon(Icons.check, size: 16, color: Colors.grey);
    }
    if (tick == 'read') {
      return const Icon(Icons.done_all, size: 16, color: Colors.blue);
    }
    return const Icon(Icons.done_all, size: 16, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    // যদি কোনো চ্যাট খোলা না থাকে, লিস্ট দেখাবো
    if (_selectedChat.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A1A2F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A1A2F),
          title: const Text(
            'মেসেজ',
            style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: _chats.length,
          itemBuilder: (context, index) {
            final c = _chats[index];
            final online = c['online'] == 'true';
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFD4AF37),
                  child: Text(
                    c['name']!.substring(0, 1),
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(c['last']!),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(c['time']!, style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      online ? 'Online' : 'Offline',
                      style: TextStyle(fontSize: 12, color: online ? Colors.green : Colors.grey),
                    ),
                  ],
                ),
                onTap: () => _openChat(c['name']!),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFD4AF37),
          onPressed: () {},
          child: const Icon(Icons.message, color: Colors.black),
        ),
      );
    }

    // চ্যাট খোলা থাকলে, চ্যাট স্ক্রিন দেখাবো, মেসেজ নিচ থেকে শুরু হবে
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A2F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => setState(() => _selectedChat = ''),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_selectedChat, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            const Text('Online', style: TextStyle(color: Colors.green, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isMe = m['isMe'] as bool;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFD4AF37) : Colors.white12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            m['text'],
                            style: TextStyle(color: isMe ? Colors.black : Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (isMe) _tickIcon(m['tick']),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('লিখতেছে...', style: TextStyle(color: Colors.white70)),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'মেসেজ লিখুন...',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (v) => setState(() => _isTyping = v.isNotEmpty),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic, color: Color(0xFFD4AF37), size: 30),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFFD4AF37), size: 30),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
