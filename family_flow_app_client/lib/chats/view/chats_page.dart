// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/chats_bloc.dart';
// import 'chats_details_page.dart';

// class ChatsPage extends StatefulWidget {
//   const ChatsPage({super.key});

//   @override
//   State<ChatsPage> createState() => _ChatsPageState();
// }

// class _ChatsPageState extends State<ChatsPage> {
//   final TextEditingController _chatNameController = TextEditingController();
//   final TextEditingController _participantIdController =
//       TextEditingController();
//   final List<String> _participants = [];

//   @override
//   Widget build(BuildContext context) {
//     // Отправляем событие загрузки чатов при построении страницы
//     context.read<ChatsBloc>().add(const ChatsLoad());

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             const Icon(Icons.chat_rounded, color: Colors.deepPurple, size: 28),
//             const SizedBox(width: 8),
//             const Text(
//               'Сообщения',
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // Форма для создания чата
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   controller: _chatNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Название чата',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _participantIdController,
//                         decoration: const InputDecoration(
//                           labelText: 'ID участника',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     ElevatedButton(
//                       onPressed: () {
//                         final participantId =
//                             _participantIdController.text.trim();
//                         if (participantId.isNotEmpty) {
//                           setState(() {
//                             _participants.add(participantId);
//                           });
//                           _participantIdController.clear();
//                         }
//                       },
//                       child: const Text('Добавить участника'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Wrap(
//                   spacing: 8,
//                   children:
//                       _participants
//                           .map(
//                             (id) => Chip(
//                               label: Text(id),
//                               onDeleted: () {
//                                 setState(() {
//                                   _participants.remove(id);
//                                 });
//                               },
//                             ),
//                           )
//                           .toList(),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     final chatName = _chatNameController.text.trim();
//                     if (chatName.isNotEmpty && _participants.isNotEmpty) {
//                       // print participants
//                       print('Создать чат - Participants: $_participants');
//                       context.read<ChatsBloc>().add(
//                         ChatsCreateChatWithParticipants(
//                           name: chatName,
//                           participantIds: List.from(_participants),
//                         ),
//                       );
//                       setState(() {
//                         _chatNameController.clear();
//                         _participants.clear();
//                       });
//                     }
//                   },
//                   child: const Text('Создать чат'),
//                 ),
//               ],
//             ),
//           ),
//           const Divider(),
//           // Список чатов
//           Expanded(
//             child: BlocBuilder<ChatsBloc, ChatsState>(
//               builder: (context, state) {
//                 if (state is ChatsInitial) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is ChatsLoadFailure) {
//                   return Center(
//                     child: Text(
//                       'Ошибка: ${state.error}',
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   );
//                 } else if (state is ChatsLoadSuccess) {
//                   final chats = state.chats;
//                   if (chats.isEmpty) {
//                     return const Center(child: Text('Нет доступных чатов.'));
//                   }
//                   return ListView.builder(
//                     itemCount: chats.length,
//                     itemBuilder: (context, index) {
//                       final chat = chats[index];
//                       return ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.deepPurple[100],
//                           child: Text(
//                             chat.name[0], // Первая буква имени чата
//                             style: const TextStyle(color: Colors.deepPurple),
//                           ),
//                         ),
//                         title: Text(
//                           chat.name,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Text(
//                           'Участники: ${2}',
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                         onTap: () {
//                           // Переход к деталям чата
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder:
//                                   (context) => ChatDetailsPage(
//                                     chatId: chat.id,
//                                     chatName: chat.name,
//                                   ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 }
//                 return const Center(child: CircularProgressIndicator());
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:family_flow_app_client/main.dart' show webSocketService;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/view/websocket_service.dart';
import '../../authentication/authentication.dart';
import '../bloc/chats_bloc.dart';
import 'chats_details_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _chatNameController = TextEditingController();
  final TextEditingController _participantIdController =
      TextEditingController();
  final List<String> _participants = [];
  late StreamSubscription _messageSubscription;

  @override
  void initState() {
    super.initState();

    // Подписываемся на поток сообщений
    _messageSubscription = webSocketService.messages.listen((response) {
      if (response['data'] is Map<String, dynamic>) {
        final newMessage = response['data']!;
        if (newMessage['sender_id'] ==
            context.read<AuthenticationBloc>().state.user?.id) {
          return; // Игнорируем сообщение
        }
        context.read<ChatsBloc>().add(
          ChatsSendMessage(
            chatId: newMessage['chat_id'],
            senderId: newMessage['sender_id'],
            content: newMessage['content'],
          ),
        );
      }
    });

    // Загружаем чаты
    context.read<ChatsBloc>().add(const ChatsLoad());
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    _chatNameController.dispose();
    _participantIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.chat_rounded, color: Colors.deepPurple, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Сообщения',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Форма для создания чата
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _chatNameController,
                  decoration: const InputDecoration(
                    labelText: 'Название чата',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _participantIdController,
                        decoration: const InputDecoration(
                          labelText: 'ID участника',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final participantId =
                            _participantIdController.text.trim();
                        if (participantId.isNotEmpty) {
                          setState(() {
                            _participants.add(participantId);
                          });
                          _participantIdController.clear();
                        }
                      },
                      child: const Text('Добавить участника'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      _participants
                          .map(
                            (id) => Chip(
                              label: Text(id),
                              onDeleted: () {
                                setState(() {
                                  _participants.remove(id);
                                });
                              },
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final chatName = _chatNameController.text.trim();
                    if (chatName.isNotEmpty && _participants.isNotEmpty) {
                      context.read<ChatsBloc>().add(
                        ChatsCreateChatWithParticipants(
                          name: chatName,
                          participantIds: List.from(_participants),
                        ),
                      );
                      setState(() {
                        _chatNameController.clear();
                        _participants.clear();
                      });
                    }
                  },
                  child: const Text('Создать чат'),
                ),
              ],
            ),
          ),
          const Divider(),
          // Список чатов
          Expanded(
            child: BlocBuilder<ChatsBloc, ChatsState>(
              builder: (context, state) {
                if (state is ChatsInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatsLoadFailure) {
                  return Center(
                    child: Text(
                      'Ошибка: ${state.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is ChatsLoadSuccess) {
                  final chats = state.chats;
                  if (chats.isEmpty) {
                    return const Center(child: Text('Нет доступных чатов.'));
                  }
                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple[100],
                          child: Text(
                            chat.name[0], // Первая буква имени чата
                            style: const TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                        title: Text(
                          chat.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Участники: ${2}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          // Переход к деталям чата
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => ChatDetailsPage(
                                    chatId: chat.id,
                                    chatName: chat.name,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
