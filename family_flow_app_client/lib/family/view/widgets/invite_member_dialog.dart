import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_flow_app_client/family/bloc/family_bloc.dart';

class InviteMemberDialog extends StatelessWidget {
  const InviteMemberDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return AlertDialog(
      title: const Text('Пригласить участника'),
      content: TextField(
        controller: emailController,
        decoration: const InputDecoration(
          labelText: 'Email участника',
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
            final email = emailController.text.trim();
            if (email.isNotEmpty) {
              context.read<FamilyBloc>().add(
                FamilyInviteMemberRequested(email: email, role: 'Child'),
              );
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Приглашение отправлено на $email'),
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
          child: const Text('Пригласить'),
        ),
      ],
    );
  }
}
