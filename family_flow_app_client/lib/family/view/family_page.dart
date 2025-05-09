import 'package:family_flow_app_client/family/view/rewards_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_flow_app_client/family/bloc/family_bloc.dart';
import 'package:user_api/user_api.dart' show User;

import 'widgets/widgets.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  Future<void> _refreshFamily(BuildContext context) async {
    context.read<FamilyBloc>().add(FamilyRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Семья'),
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            tooltip: 'Вознаграждения',
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => RewardsPage()));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshFamily(context),
        child: BlocBuilder<FamilyBloc, FamilyState>(
          builder: (context, state) {
            if (state is FamilyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FamilyNoFamily) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('У вас нет семьи'),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const CreateFamilyDialog(),
                        );
                      },
                      child: const Text('Создать семью'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const JoinFamilyDialog(),
                        );
                      },
                      child: const Text('Присоединиться к семье'),
                    ),
                  ],
                ),
              );
            } else if (state is FamilyLoadSuccess) {
              // Разделяем членов семьи на группы
              final parents =
                  state.members
                      .where((member) => member.role == 'Parent')
                      .toList();
              final children =
                  state.members
                      .where((member) => member.role == 'Child')
                      .toList();

              return Column(
                children: [
                  FamilyCard(
                    familyName: state.familyName,
                    familyId: state.members.first.familyId.toString(),
                    familyPhotoUrl: state.familyPhotoUrl,
                  ), // Плашка с названием семьи
                  Expanded(
                    child: ListView(
                      children: [
                        // Плашка "Родители"
                        if (parents.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              'Родители',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          ...parents
                              .map(
                                (parent) => _buildMemberTile(context, parent),
                              )
                              .toList(),
                        ],

                        // Плашка "Дети"
                        if (children.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              'Дети',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          ...children
                              .map((child) => _buildMemberTile(context, child))
                              .toList(),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is FamilyLoadFailure) {
              return Center(child: Text('Ошибка: ${state.error}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: PopupMenuButton<String>(
        icon: const Icon(Icons.person_add, size: 28),
        tooltip: 'Действия с участниками',
        onSelected: (value) {
          if (value == 'add_member') {
            showDialog(
              context: context,
              builder: (context) => const AddMemberDialog(),
            );
          } else if (value == 'invite_member') {
            showDialog(
              context: context,
              builder: (context) => const InviteMemberDialog(),
            );
          }
        },
        itemBuilder:
            (context) => [
              const PopupMenuItem(
                value: 'add_member',
                child: Row(
                  children: [
                    Icon(Icons.person_add, color: Colors.deepPurple),
                    SizedBox(width: 8),
                    Text('Добавить участника'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'invite_member',
                child: Row(
                  children: [
                    Icon(Icons.mail_outline, color: Colors.deepPurple),
                    SizedBox(width: 8),
                    Text('Пригласить участника'),
                  ],
                ),
              ),
            ],
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, User member) {
    return ListTile(
      title: Text(member.name),
      subtitle: Text(member.email),
      onTap: () {
        UserDetailBottomSheet.show(context, member);
      },
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'Удалить') {
            final familyId =
                context.read<FamilyBloc>().state is FamilyLoadSuccess
                    ? (context.read<FamilyBloc>().state as FamilyLoadSuccess)
                        .familyName
                    : '';
            context.read<FamilyBloc>().add(
              FamilyRemoveMemberRequested(
                memberId: member.id,
                familyId: familyId,
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Удаление ${member.name}...')),
            );
          } else if (value == 'Изменить роль') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Изменить роль ${member.name}')),
            );
          }
        },
        itemBuilder:
            (context) => [
              const PopupMenuItem(value: 'Удалить', child: Text('Удалить')),
              const PopupMenuItem(
                value: 'Изменить роль',
                child: Text('Изменить роль'),
              ),
            ],
      ),
    );
  }

  void _showUserDetailsBottomSheet(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Имя: ${user.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: ${user.email}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (user.role != null)
                Text(
                  'Роль: ${user.role}',
                  style: const TextStyle(fontSize: 16),
                ),
              if (user.gender != null)
                Text(
                  'Пол: ${user.gender}',
                  style: const TextStyle(fontSize: 16),
                ),
              if (user.birthDate != null)
                Text(
                  'Дата рождения: ${user.birthDate}',
                  style: const TextStyle(fontSize: 16),
                ),
              Text(
                'Количество очков: ${user.point}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Закрыть',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
