import 'package:flutter/material.dart';
import 'package:family_api/family_api.dart' show Reward;
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/authentication.dart';
import '../../family.dart';

class RewardDetailsBottomSheet {
  static void _deleteReward(BuildContext context, String rewardId) {
    context.read<FamilyBloc>().add(DeleteRewardRequested(rewardId));
  }

  static void show(
    BuildContext context,
    Reward reward,
    int userPoints,
    VoidCallback? onRedeem,
  ) {
    final currentUser = context.read<AuthenticationBloc>().state.user;
    final isParent = currentUser?.role == 'Parent';

    final TextEditingController titleController = TextEditingController(
      text: reward.title,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: reward.description,
    );
    final TextEditingController costController = TextEditingController(
      text: reward.cost.toString(),
    );

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
              // Верхний индикатор для смахивания
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

              if (isParent) ...[
                // Поля для редактирования награды
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Название награды',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание награды',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: costController,
                  decoration: const InputDecoration(
                    labelText: 'Стоимость награды',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _deleteReward(context, reward.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Удалить'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final updatedReward = Reward(
                          id: reward.id,
                          title: titleController.text,
                          description: descriptionController.text,
                          cost:
                              int.tryParse(costController.text) ?? reward.cost,
                          familyId: reward.familyId,
                          createdAt: reward.createdAt,
                          updatedAt: reward.updatedAt,
                        );

                        Navigator.of(context).pop();
                        _updateReward(context, updatedReward);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Сохранить'),
                    ),
                  ],
                ),
              ] else ...[
                // Информация о награде (для детей)
                Text(
                  reward.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  reward.description.isNotEmpty
                      ? reward.description
                      : 'Описание отсутствует',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                Text(
                  'Создано: ${DateFormat('d MMM yyyy', 'ru').format(reward.createdAt)}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 16),

                // Прогресс-бар
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Прогресс:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (userPoints / reward.cost).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[300],
                      color:
                          userPoints >= reward.cost
                              ? Colors.green
                              : Colors.deepPurple,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${((userPoints / reward.cost) * 100).toInt()}% выполнено',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Очки пользователя и стоимость награды
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ваши очки: $userPoints',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'Стоимость: ${reward.cost}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Кнопка "Обменять"
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed:
                        userPoints >= reward.cost && onRedeem != null
                            ? () {
                              onRedeem();
                              Navigator.of(context).pop();
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          userPoints >= reward.cost
                              ? Colors.green
                              : Colors.grey,
                    ),
                    child: const Text('Обменять'),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  static void _updateReward(BuildContext context, Reward updatedReward) {
    context.read<FamilyBloc>().add(UpdateRewardRequested(updatedReward));
  }
}
