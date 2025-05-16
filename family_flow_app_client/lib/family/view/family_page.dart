import 'package:family_flow_app_client/authentication/authentication.dart';
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
        title: const Text(
          'Семья',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                Colors
                    .black, // Цвет текста (можно изменить под тему приложения)
          ),
        ),
        actions: [
          BlocBuilder<FamilyBloc, FamilyState>(
            builder: (context, state) {
              if (state is FamilyLoadSuccess) {
                // Показываем кнопку только если пользователь состоит в семье
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RewardsPage()),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.card_giftcard,
                        color: Colors.black, // Цвет иконки
                      ),
                      const SizedBox(
                        width: 8,
                      ), // Отступ между иконкой и текстом
                      const Text(
                        'Вознаграждения',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Цвет текста
                        ),
                      ),
                    ],
                  ),
                );
              }
              // Если пользователь не состоит в семье, не показываем кнопку
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 16),
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
                    // ElevatedButton(
                    //   onPressed: () {
                    //     showDialog(
                    //       context: context,
                    //       builder: (context) => const JoinFamilyDialog(),
                    //     );
                    //   },
                    //   child: const Text('Присоединиться к семье'),
                    // ),
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
              return const Center(
                child: Text(
                  'Что-то пошло не так. Перезагрузите приложение.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey, // Красный цвет для выделения ошибки
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: BlocBuilder<FamilyBloc, FamilyState>(
        builder: (context, state) {
          if (state is FamilyLoadSuccess) {
            // Показываем кнопку только если пользователь состоит в семье
            return FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddMemberDialog(),
                );
              },
              tooltip: 'Добавить участника',
              child: const Icon(Icons.person_add),
            );
          }
          // Если пользователь не состоит в семье, не показываем кнопку
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, User member) {
    final currentUser = context.read<AuthenticationBloc>().state.user;
    final isParent =
        currentUser?.role ==
        'Parent'; // Проверяем, является ли текущий пользователь родителем
    final isSelf =
        currentUser?.id ==
        member.id; // Проверяем, является ли это текущий пользователь

    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.deepPurple,
        backgroundImage:
            member.avatar != null && member.avatar!.isNotEmpty
                ? NetworkImage(member.avatar!) // Загружаем аватар, если он есть
                : null,
        child:
            member.avatar == null || member.avatar!.isEmpty
                ? Text(
                  member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
                : null,
      ),
      title: Text(member.name),
      subtitle: Text(member.email),
      onTap: () {
        UserDetailBottomSheet.show(context, member);
      },
      trailing:
          (isParent ||
                  isSelf) // Кнопка "Удалить" доступна только родителям или самому пользователю
              ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Удалить') {
                    final familyId =
                        context.read<FamilyBloc>().state is FamilyLoadSuccess
                            ? (context.read<FamilyBloc>().state
                                    as FamilyLoadSuccess)
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
                  }
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'Удалить',
                        child: Text('Удалить'),
                      ),
                    ],
              )
              : null, // Если пользователь не родитель и не сам себя, кнопка не отображается
    );
  }
}
