// KORMI - Messages Screen
// Conversation List + Chat View (একই ফাইলে)

import 'package:flutter/material.dart';
import '../theme/kormi_theme.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _searchController = TextEditingController();
  String _filter = 'All';

  final List<Map<String, dynamic>> _conversations = [
    {
      'name': 'Tariqul Islam',
      'role': 'CHIEF MILL ADMINISTRATOR',
      'msg': 'Production summary পাঠিয়ে দিয়েছি, দেখে নিন',
      'time': '10:42 AM',
      'unread': 2,
      'online': true,
      'color': KormiColors.navy,
    },
    {
      'name': 'Rahim Uddin',
      'role': 'Shift Incharge - P/B',
      'msg': 'RF-14 breakdown resolved, 45 min down ছিল',
      'time': '09:15 AM',
      'unread': 0,
      'online': true,
      'color': KormiColors.green,
    },
    {
      'name': 'Karim Sheikh',
      'role': 'Worker - Ring Section',
      'msg': 'স্যার, আগামীকাল ছুটি লাগবে',
      'time': 'Yesterday',
      'unread': 1,
      'online': false,
      'color': KormiColors.gold,
    },
    {
      'name': 'Nasir Ahmed',
      'role': 'Officer - Production',
      'msg': 'Manpower report ready, Unit 1 full আছে',
      'time': 'Yesterday',
      'unread': 0,
      'online': false,
      'color': KormiColors.textGrey,
    },
    {
      'name': 'Admin Group',
      'role': 'Management Group • 8 members',
      'msg': 'Tariqul: আগামীকাল মিটিং 10টায়',
      'time': 'Mon',
      'unread': 0,
      'online': false,
      'color': KormiColors.navy,
      'isGroup': true,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    var list = _conversations;
    if (_filter == 'Unread') {
      list = list.where((e) => (e['unread'] as int) > 0).toList();
    }
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((e) => (e['name'] as String).toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New Message - Worker / Officer সিলেক্ট করুন')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search messages...',
                prefixIcon: const Icon(Icons.search_outlined, color: KormiColors.textGrey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: KormiColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: KormiColors.border),
                ),
              ),
            ),
          ),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: ['All', 'Unread', 'Groups', 'Workers'].map((f) {
                final active = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? KormiColors.navy : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: KormiColors.border),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          color: active ? KormiColors.goldLight : KormiColors.navy,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final c = _filtered[index];
                final unread = c['unread'] as int;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: KormiCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _ChatPage(name: c['name'], role: c['role']),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: (c['color'] as Color).withOpacity(0.15),
                              child: Text(
                                (c['name'] as String)[0],
                                style: TextStyle(fontWeight: FontWeight.bold, color: c['color'] as Color, fontSize: 20),
                              ),
                            ),
                            if (c['online'] == true)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: KormiColors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: KormiColors.navy, fontSize: 15)),
                              Text(c['role'], style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text(
                                c['msg'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: unread > 0 ? KormiColors.navy : KormiColors.textGrey,
                                  fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(c['time'], style: const TextStyle(color: KormiColors.textGrey, fontSize: 11)),
                            if (unread > 0) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: const BoxDecoration(color: KormiColors.navy, shape: BoxShape.circle),
                                child: Text('$unread', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Chat Page
class _ChatPage extends StatefulWidget {
  final String name;
  final String role;
  const _ChatPage({required this.name, required this.role});

  @override
  State<_ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<_ChatPage> {
  final _msgController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'আসসালামু আলাইকুম স্যার', 'me': false, 'time': '09:10 AM'},
    {'text': 'ওয়ালাইকুম আসসালাম, Production summary পাঠিয়ে দিয়েছি', 'me': true, 'time': '09:12 AM'},
    {'text': 'দেখেছি স্যার, Unit 1 Total 39,353 kg হয়েছে', 'me': false, 'time': '09:15 AM'},
    {'text': 'RF-14 breakdown টা দেখো, 45 min down ছিল', 'me': true, 'time': '09:16 AM'},
  ];

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'me': true, 'time': 'Now'});
      _msgController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KormiColors.bg,
      appBar: AppBar(
        backgroundColor: KormiColors.navy,
        foregroundColor: KormiColors.goldLight,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(widget.role, style: const TextStyle(fontSize: 11, color: KormiColors.goldLight)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                final me = m['me'] as bool;
                return Align(
                  alignment: me ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: me ? KormiColors.navy : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: KormiColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m['text'], style: TextStyle(color: me ? Colors.white : KormiColors.navy, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(m['time'], style: TextStyle(color: me ? KormiColors.goldLight : KormiColors.textGrey, fontSize: 10)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.attach_file_outlined, color: KormiColors.navy), onPressed: () {}),
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      decoration: InputDecoration(
                        hintText: 'Type message...',
                        filled: true,
                        fillColor: KormiColors.bg,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: KormiColors.navy,
                    child: IconButton(icon: const Icon(Icons.send_outlined, color: KormiColors.goldLight, size: 20), onPressed: _send),
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
