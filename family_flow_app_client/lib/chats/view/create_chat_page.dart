import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/authentication.dart';
import '../../family/family.dart';
import '../chats.dart';

class CreateChatPage extends StatelessWidget {
  const CreateChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthenticationBloc>().state.user?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать чат'),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<FamilyBloc, FamilyState>(
        builder: (context, state) {
          if (state is FamilyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FamilyLoadFailure) {
            return Center(
              child: Text(
                'Ошибка: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is FamilyLoadSuccess) {
            final members =
                state.members.where((member) => member.id != userId).toList();
            if (members.isEmpty) {
              return const Center(child: Text('Нет доступных участников.'));
            }
            return ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple[100],
                    child: Text(
                      member.name[0], // Первая буква имени
                      style: const TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                  title: Text(
                    member.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Создаём чат с выбранным участником
                    context.read<ChatsBloc>().add(
                      ChatsCreateChatWithParticipants(
                        name: member.name,
                        participantIds: [member.id],
                      ),
                    );
                    Navigator.of(context).pop(); // Возвращаемся на экран чатов
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
}
