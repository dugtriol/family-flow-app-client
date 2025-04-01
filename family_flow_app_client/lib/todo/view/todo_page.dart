import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_repository/todo_repository.dart';
import '../bloc/todo_bloc.dart';
import 'widgets/widgets.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoRepository = RepositoryProvider.of<TodoRepository>(context);
    return BlocProvider(
      create: (context) => TodoBloc(
        todoRepository: todoRepository,
      )..add(TodoAssignedToRequested()), // Загружаем список при инициализации
      child: const TodoView(),
    );
  }
}

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Todos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Обновляем список задач
              context.read<TodoBloc>().add(TodoAssignedToRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoadSuccess) {
            if (state.todos.isEmpty) {
              return const Center(child: Text('No assigned todos found.'));
            }
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: Text(
                    todo.deadline.toLocal().toString().split(' ')[0],
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              },
            );
          } else if (state is TodoLoadFailure) {
            return const Center(child: Text('Failed to load todos.'));
          }
          return const Center(child: Text('Press refresh to load todos.'));
        },
      ),
      floatingActionButton: const CreateTodoButton(), // Используем новый виджет
    );
  }
}
