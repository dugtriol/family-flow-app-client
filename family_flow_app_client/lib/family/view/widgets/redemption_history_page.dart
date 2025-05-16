// import 'package:flutter/material.dart';
// import 'package:family_api/family_api.dart' show RewardRedemption;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:family_flow_app_client/family/bloc/family_bloc.dart';
// import 'package:intl/intl.dart'; // Для форматирования даты

// class RedemptionHistoryPage extends StatelessWidget {
//   final List<RewardRedemption> redemptionHistory;

//   const RedemptionHistoryPage({required this.redemptionHistory, super.key});

//   Future<void> _refreshHistory(BuildContext context) async {
//     context.read<FamilyBloc>().add(FamilyRequested());
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Группируем награды по дате
//     final groupedHistory = _groupByDate(redemptionHistory);

//     return Scaffold(
//       appBar: AppBar(title: const Text('История обменов')),
//       body: RefreshIndicator(
//         onRefresh: () => _refreshHistory(context),
//         child:
//             groupedHistory.isEmpty
//                 ? const Center(
//                   child: Text(
//                     'История обменов пуста',
//                     style: TextStyle(fontSize: 16, color: Colors.black54),
//                   ),
//                 )
//                 : ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: groupedHistory.length,
//                   itemBuilder: (context, index) {
//                     final date = groupedHistory.keys.elementAt(index);
//                     final items = groupedHistory[date]!;

//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Отображение даты
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           child: Text(
//                             DateFormat('d MMM yyyy', 'ru').format(date),
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.deepPurple,
//                             ),
//                           ),
//                         ),
//                         // Список наград за эту дату
//                         ...items.map(
//                           (redemption) => Card(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             child: ListTile(
//                               title: Text(redemption.reward.title),
//                               leading: const Icon(
//                                 Icons.card_giftcard,
//                                 color: Colors.deepPurple,
//                               ),
//                               trailing: Text(
//                                 '- ${redemption.reward.cost} очков',
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//       ),
//     );
//   }

//   // Метод для группировки наград по дате
//   Map<DateTime, List<RewardRedemption>> _groupByDate(
//     List<RewardRedemption> history,
//   ) {
//     final Map<DateTime, List<RewardRedemption>> grouped = {};

//     for (final redemption in history) {
//       final date = DateTime(
//         redemption.redeemedAt.year,
//         redemption.redeemedAt.month,
//         redemption.redeemedAt.day,
//       ); // Убираем время, оставляем только дату

//       if (grouped[date] == null) {
//         grouped[date] = [];
//       }
//       grouped[date]!.add(redemption);
//     }

//     return grouped;
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:family_api/family_api.dart' show RewardRedemption, User;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:family_flow_app_client/family/bloc/family_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:user_api/user_api.dart' show User; // Для форматирования даты

// class RedemptionHistoryPage extends StatelessWidget {
//   final List<User> children; // Список детей (для родителей)
//   final List<RewardRedemption> redemptionHistory; // История наград (для детей)
//   final bool isParent; // Флаг для проверки роли

//   const RedemptionHistoryPage({
//     required this.children,
//     required this.redemptionHistory,
//     required this.isParent,
//     super.key,
//   });

//   Future<void> _refreshHistory(BuildContext context) async {
//     context.read<FamilyBloc>().add(FamilyRequested());
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   if (isParent) {
//   //     // Родители видят вкладки с историей наград каждого ребенка
//   //     return DefaultTabController(
//   //       length: children.length,
//   //       child: Scaffold(
//   //         appBar: AppBar(
//   //           title: const Text('История наград'),
//   //           bottom: TabBar(
//   //             isScrollable: true,
//   //             tabs:
//   //                 children.map((child) {
//   //                   return Tab(text: child.name);
//   //                 }).toList(),
//   //           ),
//   //         ),
//   //         body: TabBarView(
//   //           children:
//   //               children.map((child) {
//   //                 return _buildChildHistory(context, child);
//   //               }).toList(),
//   //         ),
//   //       ),
//   //     );
//   //   } else {
//   //     // Дети видят только свою историю наград
//   //     return Scaffold(
//   //       appBar: AppBar(title: const Text('История наград')),
//   //       body: _buildHistoryList(context, redemptionHistory),
//   //     );
//   //   }
//   // }
//   @override
//   Widget build(BuildContext context) {
//     if (isParent) {
//       // Родители видят вкладки с историей наград каждого ребенка
//       return DefaultTabController(
//         length: children.length,
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('История наград'),
//             bottom: TabBar(
//               isScrollable: true,
//               tabs:
//                   children.map((child) {
//                     return Tab(text: child.name);
//                   }).toList(),
//             ),
//           ),
//           body: TabBarView(
//             children:
//                 children.map((child) {
//                   return _buildChildHistory(context, child);
//                 }).toList(),
//           ),
//         ),
//       );
//     } else {
//       // Дети видят только свою историю наград
//       return Scaffold(
//         appBar: AppBar(title: const Text('История наград')),
//         body: _buildHistoryList(context, redemptionHistory),
//       );
//     }
//   }

//   Widget _buildChildHistory(BuildContext context, User child) {
//     final state = context.read<FamilyBloc>().state;

//     if (state is FamilyLoadSuccess) {
//       // Проверяем, есть ли история наград для ребенка
//       final childRedemptions =
//           state.redemptionHistory
//               .where((redemption) => redemption.userId == child.id)
//               .toList();

//       if (childRedemptions.isEmpty) {
//         // Если история наград отсутствует, запрашиваем её
//         context.read<FamilyBloc>().add(GetRedemptionsRequested(child.id));
//         return const Center(child: CircularProgressIndicator());
//       }

//       return RefreshIndicator(
//         onRefresh: () async {
//           context.read<FamilyBloc>().add(GetRedemptionsRequested(child.id));
//         },
//         child: _buildHistoryList(context, childRedemptions),
//       );
//     }

//     return const Center(
//       child: Text(
//         'Не удалось загрузить историю наград.',
//         style: TextStyle(fontSize: 16, color: Colors.black54),
//       ),
//     );
//   }

//   Widget _buildHistoryList(
//     BuildContext context,
//     List<RewardRedemption> history,
//   ) {
//     // Группируем награды по дате
//     final groupedHistory = _groupByDate(history);

//     return groupedHistory.isEmpty
//         ? const Center(
//           child: Text(
//             'История обменов пуста',
//             style: TextStyle(fontSize: 16, color: Colors.black54),
//           ),
//         )
//         : ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: groupedHistory.length,
//           itemBuilder: (context, index) {
//             final date = groupedHistory.keys.elementAt(index);
//             final items = groupedHistory[date]!;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Отображение даты
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Text(
//                     DateFormat('d MMM yyyy', 'ru').format(date),
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                 ),
//                 // Список наград за эту дату
//                 ...items.map(
//                   (redemption) => Card(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     child: ListTile(
//                       title: Text(redemption.reward.title),
//                       leading: const Icon(
//                         Icons.card_giftcard,
//                         color: Colors.deepPurple,
//                       ),
//                       trailing: Text(
//                         '- ${redemption.reward.cost} очков',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//   }

//   // Метод для группировки наград по дате
//   Map<DateTime, List<RewardRedemption>> _groupByDate(
//     List<RewardRedemption> history,
//   ) {
//     final Map<DateTime, List<RewardRedemption>> grouped = {};

//     for (final redemption in history) {
//       final date = DateTime(
//         redemption.redeemedAt.year,
//         redemption.redeemedAt.month,
//         redemption.redeemedAt.day,
//       ); // Убираем время, оставляем только дату

//       if (grouped[date] == null) {
//         grouped[date] = [];
//       }
//       grouped[date]!.add(redemption);
//     }

//     return grouped;
//   }
// }

import 'package:flutter/material.dart';
import 'package:family_api/family_api.dart' show RewardRedemption, User;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_flow_app_client/family/bloc/family_bloc.dart';
import 'package:intl/intl.dart';
import 'package:user_api/user_api.dart' show User;

class RedemptionHistoryPage extends StatefulWidget {
  final List<User> children; // Список детей (для родителей)
  final List<RewardRedemption> redemptionHistory; // История наград (для детей)
  final bool isParent; // Флаг для проверки роли

  const RedemptionHistoryPage({
    required this.children,
    required this.redemptionHistory,
    required this.isParent,
    super.key,
  });

  @override
  State<RedemptionHistoryPage> createState() => _RedemptionHistoryPageState();
}

class _RedemptionHistoryPageState extends State<RedemptionHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, List<RewardRedemption>> _cachedHistories = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.children.length, vsync: this);

    // Если это родитель, загружаем историю первого ребёнка по умолчанию
    if (widget.isParent && widget.children.isNotEmpty) {
      _loadChildHistory(widget.children.first.id);
    }

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final selectedChild = widget.children[_tabController.index];
        _loadChildHistory(selectedChild.id);
      }
    });
  }

  Future<void> _loadChildHistory(String childId) async {
    if (_cachedHistories.containsKey(childId))
      return; // Используем кэшированные данные

    context.read<FamilyBloc>().add(GetRedemptionsRequested(childId));
  }

  Future<void> _refreshHistory(BuildContext context, String? childId) async {
    if (childId != null) {
      _cachedHistories.remove(childId); // Удаляем кэшированные данные
      _loadChildHistory(childId);
    } else {
      context.read<FamilyBloc>().add(FamilyRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isParent) {
      // Родители видят вкладки с историей наград каждого ребёнка
      return DefaultTabController(
        length: widget.children.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('История наград'),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs:
                  widget.children.map((child) {
                    return Tab(text: child.name);
                  }).toList(),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children:
                widget.children.map((child) {
                  return BlocBuilder<FamilyBloc, FamilyState>(
                    builder: (context, state) {
                      print('RedemptionHistoryPage – Состояние: $state');
                      if (state is FamilyLoadSuccess) {
                        final childRedemptions =
                            state.redemptionHistory
                                .where(
                                  (redemption) => redemption.userId == child.id,
                                )
                                .toList();

                        // if (childRedemptions.isEmpty &&
                        //     !_cachedHistories.containsKey(child.id)) {
                        //   return const Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        // }

                        _cachedHistories[child.id] = childRedemptions;

                        return RefreshIndicator(
                          onRefresh: () => _refreshHistory(context, child.id),
                          child: _buildHistoryList(context, childRedemptions),
                        );
                      } else if (state is FamilyLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FamilyLoadFailure) {
                        return Center(
                          child: Text(
                            'Ошибка: ${state.error}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                }).toList(),
          ),
        ),
      );
    } else {
      // Дети видят только свою историю наград
      return Scaffold(
        appBar: AppBar(title: const Text('История наград')),
        body: RefreshIndicator(
          onRefresh: () => _refreshHistory(context, null),
          child: _buildHistoryList(context, widget.redemptionHistory),
        ),
      );
    }
  }

  Widget _buildHistoryList(
    BuildContext context,
    List<RewardRedemption> history,
  ) {
    // Группируем награды по дате
    final groupedHistory = _groupByDate(history);

    return groupedHistory.isEmpty
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
