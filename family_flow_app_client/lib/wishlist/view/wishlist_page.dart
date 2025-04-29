import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authentication/authentication.dart';
import '../../family/family.dart';
import '../bloc/wishlist_bloc.dart';
import 'widgets/widgets.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  String? _selectedFamilyMemberId; // Идентификатор выбранного члена семьи

  void _onFamilyMemberChanged(String? newValue) {
    setState(() {
      _selectedFamilyMemberId = newValue;
    });

    // Отправляем событие для загрузки вишлиста выбранного члена семьи
    context.read<WishlistBloc>().add(
      WishlistRequested(
        memberId: newValue,
      ), // Передаём идентификатор члена семьи
    );
  }

  Future<void> _refreshWishlist() async {
    // Отправляем событие для обновления списка желаний
    context.read<WishlistBloc>().add(
      WishlistRequested(memberId: _selectedFamilyMemberId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // DropdownButton для выбора члена семьи
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<FamilyBloc, FamilyState>(
              builder: (context, state) {
                if (state is FamilyLoadSuccess) {
                  final currentUserId =
                      context.read<AuthenticationBloc>().state.user?.id;

                  // Фильтруем текущего пользователя из списка членов семьи
                  final familyMembers =
                      state.members
                          .where((member) => member.id != currentUserId)
                          .toList();

                  final dropdownItems = [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text(
                        'Мой список',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    ...familyMembers.map((member) {
                      return DropdownMenuItem<String>(
                        value: member.id, // Используем ID члена семьи
                        child: Text(
                          member.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ];

                  _selectedFamilyMemberId ??= dropdownItems.first.value;

                  return DropdownButton<String>(
                    value: _selectedFamilyMemberId,
                    isExpanded: true,
                    items: dropdownItems,
                    onChanged: _onFamilyMemberChanged,
                    underline: Container(height: 2, color: Colors.deepPurple),
                  );
                } else if (state is FamilyLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(
                    child: Text(
                      'Не удалось загрузить список семьи.',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshWishlist,
              child: BlocBuilder<WishlistBloc, WishlistState>(
                builder: (context, state) {
                  if (state is WishlistLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WishlistLoadSuccess) {
                    if (state.items.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Список желаний пуст.\nПотяните вниз, чтобы обновить список.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        final currentUserId =
                            context.read<AuthenticationBloc>().state.user?.id;
                        final isOwner = item.createdBy == currentUserId;

                        // return Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 4),
                        //   child: ListTile(
                        //     contentPadding: const EdgeInsets.symmetric(
                        //       horizontal: 16,
                        //     ),
                        //     title: Row(
                        //       children: [
                        //         Expanded(
                        //           child: Text(
                        //             item.name,
                        //             style: const TextStyle(
                        //               fontWeight: FontWeight.w500,
                        //               fontSize: 14,
                        //               color: Colors.black87,
                        //             ),
                        //             maxLines: 1,
                        //             overflow: TextOverflow.ellipsis,
                        //           ),
                        //         ),
                        //         // Отображение статуса
                        //         Container(
                        //           padding: const EdgeInsets.symmetric(
                        //             horizontal: 8,
                        //             vertical: 4,
                        //           ),
                        //           decoration: BoxDecoration(
                        //             color: _getStatusColor(item.status),
                        //             borderRadius: BorderRadius.circular(12),
                        //           ),
                        //           child: Text(
                        //             _getStatusText(item.status),
                        //             style: const TextStyle(
                        //               fontSize: 12,
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     trailing: const Icon(
                        //       Icons.arrow_forward_ios,
                        //       color: Colors.deepPurple,
                        //       size: 14,
                        //     ),
                        //     onTap: () {
                        //       Navigator.of(context).push(
                        //         MaterialPageRoute(
                        //           builder:
                        //               (_) => BlocProvider.value(
                        //                 value: context.read<WishlistBloc>(),
                        //                 child: WishlistDetailsDialog(
                        //                   item: item,
                        //                   isOwner: isOwner,
                        //                 ),
                        //               ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // );
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Отображение статуса
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(item.status),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getStatusText(item.status),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                print('Selected menu option: $value');
                                if (value == 'Зарезервировать') {
                                  final currentUserId =
                                      context
                                          .read<AuthenticationBloc>()
                                          .state
                                          .user
                                          ?.id;
                                  if (currentUserId != null) {
                                    context.read<WishlistBloc>().add(
                                      WishlistItemReserved(
                                        id: item.id,
                                        reservedBy: currentUserId,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Не удалось получить ID пользователя',
                                        ),
                                      ),
                                    );
                                  }
                                } else if (value == 'Отменить резервирование') {
                                  context.read<WishlistBloc>().add(
                                    WishlistItemReservationCancelled(
                                      id: item.id,
                                    ),
                                  );
                                } else if (value == 'Удалить') {
                                  context.read<WishlistBloc>().add(
                                    WishlistItemDeleted(id: item.id),
                                  );
                                }
                              },
                              itemBuilder: (context) {
                                print('Building menu for item: ${item.name}');
                                print(
                                  'Item reservedBy: ${item.reservedBy.entries.first.value}',
                                );
                                print('Item status: ${item.status}');
                                print(
                                  'Current User ID: ${context.read<AuthenticationBloc>().state.user?.id}',
                                );
                                return [
                                  if (item.status == 'Active' &&
                                      item.reservedBy.entries.first.value == '')
                                    const PopupMenuItem(
                                      value: 'Зарезервировать',
                                      child: Text('Зарезервировать'),
                                    ),
                                  if (item.status == 'Reserved' &&
                                      item.reservedBy.entries.first.value ==
                                          context
                                              .read<AuthenticationBloc>()
                                              .state
                                              .user
                                              ?.id)
                                    const PopupMenuItem(
                                      value: 'Отменить резервирование',
                                      child: Text('Отменить резервирование'),
                                    ),
                                  if (isOwner)
                                    const PopupMenuItem(
                                      value: 'Удалить',
                                      child: Text('Удалить'),
                                    ),
                                ];
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.black54,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider.value(
                                        value: context.read<WishlistBloc>(),
                                        child: WishlistDetailsDialog(
                                          item: item,
                                          isOwner: isOwner,
                                        ),
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is WishlistLoadFailure) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Не удалось загрузить список желаний.\nПотяните вниз, чтобы обновить список.',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Потяните вниз, чтобы обновить список.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: const CreateWishlistButton(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Reserved':
        return Colors.orange;
      case 'Active':
      default:
        return Colors.deepPurple;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Completed':
        return 'Подарено';
      case 'Reserved':
        return 'Зарезервировано';
      case 'Active':
      default:
        return 'Активно';
    }
  }
}
