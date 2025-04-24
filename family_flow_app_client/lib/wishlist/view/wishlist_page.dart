import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authentication/authentication.dart';
import '../../family/family.dart';
import '../bloc/wishlist_bloc.dart';
import 'widgets/widgets.dart';

// class WishlistPage extends StatefulWidget {
//   const WishlistPage({super.key});

//   @override
//   State<WishlistPage> createState() => _WishlistPageState();
// }

// class _WishlistPageState extends State<WishlistPage> {
//   String? _selectedFamilyMember; // Выбранный член семьи
//   List<String> _familyMembers = []; // Список членов семьи

//   @override
//   void initState() {
//     super.initState();
//     // Инициализация списка членов семьи (заглушка, заменить на реальные данные)
//     _familyMembers = ['Мой список', 'Иван', 'Мария', 'Анна'];
//     _selectedFamilyMember = _familyMembers.first;
//   }

//   void _onFamilyMemberChanged(String? newValue) {
//     setState(() {
//       _selectedFamilyMember = newValue;
//     });

//     // Отправляем событие для загрузки вишлиста выбранного члена семьи
//     // context.read<WishlistBloc>().add(
//     //   WishlistRequestedForMember(memberName: newValue!),
//     // );
//   }

//   Future<void> _refreshWishlist() async {
//     // Отправляем событие для обновления списка желаний
//     context.read<WishlistBloc>().add(WishlistRequested());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // DropdownButton для выбора члена семьи
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: DropdownButton<String>(
//               value: _selectedFamilyMember,
//               isExpanded: true,
//               items:
//                   _familyMembers.map((String member) {
//                     return DropdownMenuItem<String>(
//                       value: member,
//                       child: Text(
//                         member,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//               onChanged: _onFamilyMemberChanged,
//               underline: Container(height: 2, color: Colors.deepPurple),
//             ),
//           ),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: _refreshWishlist,
//               child: BlocBuilder<WishlistBloc, WishlistState>(
//                 builder: (context, state) {
//                   if (state is WishlistLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is WishlistLoadSuccess) {
//                     if (state.items.isEmpty) {
//                       return ListView(
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         children: const [
//                           Center(
//                             child: Padding(
//                               padding: EdgeInsets.all(16.0),
//                               child: Text(
//                                 'Список желаний пуст.\nПотяните вниз, чтобы обновить список.',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black54,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     }
//                     return ListView.builder(
//                       itemCount: state.items.length,
//                       itemBuilder: (context, index) {
//                         final item = state.items[index];
//                         final currentUserId =
//                             context.read<AuthenticationBloc>().state.user?.id;
//                         final isOwner = item.createdBy == currentUserId;

//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder:
//                                     (_) => BlocProvider.value(
//                                       value: context.read<WishlistBloc>(),
//                                       child: WishlistDetailsDialog(
//                                         item: item,
//                                         isOwner: isOwner,
//                                       ),
//                                     ),
//                               ),
//                             );
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 4),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                               ),
//                               leading: Icon(
//                                 item.status == 'Completed'
//                                     ? Icons.card_giftcard
//                                     : item.isReserved
//                                     ? Icons.check_circle
//                                     : Icons.radio_button_unchecked,
//                                 color:
//                                     item.status == 'Completed'
//                                         ? Colors.blue
//                                         : item.isReserved
//                                         ? Colors.green
//                                         : Colors.deepPurple,
//                                 size: 24,
//                               ),
//                               title: Text(
//                                 item.name,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 14,
//                                   color:
//                                       item.status == 'Completed'
//                                           ? Colors.blue
//                                           : Colors.black87,
//                                   decoration:
//                                       item.status == 'Completed'
//                                           ? TextDecoration.lineThrough
//                                           : TextDecoration.none,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               trailing: const Icon(
//                                 Icons.arrow_forward_ios,
//                                 color: Colors.deepPurple,
//                                 size: 14,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   } else if (state is WishlistLoadFailure) {
//                     return ListView(
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       children: [
//                         Center(
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Text(
//                               'Не удалось загрузить список желаний.\nПотяните вниз, чтобы обновить список.',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.red,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//                   return ListView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     children: const [
//                       Center(
//                         child: Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Text(
//                             'Потяните вниз, чтобы обновить список.',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black54,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: const CreateWishlistButton(),
//     );
//   }
// }

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
                  final familyMembers = state.members;
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

                        return GestureDetector(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              leading: Icon(
                                item.status == 'Completed'
                                    ? Icons.card_giftcard
                                    : item.status == 'Reserved'
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color:
                                    item.status == 'Completed'
                                        ? Colors.blue
                                        : item.status == 'Reserved'
                                        ? Colors.green
                                        : Colors.deepPurple,
                                size: 24,
                              ),
                              title: Text(
                                item.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color:
                                      item.status == 'Completed'
                                          ? Colors.blue
                                          : Colors.black87,
                                  decoration:
                                      item.status == 'Completed'
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.deepPurple,
                                size: 14,
                              ),
                            ),
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
}
