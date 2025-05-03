import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_flow_app_client/family/bloc/family_bloc.dart';
import 'package:user_repository/user_repository.dart' show User;

import 'widgets/widgets.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  Future<void> _refreshFamily(BuildContext context) async {
    // Отправляем событие для обновления данных семьи
    context.read<FamilyBloc>().add(FamilyRequested());
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Семья')),
  //     body: RefreshIndicator(
  //       onRefresh: () => _refreshFamily(context),
  //       child: BlocBuilder<FamilyBloc, FamilyState>(
  //         builder: (context, state) {
  //           if (state is FamilyLoading) {
  //             return const Center(child: CircularProgressIndicator());
  //           } else if (state is FamilyNoFamily) {
  //             return Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   const Text('У вас нет семьи'),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       // _showCreateFamilyDialog(context);
  //                       showDialog(
  //                         context: context,
  //                         builder: (context) => const CreateFamilyDialog(),
  //                       );
  //                     },
  //                     child: const Text('Создать семью'),
  //                   ),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       // _showJoinFamilyDialog(context);
  //                       showDialog(
  //                         context: context,
  //                         builder: (context) => const JoinFamilyDialog(),
  //                       );
  //                     },
  //                     child: const Text('Присоединиться к семье'),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           } else if (state is FamilyNoMembers) {
  //             return Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   FamilyCard(familyName: state.familyName),
  //                   const SizedBox(height: 16),
  //                   const Text(
  //                     'Нет членов семьи',
  //                     style: TextStyle(fontSize: 18, color: Colors.grey),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           } else if (state is FamilyLoadSuccess) {
  //             return Column(
  //               children: [
  //                 FamilyCard(familyName: state.familyName),
  //                 Expanded(
  //                   child: ListView.builder(
  //                     itemCount: state.members.length,
  //                     itemBuilder: (context, index) {
  //                       final member = state.members[index];
  //                       return ListTile(
  //                         title: Text(member.name),
  //                         subtitle: Text(member.email),
  //                         trailing: PopupMenuButton<String>(
  //                           onSelected: (value) {
  //                             // Обработка выбранного действия
  //                             if (value == 'Удалить') {
  //                               final familyId =
  //                                   (state as FamilyLoadSuccess)
  //                                       .familyName; // Получаем ID семьи
  //                               context.read<FamilyBloc>().add(
  //                                 FamilyRemoveMemberRequested(
  //                                   memberId: member.id,
  //                                   familyId: familyId,
  //                                 ),
  //                               );

  //                               ScaffoldMessenger.of(context).showSnackBar(
  //                                 SnackBar(
  //                                   content: Text('Удаление ${member.name}...'),
  //                                 ),
  //                               );
  //                             } else if (value == 'Изменить роль') {
  //                               // Заглушка для изменения роли
  //                               ScaffoldMessenger.of(context).showSnackBar(
  //                                 SnackBar(
  //                                   content: Text(
  //                                     'Изменить роль ${member.name}',
  //                                   ),
  //                                 ),
  //                               );
  //                             }
  //                           },
  //                           itemBuilder:
  //                               (context) => [
  //                                 const PopupMenuItem(
  //                                   value: 'Удалить',
  //                                   child: Text('Удалить'),
  //                                 ),
  //                                 const PopupMenuItem(
  //                                   value: 'Изменить роль',
  //                                   child: Text('Изменить роль'),
  //                                 ),
  //                               ],
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             );
  //           } else if (state is FamilyLoadFailure) {
  //             return Center(child: Text('Ошибка: ${state.error}'));
  //           }
  //           return const SizedBox.shrink();
  //         },
  //       ),
  //     ),
  //     floatingActionButton: PopupMenuButton<String>(
  //       icon: const Icon(Icons.person_add, size: 28), // Иконка кнопки
  //       tooltip: 'Действия с участниками',
  //       onSelected: (value) {
  //         if (value == 'add_member') {
  //           showDialog(
  //             context: context,
  //             builder: (context) => const AddMemberDialog(),
  //           );
  //         } else if (value == 'invite_member') {
  //           showDialog(
  //             context: context,
  //             builder: (context) => const InviteMemberDialog(),
  //           );
  //         }
  //       },
  //       itemBuilder:
  //           (context) => [
  //             const PopupMenuItem(
  //               value: 'add_member',
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.person_add, color: Colors.deepPurple),
  //                   SizedBox(width: 8),
  //                   Text('Добавить участника'),
  //                 ],
  //               ),
  //             ),
  //             const PopupMenuItem(
  //               value: 'invite_member',
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.mail_outline, color: Colors.deepPurple),
  //                   SizedBox(width: 8),
  //                   Text('Пригласить участника'),
  //                 ],
  //               ),
  //             ),
  //           ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Семья')),
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
}
