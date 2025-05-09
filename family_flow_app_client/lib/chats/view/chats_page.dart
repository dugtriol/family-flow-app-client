import 'dart:async';

import 'package:family_flow_app_client/chats/view/create_chat_page.dart';
import 'package:family_flow_app_client/main.dart' show webSocketService;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_api/user_api.dart' show User;
import '../../authentication/authentication.dart';
import '../../family/family.dart';
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
  late final String? userId;

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

    userId = context.read<AuthenticationBloc>().state.user?.id;

    // Загружаем чаты
    context.read<ChatsBloc>().add(const ChatsLoad());

    // Загружаем членов семьи
    context.read<FamilyBloc>().add(FamilyRequested());
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    _chatNameController.dispose();
    _participantIdController.dispose();
    super.dispose();
  }

  void _createChat(String memberId, String memberName) {
    context.read<ChatsBloc>().add(
      ChatsCreateChatWithParticipants(
        name: memberName, // Имя участника как название чата
        participantIds: [memberId],
      ),
    );
  }

  String? getParticipantName(String userId, List<User> members) {
    final member = members.firstWhere(
      (member) => member.id == userId,
      orElse: () => User.empty,
    );
    return member?.name;
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.deepPurple),
            onPressed: () {
              // Переход к экрану создания чата
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CreateChatPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<ChatsBloc, ChatsState>(
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
                final participantId =
                    chat.participants
                        .firstWhere(
                          (participant) => participant.userId != userId,
                        )
                        .userId;
                final familyState = context.read<FamilyBloc>().state;
                String participantName = 'Неизвестно';

                if (familyState is FamilyLoadSuccess) {
                  participantName =
                      getParticipantName(participantId, familyState.members) ??
                      'Неизвестно';
                }

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple[100],
                    child: Text(
                      participantName[0], // Первая буква имени
                      style: const TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                  title: Text(
                    participantName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Переход к деталям чата
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => ChatDetailsPage(
                              chatId: chat.id,
                              chatName: participantName,
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
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.white,
  //       elevation: 0,
  //       title: Row(
  //         children: [
  //           const Icon(Icons.chat_rounded, color: Colors.deepPurple, size: 28),
  //           const SizedBox(width: 8),
  //           const Text(
  //             'Сообщения',
  //             style: TextStyle(
  //               color: Colors.black87,
  //               fontSize: 20,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     backgroundColor: Colors.white,
  //     body: Column(
  //       children: [
  //         // Форма для создания чата
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               TextField(
  //                 controller: _chatNameController,
  //                 decoration: const InputDecoration(
  //                   labelText: 'Название чата',
  //                   border: OutlineInputBorder(),
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: TextField(
  //                       controller: _participantIdController,
  //                       decoration: const InputDecoration(
  //                         labelText: 'ID участника',
  //                         border: OutlineInputBorder(),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       final participantId =
  //                           _participantIdController.text.trim();
  //                       if (participantId.isNotEmpty) {
  //                         setState(() {
  //                           _participants.add(participantId);
  //                         });
  //                         _participantIdController.clear();
  //                       }
  //                     },
  //                     child: const Text('Добавить участника'),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 8),
  //               Wrap(
  //                 spacing: 8,
  //                 children:
  //                     _participants
  //                         .map(
  //                           (id) => Chip(
  //                             label: Text(id),
  //                             onDeleted: () {
  //                               setState(() {
  //                                 _participants.remove(id);
  //                               });
  //                             },
  //                           ),
  //                         )
  //                         .toList(),
  //               ),
  //               const SizedBox(height: 16),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   final chatName = _chatNameController.text.trim();
  //                   if (chatName.isNotEmpty && _participants.isNotEmpty) {
  //                     context.read<ChatsBloc>().add(
  //                       ChatsCreateChatWithParticipants(
  //                         name: chatName,
  //                         participantIds: List.from(_participants),
  //                       ),
  //                     );
  //                     setState(() {
  //                       _chatNameController.clear();
  //                       _participants.clear();
  //                     });
  //                   }
  //                 },
  //                 child: const Text('Создать чат'),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const Divider(),
  //         // Список чатов
  //         Expanded(
  //           child: BlocBuilder<ChatsBloc, ChatsState>(
  //             builder: (context, state) {
  //               if (state is ChatsInitial) {
  //                 return const Center(child: CircularProgressIndicator());
  //               } else if (state is ChatsLoadFailure) {
  //                 return Center(
  //                   child: Text(
  //                     'Ошибка: ${state.error}',
  //                     style: const TextStyle(color: Colors.red),
  //                   ),
  //                 );
  //               } else if (state is ChatsLoadSuccess) {
  //                 final chats = state.chats;
  //                 if (chats.isEmpty) {
  //                   return const Center(child: Text('Нет доступных чатов.'));
  //                 }
  //                 return ListView.builder(
  //                   itemCount: chats.length,
  //                   itemBuilder: (context, index) {
  //                     final chat = chats[index];
  //                     return ListTile(
  //                       leading: CircleAvatar(
  //                         backgroundColor: Colors.deepPurple[100],
  //                         child: Text(
  //                           chat.name[0], // Первая буква имени чата
  //                           style: const TextStyle(color: Colors.deepPurple),
  //                         ),
  //                       ),
  //                       title: Text(
  //                         chat.name,
  //                         style: const TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       subtitle: Text(
  //                         'Участники: ${2}',
  //                         style: const TextStyle(color: Colors.grey),
  //                       ),
  //                       onTap: () {
  //                         // Переход к деталям чата
  //                         Navigator.of(context).push(
  //                           MaterialPageRoute(
  //                             builder:
  //                                 (context) => ChatDetailsPage(
  //                                   chatId: chat.id,
  //                                   chatName: chat.name,
  //                                 ),
  //                           ),
  //                         );
  //                       },
  //                     );
  //                   },
  //                 );
  //               }
  //               return const Center(child: CircularProgressIndicator());
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
