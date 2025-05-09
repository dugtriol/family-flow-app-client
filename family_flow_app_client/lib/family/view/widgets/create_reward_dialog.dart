import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_flow_app_client/family/bloc/family_bloc.dart';
import 'package:family_api/family_api.dart';

class CreateRewardDialog extends StatefulWidget {
  const CreateRewardDialog({super.key});

  @override
  State<CreateRewardDialog> createState() => _CreateRewardDialogState();
}

class _CreateRewardDialogState extends State<CreateRewardDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _createReward() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final cost = int.tryParse(_costController.text.trim()) ?? 0;

    if (title.isEmpty || cost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите корректные данные')),
      );
      return;
    }

    final user = context.read<FamilyBloc>().state;
    if (user is! FamilyLoadSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось получить данные семьи')),
      );
      return;
    }

    final rewardInput = RewardCreateInput(
      familyId: user.familyName, // Используйте корректный familyId
      title: title,
      description: description,
      cost: cost,
    );

    context.read<FamilyBloc>().add(CreateRewardRequested(input: rewardInput));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Создать награду'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Стоимость (очки)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(onPressed: _createReward, child: const Text('Создать')),
      ],
    );
  }
}
