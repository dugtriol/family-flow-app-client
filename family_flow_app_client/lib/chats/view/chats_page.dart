import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chats_bloc.dart';
import 'chats_details_page.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

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
            icon: const Icon(Icons.person_add, color: Colors.deepPurple),
            tooltip: 'Создать чат',
            onPressed: () {
              _showCreateChatDialog(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<ChatsBloc, ChatsState>(
        builder: (context, state) {
          if (state is ChatsLoadFailure) {
            return Center(
              child: Text(
                'Ошибка: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is ChatsLoadSuccess) {
            final chats = state.messages;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple[100],
                    child: Text(
                      chat.senderId[0], // Первая буква имени отправителя
                      style: const TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                  title: Text(
                    chat.senderId, // Имя отправителя
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    chat.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    // Переход к деталям чата
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ChatDetailsPage(chatName: chat.senderId),
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

  void _showCreateChatDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Создать чат'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Имя участника',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  context.read<ChatsBloc>().add(ChatsCreateChat(name: name));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Создать'),
            ),
          ],
        );
      },
    );
  }
}
