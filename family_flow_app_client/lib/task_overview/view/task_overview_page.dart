import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_repository/task_repository.dart';
import '../bloc/task_overview_bloc.dart';
import '../widgets/widgets.dart';

class TaskOverviewPage extends StatelessWidget {
  const TaskOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskRepository = RepositoryProvider.of<TaskRepository>(context);

    return BlocProvider(
      create: (_) => TaskOverviewBloc(taskRepository: taskRepository)
        ..add(TaskOverviewTasksRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Overview'),
        ),
        body: BlocBuilder<TaskOverviewBloc, TaskOverviewState>(
          builder: (context, state) {
            if (state is TaskOverviewLoadInProgress) {
              return const TaskLoading();
            } else if (state is TaskOverviewLoadSuccess) {
              return TaskList(tasks: state.tasks);
            } else if (state is TaskOverviewLoadFailure) {
              return TaskError(error: state.error);
            }
            return const Center(child: Text('No tasks available.'));
          },
        ),
        floatingActionButton: const CreateTaskButton(),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(task: task);
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        trailing: Text('Reward: ${task.reward}'),
        onTap: () {
          // Переход на страницу TaskDetailsPage
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetailsPage(task: task),
            ),
          );
        },
      ),
    );
  }
}

class TaskLoading extends StatelessWidget {
  const TaskLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class TaskError extends StatelessWidget {
  const TaskError({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Failed to load tasks: $error',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
