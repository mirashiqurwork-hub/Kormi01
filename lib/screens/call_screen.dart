// Call Screen - অডিও / ভিডিও কল
// Messages থেকে কল আসবে। Private করার পর আসল Call Key বসবে, এখন UI Ready।

import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  final String name;
  final bool isVideo;
  const CallScreen({super.key, required this.name, this.isVideo = false});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _micOn = true;
  bool _speakerOn = false;
  bool _videoOn = true;
  String _time = '00:00';
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _videoOn = widget.isVideo;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _seconds++;
        final m = (_seconds ~/ 60).toString().padLeft(2, '0');
        final s = (_seconds % 60).toString().padLeft(2, '0');
        _time = '$m:$s';
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1D3F),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFFD4AF37),
              child: Icon(Icons.person, size: 70, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              widget.name,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              widget.isVideo ? 'ভিডিও কল - $_time' : 'অডিও কল - $_time',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _callBtn(
                  icon: _micOn ? Icons.mic : Icons.mic_off,
                  color: _micOn ? Colors.white24 : Colors.red,
                  onTap: () => setState(() => _micOn = !_micOn),
                ),
                _callBtn(
                  icon: Icons.volume_up,
                  color: _speakerOn ? const Color(0xFFD4AF37) : Colors.white24,
                  onTap: () => setState(() => _speakerOn = !_speakerOn),
                ),
                if (widget.isVideo)
                  _callBtn(
                    icon: _videoOn ? Icons.videocam : Icons.videocam_off,
                    color: _videoOn ? Colors.white24 : Colors.red,
                    onTap: () => setState(() => _videoOn = !_videoOn),
                  ),
                _callBtn(
                  icon: Icons.call_end,
                  color: Colors.red,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _callBtn({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
