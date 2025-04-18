import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/shopping_bloc.dart';

class CreateShoppingButton extends StatelessWidget {
  const CreateShoppingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'create_shopping_button',
      onPressed: () => _showCreateShoppingDialog(context),
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showCreateShoppingDialog(BuildContext parentContext) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedVisibility = 'Public';

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Создать элемент покупок',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: titleController,
                        label: 'Название',
                        icon: Icons.shopping_cart,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: descriptionController,
                        label: 'Описание',
                        icon: Icons.description,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedVisibility,
                        decoration: const InputDecoration(
                          labelText: 'Видимость',
                          prefixIcon: Icon(Icons.visibility),
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Public',
                            child: Text('Доступно всем'),
                          ),
                          DropdownMenuItem(
                            value: 'Private',
                            child: Text('Личное'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedVisibility = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Отмена',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text;
                    var description = descriptionController.text;

                    // Устанавливаем заглушку для пустого описания
                    if (description.isEmpty) {
                      description = 'Без описания';
                    }

                    if (title.isEmpty || selectedVisibility == null) {
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        const SnackBar(
                          content: Text('Пожалуйста, заполните все поля'),
                        ),
                      );
                      return;
                    }

                    // Отправляем событие для создания элемента покупок
                    parentContext.read<ShoppingBloc>().add(
                      ShoppingItemCreateRequested(
                        title: title,
                        description: description,
                        visibility: selectedVisibility!,
                      ),
                    );

                    Navigator.of(dialogContext).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Создать',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: maxLines > 1,
        prefixIcon:
            maxLines > 1
                ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Icon(icon, color: Colors.deepPurple),
                )
                : Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
