import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_api/todo_api.dart';
import '../../bloc/todo_bloc.dart';

class TodoDetailsDialog extends StatefulWidget {
  const TodoDetailsDialog({super.key, required this.todo});

  final TodoItem todo;

  @override
  State<TodoDetailsDialog> createState() => _TodoDetailsDialogState();
}

// class _TodoDetailsDialogState extends State<TodoDetailsDialog> {
//   late TextEditingController titleController;
//   late TextEditingController descriptionController;
//   late DateTime selectedDeadline;

//   late String initialTitle;
//   late String initialDescription;
//   late DateTime initialDeadline;

//   @override
//   void initState() {
//     super.initState();
//     titleController = TextEditingController(text: widget.todo.title);
//     descriptionController = TextEditingController(
//       text: widget.todo.description,
//     );
//     selectedDeadline = widget.todo.deadline;

//     initialTitle = widget.todo.title;
//     initialDescription = widget.todo.description;
//     initialDeadline = widget.todo.deadline;
//   }

//   @override
//   void dispose() {
//     titleController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDeadline,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != selectedDeadline) {
//       setState(() {
//         selectedDeadline = picked;
//       });
//     }
//   }

//   Future<void> _updateTodoIfChanged({String? status}) async {
//     final currentTitle = titleController.text;
//     final currentDescription =
//         descriptionController.text.isEmpty
//             ? 'Без описания'
//             : descriptionController.text;

//     final hasChanges =
//         currentTitle != initialTitle ||
//         currentDescription != initialDescription ||
//         selectedDeadline != initialDeadline;

//     if (hasChanges || status != null) {
//       context.read<TodoBloc>().add(
//         TodoUpdateRequested(
//           id: widget.todo.id,
//           title: currentTitle,
//           description: currentDescription,
//           status: status ?? widget.todo.status,
//           deadline: selectedDeadline,
//           assignedTo: widget.todo.assignedTo,
//         ),
//       );

//       // Обновляем начальные значения
//       initialTitle = currentTitle;
//       initialDescription = currentDescription;
//       initialDeadline = selectedDeadline;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         await _updateTodoIfChanged();
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black87),
//             onPressed: () async {
//               await _updateTodoIfChanged();
//               if (mounted) {
//                 Navigator.of(context).pop();
//               }
//             },
//           ),
//           title: const Text(
//             'Детали задачи',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () {
//                 context.read<TodoBloc>().add(
//                   TodoDeleteRequested(id: widget.todo.id),
//                 );
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ),
//         body: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Название задачи
//                   Row(
//                     children: [
//                       const Icon(Icons.title, color: Colors.deepPurple),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: TextField(
//                           controller: titleController,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             hintText: 'Название задачи',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Divider(),

//                   // Описание задачи
//                   Row(
//                     children: [
//                       const Icon(Icons.description, color: Colors.deepPurple),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: TextField(
//                           controller: descriptionController,
//                           maxLines: null,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black87,
//                           ),
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             hintText: 'Добавить описание',
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Divider(),

//                   // Дедлайн
//                   GestureDetector(
//                     onTap: () => _selectDate(context),
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.calendar_today,
//                           color: Colors.deepPurple,
//                         ),
//                         const SizedBox(width: 16),
//                         Text(
//                           'Дедлайн: ${selectedDeadline.toLocal().toString().split(' ')[0]}',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Divider(),

//                   // Статус задачи
//                   Row(
//                     children: [
//                       const Icon(Icons.flag, color: Colors.deepPurple),
//                       const SizedBox(width: 16),
//                       Text(
//                         widget.todo.status == 'Completed'
//                             ? 'Завершено'
//                             : 'Активно',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Divider(),

//                   // Кнопки действий
//                   if (widget.todo.status != 'Completed')
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () async {
//                               await _updateTodoIfChanged(status: 'Completed');
//                               if (mounted) {
//                                 Navigator.of(context).pop();
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: const Text(
//                               'Завершить',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
          deadline: selectedDeadline,
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDeadline) {
      setState(() {
        selectedDeadline = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _updateTodoIfChanged();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () async {
              await _updateTodoIfChanged();
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
                  // Название задачи
                  Row(
                    children: [
                      const Icon(Icons.title, color: Colors.deepPurple),
                      const SizedBox(width: 16),
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
                    onTap: () => _selectDate(context),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Дедлайн: ${selectedDeadline.toLocal().toString().split(' ')[0]}',
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

                  // Статус задачи
                  Row(
                    children: [
                      const Icon(Icons.flag, color: Colors.deepPurple),
                      const SizedBox(width: 16),
                      Text(
                        widget.todo.status == 'Completed'
                            ? 'Завершено'
                            : 'Активно',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),

                  // Кнопки действий
                  if (widget.todo.status != 'Completed')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _updateTodoIfChanged(status: 'Completed');
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
}
