import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/todo_bloc.dart';
import 'todo_detail_dialog.dart';
import 'todo_edit_dialog.dart';
import 'todo_utils.dart';

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
            return const Center(child: Text('No assigned todos found.'));
          }
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];
              final tileColor = getTileColor(todo.status);
              final formattedDate = formatDate(todo.deadline);

              return GestureDetector(
                onTap: () {
                  // Открываем диалог с подробной информацией о задаче
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return BlocProvider.value(
                        value: context.read<TodoBloc>(),
                        child: TodoDetailsDialog(
                          todo: todo,
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: tileColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      todo.status.toLowerCase() == 'completed'
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: todo.status.toLowerCase() == 'completed'
                          ? Colors.green
                          : Colors.blue,
                      size: 32,
                    ),
                    title: Text(
                      todo.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.description,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Статус: ${todo.status}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is TodoLoadFailure) {
          return const Center(child: Text('Failed to load todos.'));
        }
        return const Center(child: Text('Press refresh to load todos.'));
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
            return const Center(child: Text('No created todos found.'));
          }
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];
              final tileColor = getTileColor(todo.status);
              final formattedDate = formatDate(todo.deadline);

              return GestureDetector(
                onTap: () {
                  // Открываем диалог с подробной информацией о задаче
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return BlocProvider.value(
                        value: context.read<TodoBloc>(),
                        child: TodoDetailsDialog(
                          todo: todo,
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: tileColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      todo.status.toLowerCase() == 'completed'
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: todo.status.toLowerCase() == 'completed'
                          ? Colors.green
                          : Colors.blue,
                      size: 32,
                    ),
                    title: Text(
                      todo.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.description,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Статус: ${todo.status}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Открываем окно редактирования
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return BlocProvider.value(
                              value: context.read<TodoBloc>(),
                              child: TodoEditDialog(
                                todo: todo,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is TodoLoadFailure) {
          return const Center(child: Text('Failed to load todos.'));
        }
        return const Center(child: Text('Press refresh to load todos.'));
      },
    );
  }
}
