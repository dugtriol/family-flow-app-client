import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart' show User;
import 'package:wishlist_api/wishlist_api.dart';
import '../../../authentication/authentication.dart';
import '../../../family/family.dart';
import '../../bloc/wishlist_bloc.dart';

class WishlistDetailsDialog extends StatefulWidget {
  const WishlistDetailsDialog({
    super.key,
    required this.item,
    required this.isOwner,
  });

  final WishlistItem item;
  final bool isOwner;

  @override
  State<WishlistDetailsDialog> createState() => _WishlistDetailsDialogState();
}

class _WishlistDetailsDialogState extends State<WishlistDetailsDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController linkController;

  late String initialName;
  late String initialDescription;
  late String initialLink;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    descriptionController = TextEditingController(
      text: widget.item.description,
    );
    linkController = TextEditingController(text: widget.item.link ?? '');

    // Сохраняем начальные значения
    initialName = widget.item.name;
    initialDescription = widget.item.description;
    initialLink = widget.item.link ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  Future<void> _updateItemIfChanged({bool? isReserved}) async {
    final currentName = nameController.text;
    final currentDescription =
        descriptionController.text.isEmpty ? '' : descriptionController.text;
    final currentLink = linkController.text.isEmpty ? '' : linkController.text;

    final hasChanges =
        currentName != initialName ||
        currentDescription != initialDescription ||
        currentLink != initialLink;

    if (hasChanges || isReserved != null) {
      context.read<WishlistBloc>().add(
        WishlistItemUpdateRequested(
          id: widget.item.id,
          name: currentName,
          description: currentDescription,
          link: currentLink,
          status: widget.item.status,
          isArchived: widget.item.isArchived,
        ),
      );

      initialName = currentName;
      initialDescription = currentDescription;
      initialLink = currentLink;
    }
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('d MMM, HH:mm', 'ru');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Сохраняем изменения перед выходом
        await _updateItemIfChanged();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () async {
              // Сохраняем изменения перед выходом
              await _updateItemIfChanged();
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: const Text(
            'Детали элемента',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          actions: [
            if (widget.isOwner)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context.read<WishlistBloc>().add(
                    WishlistItemDeleted(id: widget.item.id),
                  );
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(),
                        child: Text(
                          _getStatusText(widget.item.status),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(widget.item.status),
                          ),
                        ),
                      ),
                      // Поле для имени
                      Row(
                        children: [
                          const Icon(Icons.title, color: Colors.deepPurple),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Название',
                              ),
                              enabled: widget.isOwner,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),

                      // Поле для описания
                      Row(
                        children: [
                          const Icon(
                            Icons.description,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: descriptionController,
                              maxLines: null,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Добавить описание',
                              ),
                              enabled: widget.isOwner,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),

                      // Поле для ссылки
                      Row(
                        children: [
                          const Icon(Icons.link, color: Colors.deepPurple),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: linkController,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Добавить ссылку',
                              ),
                              enabled: widget.isOwner,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      // Поле для статуса
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            widget.item.status == 'Reserved'
                                ? 'Зарезервировано'
                                : 'Свободно',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),

                      // Добавляем строку "Кто зарезервировал"
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.person, color: Colors.orange),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              widget.isOwner
                                  ? (widget
                                              .item
                                              .reservedBy
                                              .entries
                                              .first
                                              .value !=
                                          ''
                                      ? 'Кто-то зарезервировал'
                                      : 'Никто не зарезервировал')
                                  : (widget
                                              .item
                                              .reservedBy
                                              .entries
                                              .first
                                              .value !=
                                          ''
                                      ? 'Зарезервировал: ${context.read<WishlistBloc>().getUserName(widget.item.reservedBy.entries.first.value)}'
                                      : 'Никто не зарезервировал'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),

                      // Дата создания
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_time, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            'Создано - ${_formatDate(widget.item.createdAt)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Кнопки действий
              if (widget.item.status != 'Completed')
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //   child: Text(
                //     'Подарено',
                //     style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.green,
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      if (!widget.isOwner && widget.item.status != 'Reserved')
                        ElevatedButton(
                          onPressed: () async {
                            final currentUserId =
                                context
                                    .read<AuthenticationBloc>()
                                    .state
                                    .user
                                    ?.id;
                            if (currentUserId != null) {
                              context.read<WishlistBloc>().add(
                                WishlistItemReserved(
                                  id: widget.item.id,
                                  reservedBy: currentUserId,
                                ),
                              );
                              if (mounted) {
                                Navigator.of(context).pop();
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Не удалось получить ID пользователя',
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Зарезервировать',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      if (!widget.isOwner && widget.item.status == 'Reserved')
                        ElevatedButton(
                          onPressed: () async {
                            context.read<WishlistBloc>().add(
                              WishlistItemReservationCancelled(
                                id: widget.item.id,
                              ),
                            );
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Отменить\nрезервирование',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      if (widget.isOwner)
                        ElevatedButton(
                          onPressed: () async {
                            context.read<WishlistBloc>().add(
                              WishlistItemUpdateRequested(
                                id: widget.item.id,
                                name: nameController.text,
                                description: descriptionController.text,
                                link: linkController.text,
                                status: 'Completed',
                                isArchived: widget.item.isArchived,
                              ),
                            );
                            setState(() {});
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Подарено',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Active':
        return 'Свободно';
      case 'Reserved':
        return 'Зарезервировано';
      case 'Completed':
        return 'Подарено';
      default:
        return 'Неизвестно';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.deepPurple;
      case 'Reserved':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
