import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authentication/authentication.dart';
import '../bloc/wishlist_bloc.dart';
import 'widgets/widgets.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  String? _selectedFamilyMember; // Выбранный член семьи
  List<String> _familyMembers = []; // Список членов семьи

  @override
  void initState() {
    super.initState();
    // Инициализация списка членов семьи (заглушка, заменить на реальные данные)
    _familyMembers = ['Мой список', 'Иван', 'Мария', 'Анна'];
    _selectedFamilyMember = _familyMembers.first;
  }

  void _onFamilyMemberChanged(String? newValue) {
    setState(() {
      _selectedFamilyMember = newValue;
    });

    // Отправляем событие для загрузки вишлиста выбранного члена семьи
    // context.read<WishlistBloc>().add(
    //   WishlistRequestedForMember(memberName: newValue!),
    // );
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
            child: DropdownButton<String>(
              value: _selectedFamilyMember,
              isExpanded: true,
              items:
                  _familyMembers.map((String member) {
                    return DropdownMenuItem<String>(
                      value: member,
                      child: Text(
                        member,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: _onFamilyMemberChanged,
              underline: Container(height: 2, color: Colors.deepPurple),
            ),
          ),
          Expanded(
            child: BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, state) {
                if (state is WishlistLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WishlistLoadSuccess) {
                  if (state.items.isEmpty) {
                    return const Center(
                      child: Text(
                        'Список желаний пуст.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
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
                          // Открываем диалог с подробной информацией
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return WishlistDetailsDialog(
                                item: item,
                                isOwner: isOwner,
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            leading: Icon(
                              item.isReserved
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color:
                                  item.isReserved
                                      ? Colors.green
                                      : Colors.deepPurple,
                              size: 24,
                            ),
                            title: Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black87,
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
                  return const Center(
                    child: Text(
                      'Не удалось загрузить список желаний.',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  );
                }
                return const Center(
                  child: Text(
                    'Потяните вниз, чтобы обновить список.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'create_wishlist_button',
        onPressed: () {
          _showCreateWishlistDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateWishlistDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final linkController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Создать элемент списка желаний'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Название',
                    prefixIcon: Icon(Icons.text_fields),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: linkController,
                  decoration: const InputDecoration(
                    labelText: 'Ссылка',
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final description = descriptionController.text;
                final link = linkController.text;

                if (name.isEmpty || description.isEmpty || link.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Пожалуйста, заполните все поля'),
                    ),
                  );
                  return;
                }

                context.read<WishlistBloc>().add(
                  WishlistItemCreateRequested(
                    name: name,
                    description: description,
                    link: link,
                  ),
                );

                Navigator.of(dialogContext).pop();
              },
              child: const Text('Создать'),
            ),
          ],
        );
      },
    );
  }
}
