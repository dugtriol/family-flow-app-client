import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shopping_api/shopping_api.dart';

import '../../bloc/shopping_bloc.dart';

class ShoppingDetailsPage extends StatefulWidget {
  const ShoppingDetailsPage({
    super.key,
    required this.item,
    required this.isOwner,
    required this.currentUser,
  });

  final ShoppingItem item;
  final bool isOwner;
  final String currentUser;

  @override
  State<ShoppingDetailsPage> createState() => _ShoppingDetailsPageState();
}

class _ShoppingDetailsPageState extends State<ShoppingDetailsPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  bool isPublic = false;

  late String initialTitle;
  late String initialDescription;
  late bool initialVisibility;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.item.title);
    descriptionController = TextEditingController(
      text: widget.item.description,
    );
    isPublic = widget.item.visibility == 'Public';

    initialTitle = widget.item.title;
    initialDescription = widget.item.description;
    initialVisibility = widget.item.visibility == 'Public';
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('d MMM, HH:mm', 'ru');
    return formatter.format(date);
  }

  Future<void> _updateItemIfChanged({String? status}) async {
    final currentTitle = titleController.text;
    final currentDescription =
        descriptionController.text.isEmpty ? '' : descriptionController.text;
    final currentVisibility = isPublic ? 'Public' : 'Private';

    // Проверяем, изменились ли поля
    final hasChanges =
        currentTitle != initialTitle ||
        currentDescription != initialDescription ||
        currentVisibility != (initialVisibility ? 'Public' : 'Private');

    if (hasChanges || status != null) {
      // Отправляем обновление
      context.read<ShoppingBloc>().add(
        ShoppingItemStatusUpdated(
          id: widget.item.id,
          title: currentTitle,
          description: currentDescription,
          status: status ?? widget.item.status,
          visibility: currentVisibility,
          isArchived: false,
        ),
      );

      // Обновляем начальные значения
      initialTitle = currentTitle;
      initialDescription = currentDescription;
      initialVisibility = isPublic;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
              await _updateItemIfChanged();
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: const Text(
            'Элемент списка',
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
                onPressed: () async {
                  context.read<ShoppingBloc>().add(
                    ShoppingItemDeleted(id: widget.item.id),
                  );

                  // Ждём завершения удаления
                  await Future.delayed(const Duration(milliseconds: 500));

                  // Возвращаемся на предыдущий экран
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            // final updatedItem = await context
            //     .read<ShoppingBloc>()
            //     .getShoppingItemById(widget.item.id);

            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Прямоугольник с содержимым
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
                        // Статус
                        Text(
                          _getStatusText(widget.item.status),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(widget.item.status),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Название
                        Row(
                          children: [
                            Checkbox(
                              value: widget.item.status == 'Completed',
                              onChanged:
                                  widget.item.status == 'Active'
                                      ? (value) {
                                        // Логика изменения статуса на "Куплено"
                                      }
                                      : null,
                            ),
                            Expanded(
                              child: TextField(
                                controller: titleController,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Название',
                                ),
                                enabled: widget.item.status == 'Active',
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        // Описание
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
                                enabled: widget.item.status == 'Active',
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        // Видимость
                        Row(
                          children: [
                            const Icon(
                              Icons.visibility,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Общий доступ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Switch(
                                    value: isPublic,
                                    onChanged:
                                        widget.item.status == 'Active'
                                            ? (value) {
                                              setState(() {
                                                isPublic = value;
                                              });
                                            }
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.person, color: Colors.orange),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                widget.item.reservedBy.entries.first.value != ''
                                    ? 'Зарезервировал: ${context.read<ShoppingBloc>().getUserName(widget.item.reservedBy.entries.first.value)}'
                                    : 'Зарезервировал: Никто',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.shopping_cart,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                widget.item.buyerId.entries.first.value != ''
                                    ? 'Купил: ${context.read<ShoppingBloc>().getUserName(widget.item.buyerId.entries.first.value)}'
                                    : 'Купил: Никто',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        // Дата создания
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Создано пользователем ${context.read<ShoppingBloc>().getUserName(widget.item.createdBy)} ${_formatDate(widget.item.createdAt)}',
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
                if (widget.item.status == 'Active')
                  _buildActionButtonsForActive(),
                if (widget.item.status == 'Reserved' &&
                    widget.item.createdBy == widget.currentUser)
                  _buildActionButtonsForReserved(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtonsForActive() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () async {
              final currentUserId = widget.currentUser;
              if (currentUserId.isNotEmpty) {
                context.read<ShoppingBloc>().add(
                  ShoppingItemReserved(
                    id: widget.item.id,
                    reservedBy: currentUserId,
                  ),
                );

                // Ждём завершения обновления
                await Future.delayed(const Duration(milliseconds: 500));

                // Возвращаемся на предыдущий экран
                if (mounted) {
                  Navigator.of(context).pop();
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Не удалось получить ID пользователя'),
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
          ElevatedButton(
            onPressed: () async {
              final currentUserId = widget.currentUser;
              if (currentUserId.isNotEmpty) {
                context.read<ShoppingBloc>().add(
                  ShoppingItemBought(
                    id: widget.item.id,
                    buyerId: currentUserId,
                  ),
                );

                // Ждём завершения обновления
                await Future.delayed(const Duration(milliseconds: 500));

                // Возвращаемся на предыдущий экран
                if (mounted) {
                  Navigator.of(context).pop();
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Не удалось получить ID пользователя'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Куплено', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsForReserved() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed:
                widget.item.createdBy == widget.currentUser
                    ? () async {
                      context.read<ShoppingBloc>().add(
                        ShoppingItemReservationCancelled(id: widget.item.id),
                      );

                      // Ждём завершения обновления
                      await Future.delayed(const Duration(milliseconds: 500));

                      // Возвращаемся на предыдущий экран
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.item.createdBy == widget.currentUser
                      ? Colors.orange
                      : Colors.grey,
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
          ElevatedButton(
            onPressed:
                widget.item.createdBy == widget.currentUser
                    ? () async {
                      context.read<ShoppingBloc>().add(
                        ShoppingItemStatusUpdated(
                          id: widget.item.id,
                          title: titleController.text,
                          description: descriptionController.text,
                          status: 'Completed',
                          visibility: isPublic ? 'Public' : 'Private',
                          isArchived: false,
                        ),
                      );
                      // Ждём завершения обновления
                      await Future.delayed(const Duration(milliseconds: 500));

                      // Возвращаемся на предыдущий экран
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.item.createdBy == widget.currentUser
                      ? Colors.green
                      : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Куплено'),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Active':
        return 'Нужно купить';
      case 'Reserved':
        return 'Зарезервирован';
      case 'Completed':
        return 'Куплено';
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
