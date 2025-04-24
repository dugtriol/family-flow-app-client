import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/wishlist_bloc.dart';

class CreateWishlistButton extends StatelessWidget {
  const CreateWishlistButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'create_wishlist_button',
      onPressed: () => _showCreateWishlistBottomSheet(context),
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showCreateWishlistBottomSheet(BuildContext parentContext) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final linkController = TextEditingController();

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final isFormValid = nameController.text.isNotEmpty;

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
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

                  // Поле для ввода имени
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Добавьте пункт',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const Divider(),

                  // Поле для ввода описания
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 16,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                      16,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Описание',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: descriptionController,
                                      maxLines: 4,
                                      decoration: const InputDecoration(
                                        labelText: 'Введите описание',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(context).pop(),
                                          child: const Text(
                                            'Закрыть',
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.edit, color: Colors.deepPurple),
                            const SizedBox(width: 4),
                            const Text(
                              'Описание',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Поле для ввода ссылки
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 16,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                      16,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Ссылка',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: linkController,
                                      decoration: const InputDecoration(
                                        labelText: 'Введите ссылку',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(context).pop(),
                                          child: const Text(
                                            'Закрыть',
                                            style: TextStyle(
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.link, color: Colors.deepPurple),
                            const SizedBox(width: 4),
                            const Text(
                              'Ссылка',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Кнопка сохранения
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_circle_up,
                              color:
                                  isFormValid ? Colors.deepPurple : Colors.grey,
                              size: 28,
                            ),
                            onPressed:
                                isFormValid
                                    ? () {
                                      final name = nameController.text;
                                      final description =
                                          descriptionController.text.isEmpty
                                              ? ''
                                              : descriptionController.text;
                                      final link =
                                          linkController.text.isEmpty
                                              ? ''
                                              : linkController.text;

                                      // Отправляем событие для создания элемента вишлиста
                                      parentContext.read<WishlistBloc>().add(
                                        WishlistItemCreateRequested(
                                          name: name,
                                          description: description,
                                          link: link,
                                        ),
                                      );

                                      Navigator.of(context).pop();
                                    }
                                    : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
