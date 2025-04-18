import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_flow_app_client/family/bloc/family_bloc.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Семья'),
      ),
      body: BlocBuilder<FamilyBloc, FamilyState>(
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
                      _showCreateFamilyDialog(context);
                    },
                    child: const Text('Создать семью'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showJoinFamilyDialog(context);
                    },
                    child: const Text('Присоединиться к семье'),
                  ),
                ],
              ),
            );
          } else if (state is FamilyNoMembers) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Семья: ${state.familyName}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Нет членов семьи',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else if (state is FamilyLoadSuccess) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Семья: ${state.familyName}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.members.length,
                    itemBuilder: (context, index) {
                      final member = state.members[index];
                      return ListTile(
                        title: Text(member.name),
                        subtitle: Text(member.email),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            // Обработка выбранного действия
                            if (value == 'Удалить') {
                              // Заглушка для удаления
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Удалить ${member.name}'),
                                ),
                              );
                            } else if (value == 'Изменить роль') {
                              // Заглушка для изменения роли
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Изменить роль ${member.name}'),
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'Удалить',
                              child: Text('Удалить'),
                            ),
                            const PopupMenuItem(
                              value: 'Изменить роль',
                              child: Text('Изменить роль'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is FamilyLoadFailure) {
            return Center(
              child: Text('Ошибка: ${state.error}'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_member_button',
        onPressed: () {
          _showAddMemberDialog(context);
        },
        child: const Icon(Icons.person_add),
        tooltip: 'Добавить участника',
      ),
    );
  }

  void _showCreateFamilyDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Создать семью'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Название семьи'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<FamilyBloc>()
                    .add(FamilyCreateRequested(name: controller.text));
                Navigator.of(context).pop();
              },
              child: const Text('Создать'),
            ),
          ],
        );
      },
    );
  }

  void _showJoinFamilyDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Присоединиться к семье'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'ID семьи'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<FamilyBloc>()
                    .add(FamilyJoinRequested(familyId: controller.text));
                Navigator.of(context).pop();
              },
              child: const Text('Присоединиться'),
            ),
          ],
        );
      },
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final emailController = TextEditingController();
    String selectedRole = 'Parent'; // Роль по умолчанию

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить участника'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email участника'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Роль участника',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Parent',
                    child: Text('Родитель'),
                  ),
                  DropdownMenuItem(
                    value: 'Child',
                    child: Text('Ребёнок'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    selectedRole = value;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isNotEmpty) {
                  context.read<FamilyBloc>().add(
                        FamilyAddMemberRequested(
                          email: email,
                          role: selectedRole,
                        ),
                      );
                  Navigator.of(context).pop();

                  // Отображение плашки с уведомлением
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Приглашение отправлено'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } else {
                  // Отображение ошибки, если поле пустое
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Введите email участника'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}
