// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../bloc/shopping_bloc.dart';

// class CreateShoppingButton extends StatelessWidget {
//   const CreateShoppingButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       heroTag: 'create_shopping_button',
//       onPressed: () => _showCreateShoppingDialog(context),
//       backgroundColor: Colors.deepPurple,
//       child: const Icon(Icons.add, color: Colors.white),
//     );
//   }

//   void _showCreateShoppingDialog(BuildContext parentContext) {
//     final titleController = TextEditingController();
//     final descriptionController = TextEditingController();
//     String? selectedVisibility = 'Public';

//     showDialog(
//       context: parentContext,
//       builder: (BuildContext dialogContext) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               title: const Text(
//                 'Создать элемент покупок',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: Colors.black87,
//                 ),
//               ),
//               content: SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildTextField(
//                         controller: titleController,
//                         label: 'Название',
//                         icon: Icons.shopping_cart,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         controller: descriptionController,
//                         label: 'Описание',
//                         icon: Icons.description,
//                         maxLines: 4,
//                       ),
//                       const SizedBox(height: 16),
//                       DropdownButtonFormField<String>(
//                         value: selectedVisibility,
//                         decoration: const InputDecoration(
//                           labelText: 'Видимость',
//                           prefixIcon: Icon(Icons.visibility),
//                           border: OutlineInputBorder(),
//                         ),
//                         items: const [
//                           DropdownMenuItem(
//                             value: 'Public',
//                             child: Text('Доступно всем'),
//                           ),
//                           DropdownMenuItem(
//                             value: 'Private',
//                             child: Text('Личное'),
//                           ),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             selectedVisibility = value;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(dialogContext).pop(),
//                   child: const Text(
//                     'Отмена',
//                     style: TextStyle(color: Colors.deepPurple),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     final title = titleController.text;
//                     var description = descriptionController.text;

//                     // Устанавливаем заглушку для пустого описания
//                     if (description.isEmpty) {
//                       description = 'Без описания';
//                     }

//                     if (title.isEmpty || selectedVisibility == null) {
//                       ScaffoldMessenger.of(parentContext).showSnackBar(
//                         const SnackBar(
//                           content: Text('Пожалуйста, заполните все поля'),
//                         ),
//                       );
//                       return;
//                     }

//                     // Отправляем событие для создания элемента покупок
//                     parentContext.read<ShoppingBloc>().add(
//                       ShoppingItemCreateRequested(
//                         title: title,
//                         description: description,
//                         visibility: selectedVisibility!,
//                       ),
//                     );

//                     Navigator.of(dialogContext).pop();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     'Создать',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         alignLabelWithHint: maxLines > 1,
//         prefixIcon:
//             maxLines > 1
//                 ? Padding(
//                   padding: const EdgeInsets.only(top: 16),
//                   child: Icon(icon, color: Colors.deepPurple),
//                 )
//                 : Icon(icon, color: Colors.deepPurple),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/shopping_bloc.dart';

class CreateShoppingButton extends StatelessWidget {
  const CreateShoppingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'create_shopping_button',
      onPressed: () => _showCreateShoppingBottomSheet(context),
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showCreateShoppingBottomSheet(BuildContext parentContext) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isPublic = true; // По умолчанию "Доступен всем"

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final isFormValid = titleController.text.isNotEmpty;

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

                  // Поле для ввода названия
                  TextField(
                    controller: titleController,
                    autofocus: true, // Автоматический фокус
                    decoration: const InputDecoration(
                      hintText: 'Add an item',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const Divider(),

                  // Виджет видимости, описания и сохранения
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Видимость
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isPublic = !isPublic; // Переключение видимости
                          });
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: isPublic,
                              onChanged: (value) {
                                setState(() {
                                  isPublic = value ?? true;
                                });
                              },
                            ),
                            const Text(
                              'Общий доступ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Описание
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

                      // Сохранение
                      IconButton(
                        icon: Icon(
                          Icons.arrow_circle_up,
                          color: isFormValid ? Colors.deepPurple : Colors.grey,
                          size: 28,
                        ),
                        onPressed:
                            isFormValid
                                ? () {
                                  final title = titleController.text;
                                  final description =
                                      descriptionController.text;

                                  // Отправляем событие для создания элемента покупок
                                  parentContext.read<ShoppingBloc>().add(
                                    ShoppingItemCreateRequested(
                                      title: title,
                                      description: description,
                                      visibility:
                                          isPublic ? 'Public' : 'Private',
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
            );
          },
        );
      },
    );
  }
}
