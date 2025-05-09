import 'package:flutter/material.dart';
import 'package:family_api/family_api.dart' show RewardRedemption;
import 'package:intl/intl.dart'; // Для форматирования даты

class RedemptionHistoryPage extends StatelessWidget {
  final List<RewardRedemption> redemptionHistory;

  const RedemptionHistoryPage({required this.redemptionHistory, super.key});

  @override
  Widget build(BuildContext context) {
    // Группируем награды по дате
    final groupedHistory = _groupByDate(redemptionHistory);

    return Scaffold(
      appBar: AppBar(title: const Text('История обменов')),
      body:
          groupedHistory.isEmpty
              ? const Center(
                child: Text(
                  'История обменов пуста',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: groupedHistory.length,
                itemBuilder: (context, index) {
                  final date = groupedHistory.keys.elementAt(index);
                  final items = groupedHistory[date]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Отображение даты
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          DateFormat('d MMM yyyy', 'ru').format(date),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      // Список наград за эту дату
                      ...items.map(
                        (redemption) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(redemption.reward.title),
                            leading: const Icon(
                              Icons.card_giftcard,
                              color: Colors.deepPurple,
                            ),
                            trailing: Text(
                              '- ${redemption.reward.cost} очков',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
    );
  }

  // Метод для группировки наград по дате
  Map<DateTime, List<RewardRedemption>> _groupByDate(
    List<RewardRedemption> history,
  ) {
    final Map<DateTime, List<RewardRedemption>> grouped = {};

    for (final redemption in history) {
      final date = DateTime(
        redemption.redeemedAt.year,
        redemption.redeemedAt.month,
        redemption.redeemedAt.day,
      ); // Убираем время, оставляем только дату

      if (grouped[date] == null) {
        grouped[date] = [];
      }
      grouped[date]!.add(redemption);
    }

    return grouped;
  }
}
