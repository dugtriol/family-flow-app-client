import 'package:family_flow_app_client/todo/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_api/todo_api.dart';

class TodoDetailsDialog extends StatelessWidget {
  const TodoDetailsDialog({super.key, required this.todo});

  final TodoItem todo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.info, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              todo.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
              label: 'Описание',
              value: todo.description,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Дедлайн',
              value: todo.deadline.toLocal().toString().split(' ')[0],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.flag,
              label: 'Статус',
              value: todo.status,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Закрыть',
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
        if (todo.status.toLowerCase() != 'completed')
          ElevatedButton(
            onPressed: () {
              context.read<TodoBloc>().add(
                TodoUpdateCompleteRequested(
                  id: todo.id,
                  title: todo.title,
                  description: todo.description,
                  status: "Completed",
                  deadline: todo.deadline,
                  assignedTo: todo.assignedTo,
                ),
              );
              Navigator.of(context).pop(); // Закрыть диалог
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text(
              'Завершить',
              style: TextStyle(color: Colors.white),
            ),
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
        Icon(icon, color: Colors.deepPurple),
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
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
