import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/todo_bloc.dart';
import 'todo_detail_dialog.dart';
import 'package:todo_api/todo_api.dart' show TodoItem;

class TodoTaskList extends StatelessWidget {
  final List<TodoItem> tasks;

  const TodoTaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'Нет задач.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final todo = tasks[index];

        return GestureDetector(
          onTap: () {
            // Открываем диалог с подробной информацией
            showDialog(
              context: context,
              builder: (dialogContext) {
                return BlocProvider.value(
                  value: context.read<TodoBloc>(),
                  child: TodoDetailsDialog(todo: todo),
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: Icon(
                todo.status.toLowerCase() == 'completed'
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: todo.status.toLowerCase() == 'completed'
                    ? Colors.green
                    : Colors.blue,
                size: 24, // Размер иконки
              ),
              title: Text(
                todo.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14, // Размер текста
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.deepPurple,
                size: 14, // Размер иконки
              ),
            ),
          ),
        );
      },
    );
  }
}