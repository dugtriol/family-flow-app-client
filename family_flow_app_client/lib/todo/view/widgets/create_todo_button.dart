import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/todo_bloc.dart';
import '../../../family/bloc/family_bloc.dart';

class CreateTodoButton extends StatelessWidget {
  const CreateTodoButton({super.key, required this.currentUserId});

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyBloc, FamilyState>(
      builder: (context, state) {
        // Проверяем, состоит ли пользователь в семье
        final isInFamily =
            state is FamilyLoadSuccess && state.members.isNotEmpty;

        return FloatingActionButton(
          onPressed: () {
            if (isInFamily) {
              _showCreateTodoDialog(context);
            } else {
              // Показываем сообщение, если пользователь не в семье
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Сначала присоединитесь к семье, чтобы создать задачу.',
                  ),
                ),
              );
            }
          },
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.add, color: Colors.white),
        );
      },
    );
  }

  void _showCreateTodoDialog(BuildContext parentContext) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDeadline;
    String? selectedMemberId;

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
                'Создать задачу',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              content: SizedBox(
                width:
                    MediaQuery.of(context).size.width *
                    0.9, // Увеличиваем ширину окна
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: titleController,
                        label: 'Название',
                        icon: Icons.title,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: descriptionController,
                        label: 'Описание',
                        icon: Icons.description,
                        maxLines: 4, // Увеличиваем высоту поля для описания
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<FamilyBloc, FamilyState>(
                        builder: (context, state) {
                          if (state is FamilyLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is FamilyLoadSuccess) {
                            return DropdownButtonFormField<String>(
                              value: selectedMemberId,
                              decoration: const InputDecoration(
                                labelText: 'Назначить на',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              items:
                                  state.members.map((member) {
                                    return DropdownMenuItem<String>(
                                      value: member.id,
                                      child: Text(
                                        member.id == currentUserId
                                            ? 'Себе'
                                            : member.name,
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedMemberId = value;
                                });
                              },
                            );
                          } else if (state is FamilyLoadFailure) {
                            return Text(
                              'Ошибка загрузки членов семьи: ${state.error}',
                              style: const TextStyle(color: Colors.deepPurple),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text(
                            'Дедлайн:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            selectedDeadline != null
                                ? selectedDeadline!.toUtc().toString().split(
                                  ' ',
                                )[0]
                                : 'Выберите дату',
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: dialogContext,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  selectedDeadline = pickedDate;
                                });
                              }
                            },
                          ),
                        ],
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

                    if (selectedDeadline == null || selectedMemberId == null) {
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                        const SnackBar(
                          content: Text('Пожалуйста, заполните все поля'),
                        ),
                      );
                      return;
                    }

                    final formattedDeadline =
                        selectedDeadline!.toUtc().toIso8601String();

                    // Используем parentContext для доступа к TodoBloc
                    parentContext.read<TodoBloc>().add(
                      TodoCreateRequested(
                        title: title,
                        description: description,
                        assignedTo: selectedMemberId!,
                        deadline: DateTime.parse(formattedDeadline),
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
    int maxLines = 1, // Добавлено для управления высотой поля
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint:
            maxLines > 1, // Перемещаем метку вверх для многострочных полей
        prefixIcon:
            maxLines > 1
                ? Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                  ), // Смещаем иконку вверх
                  child: Icon(icon, color: Colors.deepPurple),
                )
                : Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
