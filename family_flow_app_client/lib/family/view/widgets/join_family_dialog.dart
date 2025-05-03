import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_flow_app_client/family/bloc/family_bloc.dart';

class JoinFamilyDialog extends StatelessWidget {
  const JoinFamilyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

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
            context.read<FamilyBloc>().add(
              FamilyJoinRequested(familyId: controller.text),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Присоединиться'),
        ),
      ],
    );
  }
}
