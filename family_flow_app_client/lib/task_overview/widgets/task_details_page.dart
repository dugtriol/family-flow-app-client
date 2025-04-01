import 'package:flutter/material.dart';
import 'package:task_repository/task_repository.dart';

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Описание:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(task.description),
            const SizedBox(height: 16),
            Text(
              'Срок выполнения:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(task.deadline.toString()),
            const SizedBox(height: 16),
            Text(
              'Назначено:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(task.assignedTo?.toString() ?? 'Не назначено'),
            const SizedBox(height: 16),
            Text(
              'Награда:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('${task.reward}'),
          ],
        ),
      ),
    );
  }
}
