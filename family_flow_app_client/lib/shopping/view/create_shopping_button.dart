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
      child: const Icon(Icons.add),
    );
  }

  void _showCreateShoppingDialog(BuildContext parentContext) {
    final titleController = TextEditingController();
    final descriptionController =
        TextEditingController(); // Добавляем контроллер для description
    String? selectedVisibility = 'Public'; // Default visibility

    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                'Create Shopping Item',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        prefixIcon: Icon(Icons.shopping_cart),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller:
                          descriptionController, // Используем контроллер для description
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedVisibility,
                      decoration: const InputDecoration(
                        labelText: 'Visibility',
                        prefixIcon: Icon(Icons.visibility),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Public',
                          child: Text('Public'),
                        ),
                        DropdownMenuItem(
                          value: 'Private',
                          child: Text('Private'),
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
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text;
                    final description = descriptionController
                        .text; // Получаем значение description

                    if (title.isEmpty ||
                        description.isEmpty ||
                        selectedVisibility == null) {
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields'),
                        ),
                      );
                      return;
                    }

                    // Отправляем событие для создания Shopping Item
                    parentContext.read<ShoppingBloc>().add(
                          ShoppingItemCreateRequested(
                            title: title,
                            description: description, // Передаем description
                            visibility: selectedVisibility!,
                          ),
                        );

                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
