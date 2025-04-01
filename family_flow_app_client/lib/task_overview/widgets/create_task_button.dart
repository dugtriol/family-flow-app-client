import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/task_overview_bloc.dart';

class CreateTaskButton extends StatelessWidget {
  const CreateTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateTaskDialog(context),
      child: const Icon(Icons.add),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final deadlineController = TextEditingController();
    final assignedToController = TextEditingController();
    final rewardController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Task'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: deadlineController,
                  decoration:
                      const InputDecoration(labelText: 'Deadline (yyyy-MM-dd)'),
                ),
                TextField(
                  controller: assignedToController,
                  decoration: const InputDecoration(labelText: 'Assigned To'),
                ),
                TextField(
                  controller: rewardController,
                  decoration: const InputDecoration(labelText: 'Reward'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                final deadline = DateTime.parse(deadlineController.text);
                final assignedTo = assignedToController.text;
                final reward = int.parse(rewardController.text);

                context.read<TaskOverviewBloc>().add(
                      TaskOverviewTaskCreated(
                        title: title,
                        description: description,
                        deadline: deadline,
                        assignedTo: assignedTo,
                        reward: reward,
                      ),
                    );

                Navigator.of(dialogContext).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
