import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_flow_app_client/family/bloc/family_bloc.dart';

class AddMemberDialog extends StatelessWidget {
  const AddMemberDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    String selectedRole = 'Parent'; // Роль по умолчанию

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
              DropdownMenuItem(value: 'Parent', child: Text('Родитель')),
              DropdownMenuItem(value: 'Child', child: Text('Ребёнок')),
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
                FamilyAddMemberRequested(email: email, role: selectedRole),
              );
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Приглашение отправлено'),
                  duration: const Duration(seconds: 3),
                ),
              );
            } else {
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
  }
}
