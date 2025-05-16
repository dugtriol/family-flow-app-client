import 'dart:convert';

import 'package:chats_api/chats_api.dart';
import 'package:family_flow_app_client/main.dart' show webSocketService;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../authentication/authentication.dart';
import '../bloc/chats_bloc.dart';

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
  String? _lastMessageId;

  @override
  void initState() {
    super.initState();
    context.read<ChatsBloc>().add(ChatsLoadMessages(chatId: widget.chatId));
    final chatsState = context.read<ChatsBloc>().state;
    print('chatState: $chatsState');
    if (chatsState is ChatsLoadSuccess) {
      _lastMessageId =
          chatsState.chats
              .firstWhere((chat) => chat.id == widget.chatId)
              .lastMessage
              ?.id;
    }

    // Подписываемся на поток сообщений
    webSocketService.messages.listen((response) {
      if (response['data'] is Map<String, dynamic>) {
        print('Received message: ${response['data']}');
        final newMessage = Message.fromJson(response['data']);
        // Проверяем, что сообщение относится к текущему чату
        if (newMessage.chatId == widget.chatId) {
          setState(() {
            _messages.add(newMessage.toJson());
          });
        }
      }
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

      // Отправляем сообщение через WebSocket
      webSocketService.sendMessage(
        WebSocketRequest(
          action: "send_message",
          data:
              CreateMessageInput(
                chatId: widget.chatId,
                senderId: userId,
                content: message,
              ).toJson(),
        ).toJson(),
      );

      // Добавляем сообщение в локальный список
      setState(() {
        _messages.add(
          Message(
            id: DateTime.now().toIso8601String(),
            chatId: widget.chatId,
            senderId: userId,
            content: message,
            createdAt: DateTime.now(),
          ).toJson(),
        );
      });

      _messageController.clear();
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   final userId = context.read<AuthenticationBloc>().state.user?.id;

  //   return WillPopScope(
  //     onWillPop: () async {
  //       // Отправляем событие для загрузки списка чатов при выходе
  //       context.read<ChatsBloc>().add(const ChatsLoad());
  //       return true; // Разрешаем выход
  //     },
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: Text(widget.chatName),
  //         backgroundColor: Colors.deepPurple,
  //       ),
  //       body: Column(
  //         children: [
  //           // Список сообщений
  //           Expanded(
  //             child: BlocListener<ChatsBloc, ChatsState>(
  //               listener: (context, state) {
  //                 if (state is ChatsMessagesLoadSuccess) {
  //                   setState(() {
  //                     _messages.clear(); // Очищаем список перед загрузкой
  //                     _messages.addAll(
  //                       state.messages
  //                           .map((message) => message.toJson())
  //                           .toList(),
  //                     ); // Добавляем загруженные сообщения
  //                   });
  //                 }
  //               },
  //               child: ListView.builder(
  //                 padding: const EdgeInsets.all(16.0),
  //                 itemCount: _messages.length,
  //                 itemBuilder: (context, index) {
  //                   final message = _messages[index];
  //                   final isSentByMe = message['sender_id'] == userId;
  //                   return Align(
  //                     alignment:
  //                         isSentByMe
  //                             ? Alignment.centerRight
  //                             : Alignment.centerLeft,
  //                     child: Container(
  //                       margin: const EdgeInsets.symmetric(vertical: 4.0),
  //                       padding: const EdgeInsets.all(12.0),
  //                       decoration: BoxDecoration(
  //                         color:
  //                             isSentByMe ? Colors.deepPurple : Colors.grey[200],
  //                         borderRadius: BorderRadius.circular(12.0),
  //                       ),
  //                       child: Text(
  //                         message['content'] ?? '',
  //                         style: TextStyle(
  //                           color: isSentByMe ? Colors.white : Colors.black87,
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ),
  //           // Поле ввода сообщения
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.2),
  //                   spreadRadius: 2,
  //                   blurRadius: 5,
  //                   offset: const Offset(0, -2),
  //                 ),
  //               ],
  //             ),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: TextField(
  //                     controller: _messageController,
  //                     decoration: InputDecoration(
  //                       hintText: 'Введите сообщение...',
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(24),
  //                         borderSide: BorderSide.none,
  //                       ),
  //                       filled: true,
  //                       fillColor: Colors.grey[200],
  //                       contentPadding: const EdgeInsets.symmetric(
  //                         horizontal: 16,
  //                         vertical: 8,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 CircleAvatar(
  //                   radius: 24,
  //                   backgroundColor: Colors.deepPurple,
  //                   child: IconButton(
  //                     icon: const Icon(Icons.send, color: Colors.white),
  //                     onPressed: _sendMessage,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthenticationBloc>().state.user?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: BlocListener<ChatsBloc, ChatsState>(
              listener: (context, state) {
                if (state is ChatsMessagesLoadSuccess) {
                  setState(() {
                    _messages.clear(); // Очищаем список перед загрузкой
                    _messages.addAll(
                      state.messages
                          .map((message) => message.toJson())
                          .toList(),
                    ); // Добавляем загруженные сообщения
                  });
                }
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isSentByMe = message['sender_id'] == userId;

                  // Форматируем время сообщения
                  final messageTime =
                      message['created_at'] != null
                          ? _formatTime(DateTime.parse(message['created_at']))
                          : '';

                  return Align(
                    alignment:
                        isSentByMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color:
                            isSentByMe ? Colors.deepPurple : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            message['content'] ?? '',
                            style: TextStyle(
                              color: isSentByMe ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            messageTime,
                            style: TextStyle(
                              color:
                                  isSentByMe ? Colors.white70 : Colors.black54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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

  String _formatTime(DateTime dateTime) {
    // Добавляем 3 часа для московского времени
    final moscowTime = dateTime.toUtc().add(const Duration(hours: 3));
    final now = DateTime.now().toUtc().add(const Duration(hours: 3));
    final difference = now.difference(moscowTime);

    if (difference.inDays > 0) {
      // Если сообщение было отправлено более чем за день назад
      return '${moscowTime.day}.${moscowTime.month}.${moscowTime.year}';
    } else {
      // Если сообщение было отправлено сегодня
      return '${moscowTime.hour}:${moscowTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
