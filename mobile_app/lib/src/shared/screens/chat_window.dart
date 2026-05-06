import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../common_widgets/app_text_field.dart';

class ChatWindow extends StatefulWidget {
  final String participantName;

  const ChatWindow({super.key, required this.participantName});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'I am 5 minutes away!', 'isMe': false, 'time': '2:45 PM'},
    {'text': 'Ok, I will wait at the main gate.', 'isMe': true, 'time': '2:46 PM'},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({'text': _messageController.text, 'isMe': true, 'time': 'Now'});
      _messageController.clear();
    });
    // In a real app, emit via Socket.IO /negotiation namespace
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.participantName}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'] as bool;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primary : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg['text'], style: TextStyle(color: isMe ? AppColors.white : AppColors.textPrimary)),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.bgCard,
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: '',
                    hint: 'Type a message...',
                    controller: _messageController,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
