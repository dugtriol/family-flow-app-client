import 'package:family_api/family_api.dart' show Reward, RewardRedemption;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_flow_app_client/family/bloc/family_bloc.dart';
import 'package:user_api/user_api.dart' show User;

import '../../authentication/authentication.dart';
import 'widgets/widgets.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  String _filter = 'all';
  String _sort = 'cost';

  Future<void> _refreshFamily(BuildContext context) async {
    context.read<FamilyBloc>().add(FamilyRequested());
  }

  void _redeemReward(BuildContext context, String rewardId) {
    context.read<FamilyBloc>().add(RedeemRewardRequested(rewardId: rewardId));
  }

  void _navigateToHistory(
    BuildContext context,
    List<RewardRedemption> redemptionHistory,
    List<User> children,
    bool isParent,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => RedemptionHistoryPage(
              children: children,
              redemptionHistory: redemptionHistory,
              isParent: isParent,
            ),
      ),
    );
  }

  List<Reward> _applyFilterAndSort(List<Reward> rewards, int userPoints) {
    // Фильтрация
    List<Reward> filteredRewards;
    if (_filter == 'available') {
      filteredRewards =
          rewards.where((reward) => userPoints >= reward.cost).toList();
    } else if (_filter == 'unavailable') {
      filteredRewards =
          rewards.where((reward) => userPoints < reward.cost).toList();
    } else {
      filteredRewards = rewards;
    }

    // Сортировка
    if (_sort == 'cost') {
      filteredRewards.sort((a, b) => a.cost.compareTo(b.cost));
    } else if (_sort == 'title') {
      filteredRewards.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sort == 'newest') {
      filteredRewards.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      ); // Новизна
    }

    return filteredRewards;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthenticationBloc>().state.user;
    final isParent = currentUser?.role == 'Parent';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вознаграждения'),
        actions: [
          BlocBuilder<FamilyBloc, FamilyState>(
            builder: (context, state) {
              if (state is FamilyLoadSuccess) {
                return IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: 'История обменов',
                  onPressed:
                      () => _navigateToHistory(
                        context,
                        state.redemptionHistory,
                        state.members
                            .where((member) => member.role == 'Child')
                            .toList(),
                        currentUser.role == 'Parent',
                      ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                if (value == 'available' ||
                    value == 'unavailable' ||
                    value == 'all') {
                  _filter = value;
                } else {
                  _sort = value;
                }
              });
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'available',
                    child: Text('Доступные награды'),
                  ),
                  const PopupMenuItem(
                    value: 'unavailable',
                    child: Text('Недоступные награды'),
                  ),
                  const PopupMenuItem(value: 'all', child: Text('Все награды')),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'cost',
                    child: Text('Сортировать по стоимости'),
                  ),
                  const PopupMenuItem(
                    value: 'title',
                    child: Text('Сортировать по названию'),
                  ),
                  const PopupMenuItem(
                    value: 'newest',
                    child: Text('Сортировать по новизне'),
                  ),
                ],
          ),
          // IconButton(
          //   icon: const Icon(Icons.history),
          //   tooltip: 'История обменов',
          //   onPressed:
          //       () => _navigateToHistory(context, state.redemptionHistory),
          // ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshFamily(context),
        child: BlocBuilder<FamilyBloc, FamilyState>(
          builder: (context, state) {
            if (state is FamilyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FamilyLoadFailure) {
              return Center(child: Text('Ошибка: ${state.error}'));
            } else if (state is FamilyLoadSuccess) {
              final rewards = _applyFilterAndSort(
                state.rewards,
                state.userPoints,
              );
              final userPoints = state.userPoints;
              final userName = state.userName;

              return Column(
                children: [
                  // Карточка с информацией о пользователе
                  UserInfoCard(
                    userName: userName,
                    userPoints: isParent ? null : userPoints,
                    isParent: isParent,
                    avatarUrl: currentUser.avatar,
                  ),

                  // Объяснение списка наград
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      isParent
                          ? 'Здесь вы можете управлять наградами для вашей семьи.'
                          : 'Выберите награду, чтобы обменять свои очки. '
                              'Награды доступны только при достаточном количестве очков.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Список наград
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: rewards.length,
                      itemBuilder: (context, index) {
                        final reward = rewards[index];
                        return RewardTile(
                          userPoints: userPoints,
                          reward: reward,
                          onRedeem: () => _redeemReward(context, reward.id),
                          isParent: currentUser.role == 'Parent',
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton:
          isParent
              ? FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const CreateRewardDialog(),
                  );
                },
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}
