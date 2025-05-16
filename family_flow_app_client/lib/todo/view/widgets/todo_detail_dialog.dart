import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:todo_api/todo_api.dart';
import 'package:user_api/user_api.dart' show User;
import '../../../authentication/authentication.dart';
import '../../../family/family.dart';
import '../../bloc/todo_bloc.dart';

class TodoDetailsDialog extends StatefulWidget {
  const TodoDetailsDialog({
    super.key,
    required this.todo,
    required this.currentUserId,
  });

  final TodoItem todo;
  final String currentUserId;

  @override
  State<TodoDetailsDialog> createState() => _TodoDetailsDialogState();
}

class _TodoDetailsDialogState extends State<TodoDetailsDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController pointsController; // Новый контроллер для очков
  late DateTime selectedDeadline;

  late String initialTitle;
  late String initialDescription;
  late DateTime initialDeadline;
  late int initialPoints; // Новое поле для начальных очков

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    descriptionController = TextEditingController(
      text: widget.todo.description,
    );
    pointsController = TextEditingController(
      text: widget.todo.point.toString(), // Инициализация очков
    );
    selectedDeadline = widget.todo.deadline;

    initialTitle = widget.todo.title;
    initialDescription = widget.todo.description;
    initialDeadline = widget.todo.deadline;
    initialPoints = widget.todo.point; // Инициализация начальных очков
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    pointsController.dispose(); // Освобождение контроллера очков
    super.dispose();
  }

  Future<void> _updateTodoIfChanged({String? status}) async {
    final currentTitle = titleController.text;
    final currentDescription =
        descriptionController.text.isEmpty
            ? 'Без описания'
            : descriptionController.text;
    final currentPoints = int.tryParse(pointsController.text) ?? 0; // Очки

    final hasChanges =
        currentTitle != initialTitle ||
        currentDescription != initialDescription ||
        selectedDeadline != initialDeadline ||
        currentPoints != initialPoints;

    if (hasChanges || status != null) {
      context.read<TodoBloc>().add(
        TodoUpdateRequested(
          id: widget.todo.id,
          title: currentTitle,
          description: currentDescription,
          status: status ?? widget.todo.status,
          deadline: selectedDeadline.toUtc(), // Преобразуем в UTC
          assignedTo: widget.todo.assignedTo,
          point: currentPoints, // Передача очков
        ),
      );

      // Обновляем начальные значения
      initialTitle = currentTitle;
      initialDescription = currentDescription;
      initialDeadline = selectedDeadline;
      initialPoints = currentPoints; // Обновление очков
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('ru', 'RU'),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDeadline),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDeadline =
              DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              ).toUtc().toLocal(); // Преобразуем в локальное время
        });
      }
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: () async {
  //       await _updateTodoIfChanged();
  //       return true;
  //     },
  //     child: Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Colors.white,
  //         elevation: 0,
  //         leading: IconButton(
  //           icon: const Icon(Icons.arrow_back, color: Colors.black87),
  //           onPressed: () async {
  //             await _updateTodoIfChanged();
  //             if (mounted) {
  //               Navigator.of(context).pop();
  //             }
  //           },
  //         ),
  //         title: const Text(
  //           'Детали задачи',
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black87,
  //           ),
  //         ),
  //         actions: [
  //           IconButton(
  //             icon: const Icon(Icons.delete, color: Colors.red),
  //             onPressed: () {
  //               context.read<TodoBloc>().add(
  //                 TodoDeleteRequested(id: widget.todo.id),
  //               );
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       ),
  //       body: SingleChildScrollView(
  //         physics: const AlwaysScrollableScrollPhysics(),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(16),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.2),
  //                   blurRadius: 8,
  //                   offset: const Offset(0, 4),
  //                 ),
  //               ],
  //             ),
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Отображение статуса задачи
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 8),
  //                   child: Text(
  //                     _getStatusText(widget.todo.status),
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color: _getStatusColor(widget.todo.status),
  //                     ),
  //                   ),
  //                 ),
  //                 // Название задачи
  //                 Row(
  //                   children: [
  //                     const Icon(Icons.title, color: Colors.deepPurple),
  //                     const SizedBox(width: 16),
  //                     Expanded(
  //                       child: TextField(
  //                         controller: titleController,
  //                         style: const TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.black87,
  //                         ),
  //                         decoration: const InputDecoration(
  //                           border: InputBorder.none,
  //                           hintText: 'Название задачи',
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const Divider(),

  //                 // Описание задачи
  //                 Row(
  //                   children: [
  //                     const Icon(Icons.description, color: Colors.deepPurple),
  //                     const SizedBox(width: 16),
  //                     Expanded(
  //                       child: TextField(
  //                         controller: descriptionController,
  //                         maxLines: null,
  //                         style: const TextStyle(
  //                           fontSize: 16,
  //                           color: Colors.black87,
  //                         ),
  //                         decoration: const InputDecoration(
  //                           border: InputBorder.none,
  //                           hintText: 'Добавить описание',
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const Divider(),

  //                 // Дедлайн
  //                 GestureDetector(
  //                   onTap: () => _selectDate(context),
  //                   child: Row(
  //                     children: [
  //                       const Icon(
  //                         Icons.calendar_today,
  //                         color: Colors.deepPurple,
  //                       ),
  //                       const SizedBox(width: 16),
  //                       Text(
  //                         'Дедлайн: ${DateFormat('dd.MM.yyyy HH:mm', 'ru_RU').format(selectedDeadline.toLocal())}',
  //                         style: const TextStyle(
  //                           fontSize: 16,
  //                           color: Colors.black87,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const Divider(),

  //                 // Очки за задачу
  //                 Row(
  //                   children: [
  //                     const Icon(Icons.star, color: Colors.deepPurple),
  //                     const SizedBox(width: 16),
  //                     Expanded(
  //                       child: TextField(
  //                         controller: pointsController,
  //                         keyboardType: TextInputType.number,
  //                         style: const TextStyle(
  //                           fontSize: 16,
  //                           color: Colors.black87,
  //                         ),
  //                         decoration: const InputDecoration(
  //                           border: InputBorder.none,
  //                           hintText: 'Очки за задачу (по умолчанию 0)',
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const Divider(),

  //                 // Информация о создателе задачи
  //                 Row(
  //                   children: [
  //                     const Icon(Icons.person, color: Colors.grey),
  //                     const SizedBox(width: 16),
  //                     Expanded(
  //                       child: BlocBuilder<FamilyBloc, FamilyState>(
  //                         builder: (context, state) {
  //                           if (state is FamilyLoadSuccess) {
  //                             // Ищем имя создателя задачи по его идентификатору
  //                             final creator = state.members.firstWhere(
  //                               (member) => member.id == widget.todo.createdBy,
  //                               orElse: () => User.empty, // Если не найден
  //                             );

  //                             // Форматируем дату создания
  //                             final createdAt =
  //                                 widget.todo.createdAt != null
  //                                     ? DateFormat(
  //                                       'd MMM, HH:mm',
  //                                       'ru',
  //                                     ).format(widget.todo.createdAt!)
  //                                     : 'Неизвестно';

  //                             return Text(
  //                               'Создано: ${creator.name} $createdAt',
  //                               style: const TextStyle(
  //                                 fontSize: 14,
  //                                 color: Colors.black54,
  //                               ),
  //                             );
  //                           }
  //                           return const Text(
  //                             'Создано: Загрузка...',
  //                             style: TextStyle(
  //                               fontSize: 14,
  //                               color: Colors.black54,
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),

  //                 // Кнопки действий
  //                 if (widget.todo.status != 'Completed' &&
  //                     widget.todo.assignedTo == widget.currentUserId)
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(vertical: 16),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         ElevatedButton(
  //                           onPressed: () async {
  //                             // await _updateTodoIfChanged(status: 'Completed');
  //                             context.read<TodoBloc>().add(
  //                               TodoUpdateCompleteRequested(
  //                                 id: widget.todo.id,
  //                                 title: titleController.text,
  //                                 description:
  //                                     descriptionController.text.isEmpty
  //                                         ? 'Без описания'
  //                                         : descriptionController.text,
  //                                 // status: 'Completed',
  //                                 assignedTo: widget.todo.assignedTo,
  //                                 deadline:
  //                                     selectedDeadline
  //                                         .toUtc(), // Преобразуем в UTC
  //                                 point:
  //                                     int.tryParse(pointsController.text) ?? 0,
  //                               ),
  //                             );
  //                             if (mounted) {
  //                               Navigator.of(context).pop();
  //                             }
  //                           },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.green,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                           ),
  //                           child: const Text(
  //                             'Завершить',
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final isOwner =
        widget.todo.createdBy ==
        widget.currentUserId; // Проверяем, является ли пользователь создателем
    final isCompleted =
        widget.todo.status == 'Completed'; // Проверяем, завершена ли задача

    return WillPopScope(
      onWillPop: () async {
        if (isOwner && !isCompleted) {
          await _updateTodoIfChanged();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () async {
              if (isOwner && !isCompleted) {
                await _updateTodoIfChanged();
              }
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: const Text(
            'Детали задачи',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          actions: [
            if (isOwner &&
                !isCompleted) // Кнопка удаления доступна только создателю и если задача не завершена
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context.read<TodoBloc>().add(
                    TodoDeleteRequested(id: widget.todo.id),
                  );
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  // Отображение статуса задачи
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _getStatusText(widget.todo.status),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(widget.todo.status),
                      ),
                    ),
                  ),
                  // Название задачи
                  Row(
                    children: [
                      const Icon(Icons.title, color: Colors.deepPurple),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: titleController,
                          enabled:
                              isOwner &&
                              !isCompleted, // Поле доступно только создателю и если задача не завершена
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Название задачи',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),

                  // Описание задачи
                  Row(
                    children: [
                      const Icon(Icons.description, color: Colors.deepPurple),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: descriptionController,
                          enabled:
                              isOwner &&
                              !isCompleted, // Поле доступно только создателю и если задача не завершена
                          maxLines: null,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Добавить описание',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),

                  // Дедлайн
                  GestureDetector(
                    onTap:
                        isOwner &&
                                !isCompleted // Дедлайн можно изменить только создателю и если задача не завершена
                            ? () => _selectDate(context)
                            : null,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Дедлайн: ${DateFormat('dd.MM.yyyy HH:mm', 'ru_RU').format(selectedDeadline.toLocal())}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),

                  // Очки за задачу
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.deepPurple),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: pointsController,
                          enabled:
                              isOwner &&
                              !isCompleted, // Поле доступно только создателю и если задача не завершена
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Очки за задачу (по умолчанию 0)',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),

                  // Информация о создателе задачи
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.grey),
                      const SizedBox(width: 16),
                      Expanded(
                        child: BlocBuilder<FamilyBloc, FamilyState>(
                          builder: (context, state) {
                            if (state is FamilyLoadSuccess) {
                              // Ищем имя создателя задачи по его идентификатору
                              final creator = state.members.firstWhere(
                                (member) => member.id == widget.todo.createdBy,
                                orElse: () => User.empty, // Если не найден
                              );

                              // Форматируем дату создания
                              final createdAt =
                                  widget.todo.createdAt != null
                                      ? DateFormat(
                                        'd MMM, HH:mm',
                                        'ru',
                                      ).format(widget.todo.createdAt!)
                                      : 'Неизвестно';

                              return Text(
                                'Создано: ${creator.name} $createdAt',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              );
                            }
                            return const Text(
                              'Создано: Загрузка...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // Кнопки действий
                  if (!isOwner &&
                      !isCompleted) // Кнопки доступны только создателю и если задача не завершена
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              context.read<TodoBloc>().add(
                                TodoUpdateCompleteRequested(
                                  id: widget.todo.id,
                                  title: titleController.text,
                                  description:
                                      descriptionController.text.isEmpty
                                          ? 'Без описания'
                                          : descriptionController.text,
                                  assignedTo: widget.todo.assignedTo,
                                  deadline: selectedDeadline.toUtc(),
                                  point:
                                      int.tryParse(pointsController.text) ?? 0,
                                ),
                              );
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
                              'Завершить',
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
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Active':
        return 'Активно';
      case 'Completed':
        return 'Завершено';
      default:
        return 'Неизвестно';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.deepPurple;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
