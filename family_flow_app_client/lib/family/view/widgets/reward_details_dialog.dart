import 'package:flutter/material.dart';
import 'package:family_api/family_api.dart' show Reward;
import 'package:intl/intl.dart'; // Импортируем intl для форматирования даты

class RewardDetailsBottomSheet {
  static void show(
    BuildContext context,
    Reward reward,
    int userPoints,
    VoidCallback onRedeem,
  ) {
    final canRedeem = userPoints >= reward.cost;

    // Форматируем дату
    final formattedDate = DateFormat(
      'd MMM yyyy',
      'ru',
    ).format(reward.createdAt);

    // Рассчитываем прогресс
    final progress = (userPoints / reward.cost).clamp(0.0, 1.0);

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

              // Название награды
              Text(
                reward.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Описание награды
              Text(
                reward.description.isNotEmpty
                    ? reward.description
                    : 'Описание отсутствует',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              // Дата создания
              Text(
                'Создано: $formattedDate',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              // Прогресс-бар
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Прогресс:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    color: progress >= 1.0 ? Colors.green : Colors.deepPurple,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progress * 100).toInt()}% выполнено',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
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
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    'Стоимость: ${reward.cost}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Кнопки
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Закрыть',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        canRedeem
                            ? () {
                              onRedeem();
                              Navigator.of(context).pop();
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canRedeem ? Colors.green : Colors.grey,
                    ),
                    child: const Text('Обменять'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
