import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import '../../../family/bloc/family_bloc.dart';
import '../../bloc/todo_bloc.dart';
import 'package:todo_api/todo_api.dart';

class TodoDetailsDialog extends StatelessWidget {
  const TodoDetailsDialog({
    super.key,
    required this.todo,
  });

  final TodoItem todo;

  @override
  Widget build(BuildContext context) {
    final todoBloc = context.read<TodoBloc>(); // Получаем TodoBloc из контекста

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.info, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              todo.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              icon: Icons.description,
              label: 'Description',
              value: todo.description,
            ),
            const SizedBox(height: 16),
            BlocBuilder<FamilyBloc, FamilyState>(
              builder: (context, state) {
                if (state is FamilyLoadSuccess) {
                  final assignedUser = state.members.firstWhere(
                    (member) => member.id == todo.createdBy,
                    orElse: () => User(
                        id: '',
                        role: "",
                        email: "",
                        name: 'Unknown User',
                        familyId: ""),
                  );
                  return _buildDetailRow(
                    icon: Icons.person,
                    label: 'Created by',
                    value: assignedUser.name,
                  );
                } else if (state is FamilyLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return _buildDetailRow(
                    icon: Icons.person,
                    label: 'Assigned To',
                    value: 'Unknown User',
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Deadline',
              value: todo.deadline.toLocal().toString().split(' ')[0],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.flag,
              label: 'Status',
              value: todo.status,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            todoBloc.add(TodoDeleteRequested(
                id: todo.id)); // Отправляем событие удаления
            Navigator.of(context).pop();

            if (ModalRoute.of(context)?.settings.name == 'AssignedTo') {
              todoBloc.add(TodoAssignedToRequested());
            } else {
              todoBloc.add(TodoCreatedByRequested());
            }
          },
          child: const Text('Delete'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
        if (todo.status.toLowerCase() != 'completed') // Проверяем статус задачи
          ElevatedButton(
            onPressed: () {
              todoBloc.add(TodoUpdateCompleteRequested(
                id: todo.id,
                title: todo.title,
                description: todo.description,
                status: "Completed",
                deadline: todo.deadline,
                assignedTo: todo.assignedTo,
              ));
              Navigator.of(context).pop();
            },
            child: const Text('Mark as Done'),
          ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/todo_bloc.dart';
// import 'package:todo_api/todo_api.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/todo_bloc.dart';
// import 'package:todo_api/todo_api.dart';

// class TodoDetailsDialog extends StatelessWidget {
//   const TodoDetailsDialog({
//     super.key,
//     required this.todo,
//   });

//   final TodoItem todo;

//   @override
//   Widget build(BuildContext context) {
//     final todoBloc = context.read<TodoBloc>(); // Получаем TodoBloc из контекста

//     return AlertDialog(
//       title: Text(todo.title),
//       content: Text(todo.description),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Close'),
//         ),
//       ],
//     );
//   }
// }
