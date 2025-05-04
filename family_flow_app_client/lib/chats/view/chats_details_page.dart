import 'dart:convert';

import 'package:family_flow_app_client/main.dart' show webSocketService;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../authentication/authentication.dart';

class ChatDetailsPage extends StatefulWidget {
  final String chatId;
  final String chatName;

  const ChatDetailsPage({
    super.key,
    required this.chatId,
    required this.chatName,
  });

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  late WebSocketChannel _channel;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();

    // Подписываемся на поток сообщений
    webSocketService.messages.listen((message) {
      if (message['data'] is Map<String, dynamic>) {
        final newMessage = message['data'];
        if (newMessage['chat_id'] == widget.chatId) {
          setState(() {
            _messages.add(newMessage);
          });
        }
      }
    });

    // Отправляем запрос на получение сообщений
    webSocketService.sendMessage({
      "action": "get_messages",
      "data": {"chat_id": widget.chatId},
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      final userId = context.read<AuthenticationBloc>().state.user?.id;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка: пользователь не авторизован')),
        );
        return;
      }

      final messageData = {
        "action": "send_message",
        "data": {
          "chat_id": widget.chatId,
          "sender_id": userId,
          "content": message,
        },
      };

      webSocketService.sendMessage(messageData);

      setState(() {
        _messages.add({
          "chat_id": widget.chatId,
          "sender_id": userId,
          "content": message,
        });
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSentByMe =
                    message['sender_id'] ==
                    "your-user-id"; // Замените на ID текущего пользователя
                return Align(
                  alignment:
                      isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isSentByMe ? Colors.deepPurple : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      message['content'] ?? '',
                      style: TextStyle(
                        color: isSentByMe ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Поле ввода сообщения
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Введите сообщение...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.deepPurple,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
