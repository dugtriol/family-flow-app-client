import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/todo_bloc.dart';
import 'todo_detail_dialog.dart';

class AssignedToListView extends StatelessWidget {
  const AssignedToListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TodoAssignedToLoadSuccess) {
          if (state.todos.isEmpty) {
            return const Center(child: Text('Нет задач.'));
          }
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];

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
                      color:
                          todo.status.toLowerCase() == 'completed'
                              ? Colors.green
                              : Colors.blue,
                      size: 24, // Уменьшенный размер иконки
                    ),
                    title: Text(
                      todo.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14, // Уменьшенный размер текста
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.deepPurple,
                      size: 14, // Уменьшенный размер иконки
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is TodoLoadFailure) {
          return const Center(child: Text('Ошибка загрузки задач.'));
        }
        return const Center(child: Text('Нет задач.'));
      },
    );
  }
}

class CreatedByListView extends StatelessWidget {
  const CreatedByListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TodoCreatedByLoadSuccess) {
          if (state.todos.isEmpty) {
            return const Center(child: Text('Нет задач.'));
          }
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];

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
                      color:
                          todo.status.toLowerCase() == 'completed'
                              ? Colors.green
                              : Colors.blue,
                      size: 24, // Уменьшенный размер иконки
                    ),
                    title: Text(
                      todo.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14, // Уменьшенный размер текста
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.deepPurple,
                      size: 14, // Уменьшенный размер иконки
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is TodoLoadFailure) {
          return const Center(child: Text('Ошибка загрузки задач.'));
        }
        return const Center(child: Text('Нет задач.'));
      },
    );
  }
}
