import 'package:equatable/equatable.dart';
import 'package:task_api/task_api.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime? deadline;
  final String? assignedTo;
  final String createdBy;
  final int reward;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.deadline,
    this.assignedTo,
    required this.createdBy,
    required this.reward,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        deadline,
        assignedTo,
        createdBy,
        reward,
      ];

  factory Task.fromTaskOutput(TaskGetOutput taskOutput) {
    return Task(
      id: taskOutput.id,
      title: taskOutput.title,
      description: taskOutput.description,
      status: taskOutput.status,
      deadline: taskOutput.deadline,
      assignedTo: taskOutput.assignedTo,
      createdBy: taskOutput.createdBy,
      reward: taskOutput.reward,
    );
  }
}
