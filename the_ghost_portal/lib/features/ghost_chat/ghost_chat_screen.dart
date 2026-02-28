import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/app_constants.dart';
import '../../services/light_service.dart';
import 'package:google_fonts/google_fonts.dart';

class GhostChatScreen extends StatefulWidget {
  const GhostChatScreen({super.key});

  @override
  State<GhostChatScreen> createState() => _GhostChatScreenState();
}

class _GhostChatScreenState extends State<GhostChatScreen> {
  final _lightService = LightService();
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isFlashing = false;
  Color _flashColor = Colors.transparent;

  void _sendMessage() async {
    String text = _messageController.text;
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'me', 'text': text});
      _messageController.clear();
      _isFlashing = true;
    });

    List<bool> pulses = _lightService.encodeMessage(text);
    
    for (bool pulse in pulses) {
      if (!mounted) break;
      setState(() {
        _flashColor = pulse ? Colors.white : Colors.transparent;
      });
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (mounted) {
      setState(() {
        _isFlashing = false;
        _flashColor = Colors.transparent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      appBar: AppBar(title: const Text('GHOST CHAT')),
      body: Stack(
        children: [
          // Chat Interface
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    bool isMe = _messages[index]['sender'] == 'me';
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.portalPurple.withOpacity(0.3) : Colors.white10,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: isMe ? AppColors.portalPurple : Colors.white12),
                        ),
                        child: Text(_messages[index]['text']!),
                      ),
                    );
                  },
                ),
              ),
              
              // Input Area
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  border: const Border(top: BorderSide(color: Colors.white12)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Ghost Message...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.flash_on, color: AppColors.neonYellow),
                      onPressed: _isFlashing ? null : _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Flash Overlay
          if (_isFlashing)
            Positioned.fill(
              child: Container(
                color: _flashColor,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.deepBlack.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt, color: AppColors.neonYellow, size: 50),
                        const SizedBox(height: 10),
                        Text('TRANSMITTING SIGNAL...', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
