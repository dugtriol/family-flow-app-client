// import 'package:family_api/family_api.dart' show Reward;
// import 'package:flutter/material.dart';

// import 'widgets.dart';

// class RewardTile extends StatelessWidget {
//   // final String title;
//   // final String description;
//   final int userPoints;
//   // final int rewardCost;
//   final Reward reward;
//   final VoidCallback onRedeem;

//   const RewardTile({
//     // required this.title,
//     // required this.description,
//     required this.userPoints,
//     // required this.rewardCost,
//     required this.reward,
//     required this.onRedeem,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final progress = (userPoints / reward.cost).clamp(
//       0.0,
//       1.0,
//     ); // Рассчитываем прогресс
//     final canRedeem = userPoints >= reward.cost; // Проверяем, хватает ли очков

//     return GestureDetector(
//       onTap: () {
//         // Показать диалог с деталями награды
//         // showDialog(
//         //   context: context,
//         //   builder:
//         //       (context) => RewardDetailsBottomSheet(
//         //         reward: reward,
//         //         userPoints: userPoints,
//         //         onRedeem: onRedeem,
//         //       ),
//         // );
//         RewardDetailsBottomSheet.show(context, reward, userPoints, onRedeem);
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 4,
//         color:
//             canRedeem
//                 ? Colors.green[50]
//                 : Colors.white, // Выделение доступных наград
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Название награды
//               Text(
//                 reward.title,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: canRedeem ? Colors.green : Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 8),

//               // Прогресс-бар
//               Row(
//                 children: [
//                   Expanded(
//                     child: LinearProgressIndicator(
//                       value: progress,
//                       backgroundColor: Colors.grey[300],
//                       color: progress >= 1.0 ? Colors.green : Colors.deepPurple,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     '${(progress * 100).toInt()}%', // Процент выполнения
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),

//               // Очки пользователя и стоимость награды
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Ваши очки: $userPoints',
//                     style: const TextStyle(fontSize: 14, color: Colors.black54),
//                   ),
//                   Text(
//                     'Стоимость: ${reward.cost}',
//                     style: const TextStyle(fontSize: 14, color: Colors.black54),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),

//               // Кнопка "Обменять"
//               if (canRedeem)
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: ElevatedButton(
//                     onPressed: onRedeem,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                     ),
//                     child: const Text(
//                       'Обменять',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:family_api/family_api.dart' show Reward;
import 'package:flutter/material.dart';

import 'widgets.dart';

class RewardTile extends StatelessWidget {
  final int userPoints;
  final Reward reward;
  final VoidCallback onRedeem;
  final bool isParent; // Добавляем флаг для проверки роли

  const RewardTile({
    required this.userPoints,
    required this.reward,
    required this.onRedeem,
    required this.isParent, // Передаём флаг роли
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (userPoints / reward.cost).clamp(
      0.0,
      1.0,
    ); // Рассчитываем прогресс
    final canRedeem = userPoints >= reward.cost; // Проверяем, хватает ли очков

    return GestureDetector(
      onTap: () {
        RewardDetailsBottomSheet.show(context, reward, userPoints, onRedeem);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        color:
            canRedeem
                ? Colors.green[50]
                : Colors.white, // Выделение доступных наград
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Название награды
              Text(
                reward.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: canRedeem ? Colors.green : Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Прогресс-бар (только для детей)
              if (!isParent)
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        color:
                            progress >= 1.0 ? Colors.green : Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(progress * 100).toInt()}%', // Процент выполнения
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              if (!isParent) const SizedBox(height: 8),

              // Очки пользователя и стоимость награды
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isParent)
                    Text(
                      'Ваши очки: $userPoints',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  Text(
                    'Стоимость: ${reward.cost}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Кнопка "Обменять" (только для детей)
              if (!isParent && canRedeem)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onRedeem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Обменять',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
