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
                  const Text(
                    'Нет членов семьи',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else if (state is FamilyLoadSuccess) {
            return ListView.builder(
              itemCount: state.members.length,
              itemBuilder: (context, index) {
                final member = state.members[index];
                return ListTile(
                  title: Text(member.name),
                  subtitle: Text(member.email),
                );
              },
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
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить участника'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Email участника'),
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
                    .add(FamilyAddMemberRequested(email: controller.text));
                Navigator.of(context).pop();
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}
