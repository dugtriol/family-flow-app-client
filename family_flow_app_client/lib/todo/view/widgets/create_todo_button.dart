import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../authentication/authentication.dart';
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
          heroTag: 'create_todo_button',
          onPressed: () {
            if (isInFamily) {
              _showCreateTodoBottomSheet(context);
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

  void _showCreateTodoBottomSheet(BuildContext parentContext) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final pointsController = TextEditingController(text: '0');
    DateTime? selectedDeadline;
    String? selectedMemberId;
    bool isDescriptionSet = false;
    int? selectedPoints;
    final currentUser = parentContext.read<AuthenticationBloc>().state.user;
    final isParent = currentUser?.role == 'Parent';
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final isFormValid =
                titleController.text.isNotEmpty &&
                selectedDeadline != null &&
                selectedMemberId != null;

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
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Название',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Выбор члена семьи
                  BlocBuilder<FamilyBloc, FamilyState>(
                    builder: (context, state) {
                      if (state is FamilyLoadSuccess) {
                        return DropdownButtonFormField<String>(
                          value: selectedMemberId,
                          decoration: const InputDecoration(
                            labelText: 'Назначить на',
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
                          style: const TextStyle(color: Colors.red),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Выбор дедлайна
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       selectedDeadline != null
                  //           ? 'Дедлайн: ${selectedDeadline!.toLocal()}'.split(
                  //             ' ',
                  //           )[0]
                  //           : 'Выберите дедлайн',
                  //       style: const TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     IconButton(
                  //       icon: const Icon(Icons.calendar_today),
                  //       onPressed: () async {
                  //         final pickedDate = await showDatePicker(
                  //           context: context,
                  //           initialDate: DateTime.now(),
                  //           firstDate: DateTime.now(),
                  //           lastDate: DateTime(2100),
                  //         );
                  //         if (pickedDate != null) {
                  //           setState(() {
                  //             selectedDeadline = pickedDate;
                  //           });
                  //         }
                  //       },
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDeadline != null
                            ? 'Дедлайн: ${DateFormat('dd.MM.yyyy HH:mm', 'ru_RU').format(selectedDeadline!.toLocal())}'
                            : 'Выберите дедлайн',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          // Выбор даты
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            locale: const Locale('ru', 'RU'),
                          );

                          if (pickedDate != null) {
                            // Выбор времени
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              // Объединяем дату и время
                              final selectedDateTime =
                                  DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  ).toUtc().toLocal();

                              setState(() {
                                selectedDeadline = selectedDateTime;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Кнопка для добавления описания
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
                                          onPressed: () {
                                            setState(() {
                                              isDescriptionSet = true;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Сохранить',
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

                      if (isParent)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Очки',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                controller: pointsController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // Только цифры
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Кнопка сохранения
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed:
                            isFormValid
                                ? () {
                                  final title = titleController.text;
                                  final description =
                                      isDescriptionSet
                                          ? descriptionController.text
                                          : 'Без описания';

                                  final formattedDeadline =
                                      selectedDeadline!
                                          .toUtc()
                                          .add(const Duration(hours: 3))
                                          .toIso8601String();

                                  final points =
                                      isParent
                                          ? int.tryParse(
                                                pointsController.text,
                                              ) ??
                                              0
                                          : 0;

                                  // Отправляем событие для создания задачи
                                  parentContext.read<TodoBloc>().add(
                                    TodoCreateRequested(
                                      title: title,
                                      description: description,
                                      assignedTo: selectedMemberId!,
                                      deadline: DateTime.parse(
                                        formattedDeadline,
                                      ),
                                      point: points,
                                    ),
                                  );

                                  Navigator.of(context).pop();
                                }
                                : null,
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
